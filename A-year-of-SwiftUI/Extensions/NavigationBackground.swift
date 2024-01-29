//
//  NavigationBackground.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 29/01/2024.
//

import SwiftUI
import SwiftUIIntrospect

extension View {
    func navigationBackground(color: Color) -> some View {
        self.introspect(.navigationStack, on: .iOS(.v16, .v17)) {
            $0.view.backgroundColor = UIColor(color)
            $0.viewControllers.forEach { controller in
                controller.view.backgroundColor = UIColor(color)
            }
        }
    }

    func viewBackground(color: Color) -> some View {
        self.introspect(.viewController, on: .iOS(.v16, .v17)) {
            $0.view.backgroundColor = UIColor(color)
        }
    }
}


