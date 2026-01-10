//
//  LoadingModifier.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/10.
//


import SwiftUI

struct MyLoadingModifier: ViewModifier {

    @Binding var state: LoadingState
    let theme: LoadingTheme

    init(state: Binding<LoadingState>, theme: LoadingTheme = LoadingTheme()) {
        self._state = state
        self.theme = theme
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content

            switch state {
            case .hidden:
                EmptyView()

            case .fullscreen(let config):
                fullscreen(config)

            case .overlay(let config):
                overlay(config)

            case .inline(let config):
                LoadingContentView(config: config, theme: theme)
                    .allowsHitTesting(false)
            }
        }
    }

    private func fullscreen(_ config: LoadingConfig) -> some View {
        ZStack {
            theme.backgroundColor
                .ignoresSafeArea()

            LoadingContentView(
                config: config,
                theme: theme
            )
        }
    }

    private func overlay(_ config: LoadingConfig) -> some View {
        ZStack {
            theme.backgroundColor

            LoadingContentView(
                config: config,
                theme: theme
            )
        }
    }
}
