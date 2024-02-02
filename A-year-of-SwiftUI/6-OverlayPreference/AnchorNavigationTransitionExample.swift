//
//  OverlayPreferenceExample.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 28/01/2024.
//

import SwiftUI

fileprivate let iconDataSource = [
    "heart.fill",
    "bolt.fill",
    "suitcase.fill",
    "leaf.fill",
    "star.fill",
    "hand.raised.fill",
]

struct AnchorTransition {
    var isPushed: Bool = false
    var isFinished: Bool = false
}

struct AnchorNavigationTransitionExample: View {
    @State private var selectedIcon: String?
    @State private var animation: AnchorTransition = .init()

    var body: some View {
        NavigationStack {
            ListView(selectedIcon: $selectedIcon, animation: $animation)
                .navigationDestination(isPresented: $animation.isPushed) {
                    DetailView(selectedIcon: $selectedIcon, animation: $animation)
                }
        }
        .overlayPreferenceValue(IconAnchorPreferenceKey.self) { value in
            GeometryReader { geometryProxy in
                ForEach(iconDataSource, id: \.self) { icon in
                    if let anchor = value[icon], selectedIcon == icon  {
                        let rect = geometryProxy[anchor]
                        IconView(name: icon)
                            .frame(width: rect.width, height: rect.height)
                            .offset(x: rect.minX, y: rect.minY)
                            // Animate changes of the anchor
                            .animation(.snappy, value: rect)
                            // Set hidden when transition is finished
                            .opacity(animation.isFinished ? 0 : 1)
                    }
                }
            }
        }
    }
}

#Preview {
    AnchorNavigationTransitionExample()
        .preferredColorScheme(.dark)
}

// MARK: - List View

struct ListView: View {
    @Binding var selectedIcon: String?
    @Binding var animation: AnchorTransition
    @Environment(\.dismiss) private var dismissExample

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 8) {
                ForEach(iconDataSource, id: \.self) { icon in
                    IconView(name: icon)
                        .opacity(selectedIcon == icon ? 0 : 1)
                        .frame(width: 60, height: 60)
                        .anchorPreference(key: IconAnchorPreferenceKey.self, value: .bounds) { anchor in
                            [icon: anchor]
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 24))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedIcon = icon
                            animation.isPushed = true
                        }
                }
            }
            .padding(16)
        }
        .scrollContentBackground(.hidden)
        .background(Color.black.gradient)
        .safeAreaInset(edge: .bottom) {
            Button { dismissExample() } label: {
                Label("Dismiss", systemImage: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .imageScale(.large)
                    .font(.system(size: 22).weight(.semibold))
            }
        }
    }
}

// MARK: - Detail View

struct DetailView: View {
    @Binding var selectedIcon: String?
    @Binding var animation: AnchorTransition

    var body: some View {
        if let selectedIcon {
            VStack {
                VStack {
                    if animation.isFinished {
                        IconView(name: selectedIcon)
                    } else {
                        Color.clear
                    }
                }
                .anchorPreference(key: IconAnchorPreferenceKey.self, value: .bounds) { anchor in
                    animation.isPushed ? [selectedIcon: anchor] : [:]
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .topTrailing) {
                    dismissButton
                }

                VStack {
                    switch selectedIcon {
                    case iconDataSource[0]:
                        Text("This is a beautiful heart.")
                    case iconDataSource[1]:
                        Text("There's electricity in the air...")
                    case iconDataSource[2]:
                        Text("Pack your bags!")
                    case iconDataSource[3]:
                        Text("Is the grass greener on the other side?")
                    case iconDataSource[4]:
                        Text("Yellow Starfish")
                    case iconDataSource[5]:
                        Text("A blueman's hand")
                    default:
                        EmptyView()
                    }
                }
                .font(.largeTitle.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                .opacity(animation.isFinished ? 1 : 0)
                .animation(.default, value: animation.isFinished)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            // Hide Navigation Bar
            .toolbar(.hidden, for: .navigationBar)
            .navigationTitle(selectedIcon)
            .background(Color.black.gradient)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    animation.isFinished = true
                }
            }
        } else {
            Color.clear
        }
    }

    var dismissButton: some View {
        Button(action: dismiss) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 36))
                .symbolRenderingMode(.hierarchical)
        }
        .padding(.horizontal, 24)
        .tint(.white)
    }

    func dismiss() {
        animation.isFinished = false
        animation.isPushed = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            selectedIcon = nil
        }
    }
}


// MARK: -

struct IconView: View {
    var name: String
    var color: Color?
    var body: some View {
        Image(systemName: name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .symbolRenderingMode(color == nil ? .multicolor : .monochrome)
            .foregroundStyle(color ?? .black)
    }
}

enum IconAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]

    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
