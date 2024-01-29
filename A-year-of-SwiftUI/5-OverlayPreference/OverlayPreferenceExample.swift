//
//  OverlayPreferenceExample.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 28/01/2024.
//

import SwiftUI

fileprivate let iconDataSource = ["heart.fill", "bolt.fill", "suitcase.fill"]

struct AnchorTransition {
    var isPushed: Bool = false
    var isFinished: Bool = false
}

struct OverlayPreferenceExample: View {
    @State private var selectedIcon: String?
    @State private var animation: AnchorTransition = .init()

    var body: some View {
        NavigationStack {
            ListView(selectedIcon: $selectedIcon, animation: $animation)
                .navigationDestination(isPresented: $animation.isPushed) {
                    DetailView(selectedIcon: $selectedIcon, animation: $animation)
//                        .viewBackground(color: .clear)
                }
        }
//        .navigationBackground(color: .clear)
        .overlayPreferenceValue(IconAnchorPreferenceKey.self) { value in
//            GeometryReader { geometryProxy in
//                ForEach(iconDataSource, id: \.self) { icon in
//                    if let anchor = value[icon], selectedIcon == icon  {
//                        let rect = geometryProxy[anchor]
//                        IconView(name: icon)
//                            .frame(width: rect.width, height: rect.height)
//                            .offset(x: rect.minX, y: rect.minY)
//                            // Animate changes of the anchor
//                            .animation(.snappy, value: rect)
//                            // Set hidden when transition is finished
//                            .opacity(animation.isFinished ? 0 : 1)
//                    }
//                }
//            }
            if let selectedIcon {
                AnchorView(conditionValue: selectedIcon, anchorKey: selectedIcon, in: value) { IconView(name: $0).opacity(animation.isFinished ? 0 : 1)
                }
            }
        }
    }
}



// MARK: - List View

struct ListView: View {
    @Binding var selectedIcon: String?
    @Binding var animation: AnchorTransition

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(iconDataSource, id: \.self) { icon in
                    IconView(name: icon)
                        .opacity(selectedIcon == icon ? 0 : 1)
                        .frame(width: 60, height: 60)
                        .anchorPreference(key: IconAnchorPreferenceKey.self, value: .bounds) { anchor in
                            [icon: anchor]
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedIcon = icon
                            animation.isPushed = true
                        }
                }
            }
            .padding(32)
        }
        .scrollContentBackground(.hidden)
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Text("")
//            }
//        }
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
                .ignoresSafeArea(edges: .top)
                .overlay(alignment: .topTrailing) {
                    dismissButton
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)
            // Hide Navigation Bar
            .toolbar(.hidden, for: .navigationBar)
            .navigationTitle(selectedIcon)
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
            Image(systemName: "xmark")
                .foregroundStyle(.white)
                .padding(10)
                .background(.black, in: .circle)
        }
        .padding(.horizontal, 16)
    }

    func dismiss() {
        animation.isFinished = false
        animation.isPushed = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            selectedIcon = nil
        }
    }
}

#Preview {
    OverlayPreferenceExample()
}

// MARK: -

struct IconView: View {
    var name: String
    var color: Color = .blue
    var body: some View {
        Image(systemName: name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(color)
    }
}

enum IconAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]

    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
