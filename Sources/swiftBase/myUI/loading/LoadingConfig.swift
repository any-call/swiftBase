//
//  LoadingStyle.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/10.
//


import SwiftUI

public struct LoadingConfig: Equatable, Sendable {
    public var text: String?
    public var textColor: Color
    public var spacing: CGFloat

    public init(
        text: String? = nil,
        textColor: Color = .secondary,
        spacing: CGFloat = 8
    ) {
        self.text = text
        self.textColor = textColor
        self.spacing = spacing
    }

    public static let `default` = LoadingConfig()
}
