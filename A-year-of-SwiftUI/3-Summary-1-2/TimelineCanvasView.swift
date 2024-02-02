//
//  TimelineCanvasView.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 28/01/2024.
//

import SwiftUI

struct TimelineCanvasView: View {
    var startDate = Date.now

    var body: some View {
        ZStack {
            Rectangle().fill(.black.gradient).ignoresSafeArea()

            TimelineView(.animation) { timeline in
                let ellapsedTime = timeline.date.timeIntervalSince(startDate)
                Canvas { context, size in
                    let rect = CGRect(origin: .zero, size: size)
                    let phase: CGFloat = ellapsedTime * .pi * 2
                    let wave = Path.wave(strength: 50, frequency: 30, phase: phase, in: rect)

                    for i in 0..<10 {
                        let strokeColor = Color(white: 1, opacity: Double(i) / 10)
                        let path = wave.offsetBy(dx: 0, dy: CGFloat(i) * 10)
                        context.stroke(path, with: .color(strokeColor), lineWidth: 4)
                    }
                }
                .offset(y: -100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("TimelineView + Canvas")
    }
}

#Preview {
    NavigationStack {
        TimelineCanvasView()
    }
    .preferredColorScheme(.dark)
}
