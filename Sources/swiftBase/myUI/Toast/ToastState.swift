//
//  ToastState.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/9.
//


import SwiftUI

public struct ToastState: Identifiable, Equatable {

    public let id = UUID()
    public let message: String
    public let style: Style
    public let position: Position
    public let duration: TimeInterval?

    public enum Style {
        case normal
        case success
        case error
        case warning
    }

    public enum Position {
        case top
        case center
        case bottom
    }

    public init(
        message: String,
        style: Style = .normal,
        position: Position = .top,
        duration: TimeInterval? = 2
    ) {
        self.message = message
        self.style = style
        self.position = position
        self.duration = duration
    }
}