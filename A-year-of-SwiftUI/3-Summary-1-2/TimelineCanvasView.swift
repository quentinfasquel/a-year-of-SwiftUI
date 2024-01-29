//
//  TimelineCanvasView.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 28/01/2024.
//

import SwiftUI

struct TimelineCanvasView: View {
//    @GestureState var draggingY: CGFloat = 0
    @State private var y: CGFloat = 0
    let startDate = Date.now
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Rectangle().fill(.blue).ignoresSafeArea()

            TimelineView(.animation) { timeline in
                let ellapsedTime = timeline.date.timeIntervalSince(startDate)
                Canvas { context, size in
                    let rect = CGRect(origin: .zero, size: size)
                    let phase = ellapsedTime * .pi * 2
                    let wave = Path.wave(strength: 50 + y, frequency: 30, phase: phase, in: rect)

//                    context.stroke(wave, with: .color(.white), lineWidth: 4)

                    for i in 0..<10 {
                        let strokeColor = Color(white: 1, opacity: Double(i) / 10)
                        let path = wave.offsetBy(dx: 0, dy: CGFloat(i) * 10)
                        context.stroke(path, with: .color(strokeColor), lineWidth: 4)
                    }
                }
                .animation(.snappy, value: y)
            }
            .gesture(DragGesture()
//                .updating($y) { value, state, tr in
//
//                    state = value.translation.height
//
//                }
                .onChanged { value in
                    y = value.translation.height
                }
                .onEnded{ value in
//                    withAnimation(.snappy) {
                        y = 0
//                    }
                }
            )

        }
    }
}

#Preview {
    TimelineCanvasView()
}
