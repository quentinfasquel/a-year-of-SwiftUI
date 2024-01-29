//
//  TimelineViewExample.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 28/01/2024.
//

import SwiftUI

struct TimerExample: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var date: Date = .now

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text(string(for: date))
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(.white)
        }
        .onReceive(timer) { _ in
            date = .now
        }
    }
}

struct TimelineViewExample: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            TimelineView(.periodic(from: .now, by: 0.01)) { timeline in
                Text(string(for: timeline.date))
                    .animation(.default, value: timeline.date)
            }
            .font(.system(size: 40, weight: .semibold))
            .foregroundStyle(.white)
        }
    }
}


#Preview {
//    VStack(spacing: 1) {
        TimerExample()
//        TimelineViewExample()
//    }
}

// MARK: - Time Formatter

let timeFormatter = DateFormatter()

func string(for date: Date) -> String {
    timeFormatter.timeStyle = .medium
    return timeFormatter.string(from: date)
}
