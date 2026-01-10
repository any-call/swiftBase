//
//  LoadingModifier.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/10.
//


import SwiftUI

struct LoadingModifier: ViewModifier {

    @Binding var state: LoadingState
    let theme: LoadingTheme

    func body(content: Content) -> some View {
        ZStack {
            content

            switch state {
            case .hidden:
                EmptyView()

            case .loading(let style):
                overlayView(style: style)
            }
        }
    }

    @ViewBuilder
    private func overlayView(style: LoadingStyle) -> some View {
        switch style {

        case .fullscreen:
            theme.backgroundColor
                .ignoresSafeArea()
                .overlay(LoadingView(theme: theme))
                .allowsHitTesting(true)

        case .overlay:
            theme.backgroundColor
                .overlay(LoadingView(theme: theme))
                .allowsHitTesting(true)

        case .inline:
            LoadingView(theme: theme)
                .allowsHitTesting(false)
        }
    }
}