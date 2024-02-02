//
//  TimelineViewExample.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 28/01/2024.
//

import SwiftUI

struct TimelineViewExample: View {
    enum Symbol: Hashable {
        case time
    }

    var body: some View {
        ZStack {
            Rectangle().fill(.black.gradient).ignoresSafeArea()
            TimelineView(.periodic(from: .now, by: 0.01)) { timeline in
                Canvas { context, size in
                    if let time = context.resolveSymbol(id: Symbol.time) {
                        context.draw(time, at: CGPoint(
                            x: size.width * 0.5,
                            y: size.height * 0.5
                        ))
                        context.scaleBy(x: 1, y: -1)
                        context.opacity = 0.4
                        context.addFilter(.blur(radius: 3))
                        context.draw(time, at: CGPoint(
                            x: size.width * 0.5,
                            y: -size.height * 0.5 - 30))
                    }
                } symbols: {
                    Text(string(for: timeline.date))
                        .font(.system(size: 40, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.foreground)
                        .animation(.default, value: timeline.date)
                        .contentTransition(.numericText())
                        .tag(Symbol.time)
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationStack {
        TimelineViewExample()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Timeline View")
    }
    .preferredColorScheme(.dark)
}

// MARK: - Time Formatter

let timeFormatter = DateFormatter()

func string(for date: Date) -> String {
    timeFormatter.timeStyle = .medium
    return timeFormatter.string(from: date)
}
