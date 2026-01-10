//
//  View+Loading.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/10.
//


import SwiftUI

public extension View {

    func myLoading(
        _ state: Binding<LoadingState>,
        theme: LoadingTheme = LoadingTheme()
    ) -> some View {
        self.modifier(
            MyLoadingModifier(
                state: state,
                theme: theme
            )
        )
    }
}
