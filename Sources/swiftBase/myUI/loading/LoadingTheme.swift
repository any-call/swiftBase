//
//  LoadingTheme.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/10.
//


import SwiftUI

public struct LoadingTheme {
    public let indicatorColor: Color
    public let backgroundColor: Color
    public let indicatorSize: CGFloat

    public init(
        indicatorColor: Color = .white,
        backgroundColor: Color = Color.black.opacity(0.4),
        indicatorSize: CGFloat = 36
    ) {
        self.indicatorColor = indicatorColor
        self.backgroundColor = backgroundColor
        self.indicatorSize = indicatorSize
    }
}