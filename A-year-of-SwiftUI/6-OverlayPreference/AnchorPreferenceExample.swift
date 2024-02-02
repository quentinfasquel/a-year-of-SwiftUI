//
//  AnchorPreferenceExample.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 02/02/2024.
//

import SwiftUI

struct AnchorPreferenceExample: View {
    @State private var selectedIndex: Int = 0
    private var cities = [
        "Wimereux",
        "Paris",
        "Los Angeles",
        "Palo Alto",
        "San Francisco",
        "Bordeaux"
    ]

    var body: some View {
        VerticalScrollView {
            VStack(spacing: 38) {
                ForEach(cities.indices, id: \.self) { index in
                    Text(cities[index])
                        .font(selectedIndex == index ? .largeTitle.bold() : .title.bold())
                        .padding(10)
                        .animation(.smooth, value: selectedIndex == index)
                        .onTapGesture { selectedIndex = index }
                        .anchorPreference(key: MyPreferenceKey.self, value: .bounds) { anchor in
                            return [index: anchor]
                        }
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .backgroundPreferenceValue(MyPreferenceKey.self) { preference in
            GeometryReader { geometry in
                if let anchor = preference[selectedIndex] {
                    let frame = geometry[anchor].insetBy(dx: -16, dy: -2)
                    Capsule()
                        .stroke(Color.white, lineWidth: 4)
                        .background(.gray.opacity(0.4), in: Capsule())
                        .frame(width: frame.width, height: frame.height)
                        .offset(x: frame.minX, y: frame.minY)
                        .animation(.smooth, value: selectedIndex)
                }
            }
        }
        .background(.black.gradient)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Anchor Preference")
    }
}

#Preview {
    NavigationStack {
        AnchorPreferenceExample()
    }
    .preferredColorScheme(.dark)
}

// MARK: -

struct MyPreferenceKey: PreferenceKey {
    typealias Value = [Int: Anchor<CGRect>]

    static var defaultValue: Value = [:]
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
}

//                ForEach(cities.indices, id: \.self) { index in
//                    if let anchor = preference[index] {
//                        let frame = geometry[anchor].insetBy(dx: -16, dy: -10)
//                        Capsule().stroke(Color.blue, lineWidth: 2)
//                            .frame(width: frame.width, height: frame.height)
//                            .offset(x: frame.minX, y: frame.minY)
//                    }
//                }

struct VerticalScrollView<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                content().frame(
                    maxWidth: .infinity,
                    minHeight: geometry.size.height
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView2: View {
    @State private var selectedIndex: Int = 0
    private var cities = ["Bordeaux", "Paris", "Lyon", "Lille", "Marseille"]
    private var spaceName = "coordinateSpace"

    var body: some View {
        VerticalScrollView {
            VStack(spacing: 24) {
                ForEach(cities.indices, id: \.self) { index in
                    Text(cities[index])
                        .onTapGesture { selectedIndex = index }
                        .padding(12)
                        .offset(x: .random(in: 0...100))
                        .anchorPreference(key: MyPreferenceKey.self, value: .bounds) { anchor in
                            return [index: anchor]
                        }
                }
            }
            .font(.largeTitle.weight(.bold))
        }
        .coordinateSpace(name: spaceName)
        .overlay {
            /* ... */
        }
    }
}


//#Preview {
//    ContentView2()
//}
