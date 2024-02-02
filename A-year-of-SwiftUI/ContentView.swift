//
//  ContentView.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 28/01/2024.
//

import SwiftUI

struct ContentView: View {
    enum Example: Identifiable, Hashable, CaseIterable {
        var id: Int { hashValue }
        case canvas
        case timeline
        case timelineCanvas
        case effectModifiers
        case anchorPreference
        case anchorNavigationTransition
        case dependencies
    }

    @State private var path = NavigationPath()
    @State private var fullScreenExample: Example?

    var body: some View {
        NavigationStack(path: $path) {
            VerticalScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(Example.allCases, id: \.self) { example in
                        Button { presentExample(example) } label: {
                            Label(title(for: example), systemImage: "chevron.right")
                                .font(.headline)
                                .padding(16)
                                .background(.white.opacity(0.1), in: Capsule())
                        }
                        .foregroundStyle(.white)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
            }
            .background(Color.black.gradient)
            .navigationTitle("Examples")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Example.self) { example in
                destination(for: example)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("\(Image(systemName: "swift")) Examples")
                }
            }
            .safeAreaInset(edge: .bottom) {
                Text("February 2024 - **Quentin Fasquel**\n*Cocoaheads Bordeaux*")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.tint)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)
                    .background(.black)
            }
        }
        .fullScreenCover(item: $fullScreenExample) { example in
            destination(for: example)
        }
    }

    func title(for example: Example) -> String {
        switch example {
        case .canvas: "Canvas"
        case .timeline: "TimelineView/Canvas Clock"
        case .timelineCanvas: "TimelineView/Canvas Wave"
        case .effectModifiers: "Effect Modifiers"
        case .anchorPreference: "Anchor Preference"
        case .anchorNavigationTransition: "Anchor Navigation Transition"
        case .dependencies: "Dependencies"
        }
    }

    @ViewBuilder func destination(for example: Example) -> some View {
        switch example {
        case .canvas: CanvasExample()
        case .timeline: TimelineViewExample()
        case .timelineCanvas: TimelineCanvasView()
        case .effectModifiers:
            if #available(iOS 17, *) {
                EffectsExample()
            } else {
                Text("Sorry mate, this is iOS 17 minimum")
            }
        case .anchorPreference: AnchorPreferenceExample()
        case .anchorNavigationTransition: AnchorNavigationTransitionExample()
        case .dependencies: DependencyExample()
        }
    }

    func presentExample(_ example: Example) {
        // Anchor Navigation Transition needs to be presented in a fullscreen cover
        if case .anchorNavigationTransition = example {
            fullScreenExample = example
            return
        }

        path.append(example)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
