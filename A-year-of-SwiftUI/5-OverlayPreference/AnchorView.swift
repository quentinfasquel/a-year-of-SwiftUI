//
//  AnchorView.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 29/01/2024.
//

import SwiftUI

struct AnchorView<Content: View, ConditionValue: Any>: View {
    var conditionValue: ConditionValue?
    var anchor: Anchor<CGRect>?
    @ViewBuilder var content: (ConditionValue) -> Content

    init(
        conditionValue: ConditionValue?,
        anchorKey: String,
        in values: [String: Anchor<CGRect>],
        content: @escaping (ConditionValue) -> Content
    ) {
        self.conditionValue = conditionValue
        self.anchor = values[anchorKey]
        self.content = content
    }

    var body: some View {
        GeometryReader { geometryProxy in
            if let conditionValue, let anchor {
                let rect = geometryProxy[anchor]
                content(conditionValue)
                    .frame(width: rect.width, height: rect.height)
                    .offset(x: rect.minX, y: rect.minY)
                    .animation(.snappy, value: rect)
            }
        }
    }
}
