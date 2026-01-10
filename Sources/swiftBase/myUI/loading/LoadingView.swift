//
//  LoadingView.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/10.
//


import SwiftUI

struct LoadingView: View {

    let theme: LoadingTheme

    var body: some View {
        ProgressView()
            .progressViewStyle(
                CircularProgressViewStyle(tint: theme.indicatorColor)
            )
            .scaleEffect(theme.indicatorSize / 20)
    }
}