//
//  DependencyExample.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 06/02/2024.
//

import APIClient
import SwiftUI

struct DependencyExample: View {
    @Dependency(\.apiClient) private var apiClient
    @State private var cities: [City] = []
    @State private var isLoaded: Bool = false
    @State private var refreshToggle: Bool = false

    var body: some View {
        VerticalScrollView {
            ZStack {
                VStack(spacing: 8) {
                    ForEach(cities.indices, id: \.self) { index in
                        Text(cities[index].name)
                            .font(.largeTitle.bold())
                            .opacity(isLoaded ? 1 : 0)
                            .offset(x: 0, y: isLoaded ? 0 : 20)
                            .transaction { transaction in
                                let delay = Double(index) * 0.1
                                transaction.animation = .bouncy(duration: 1).delay(delay)
                            }
                    }
                }

                if !isLoaded {
                    ProgressView()
                        .controlSize(.large)
                }
            }
        }
        .background(.black.gradient)
        .overlay(alignment: .bottom) {
            Button { refreshToggle.toggle() } label: {
                Label("Refresh", systemImage: "arrow.clockwise.circle.fill")
//                    .labelStyle(.iconOnly)
                    .imageScale(.large)
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 22).weight(.semibold))
            }
        }
        .task(id: refreshToggle) {
            self.isLoaded = false
            self.cities = []
            self.cities = await apiClient.cities()
            withAnimation(.smooth) {
                self.isLoaded = true
            }
        }
    }
}

#Preview {
    DependencyExample()
        .preferredColorScheme(.dark)
}
