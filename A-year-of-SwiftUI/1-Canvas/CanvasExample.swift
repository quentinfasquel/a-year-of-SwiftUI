//
//  CanvasExample.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 28/01/2024.
//

import SwiftUI

// Draw a middle line
//                let middleLine = Path { path in
//                    path.move(to: CGPoint(x: rect.minX, y: rect.midY))
//                    path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
//                }
//                context.stroke(middleLine, with: .color(.white), lineWidth: 1)

// Using a copy of context as a push/pop mechanisme
//                var ctx = context
//                ctx.opacity = 0.3
//                ctx.stroke(middleLine, with: .color(.white), lineWidth: 1)

//            LinearGradient(colors: [.yellow, .blue], startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea()

struct CanvasExample: View {
    var body: some View {
        ZStack {
            Rectangle().fill(.black).ignoresSafeArea()

            Canvas { context, size in
                let rect = CGRect(origin: .zero, size: size)

                // NOTE 1: Draw midline here

                // NOTE 2: Change midline opacity, then using a copy

                // NOTE 3: Background

                // Draw a sinus Wave
                let wave = Path.wave(strength: 50, frequency: 30, in: rect)
//                context.stroke(wave, with: .color(.white), lineWidth: 4)

                if let image = context.resolveSymbol(id: "image") {
                    context.translateBy(x: rect.midX, y: rect.midY)
                    for i in 0..<10 {
                        let radius = Double(120)
                        let angle = Angle.radians(Double(i) * 2 * .pi / 10)
                        var ctx = context
                        ctx.rotate(by: -angle)
                        ctx.opacity = 1 - CGFloat(i) * 0
                        ctx.addFilter(.hueRotation(angle))
                        ctx.draw(image, at: CGPoint(x: radius, y: 0))
                    }
                }
            } symbols: {
                heartImage.tag("image")
            }
        }
    }

    var heartImage: some View {
        Image(systemName: "heart.circle.fill")
            .symbolRenderingMode(.multicolor)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60)
//            .foregroundStyle(.white)
            .rotationEffect(.radians(.pi / 2))
    }
}

#Preview {
    CanvasExample()
}


// MARK: - Wave Path

extension Path {

    static func wave(strength: Double, frequency: Double, phase: Double = 0, in rect: CGRect) -> Path {
        var path = Path()

        // Split our total width up based on the frequency
        let waveLength = rect.width / frequency

        // Start at the left center
        path.move(to: CGPoint(x: 0, y: rect.midY))

        // Now count across individual horizontal points one by one
        for x in stride(from: 0, through: rect.width, by: 1) {
            // Find our current position relative to the wavelength
            let relativeX = x / waveLength

            // find how far we are from the horizontal center
            let distanceFromMidWidth = x - rect.midX
            // bring that into the range of -1 to 1
            let normalDistance = 1 / rect.midX * distanceFromMidWidth
            let parabola = -(normalDistance * normalDistance) + 1

            // Calculate the sine of that position
            let sine = sin(relativeX + phase)

            // Multiply that sine by our strength to determine final offset,
            // then move it down to the middle of our view
            let y = parabola * strength * sine + rect.midY

            // Add a line to here
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }
}
