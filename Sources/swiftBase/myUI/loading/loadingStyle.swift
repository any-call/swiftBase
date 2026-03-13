//
//  Untitled.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/13.
//


import SwiftUI

public struct LoadingStyle {
    
    public var background: AnyShapeStyle
    public var spinnerColor: Color
    public var spinnerScale: CGFloat
    public var textColor: Color
    public var font: Font
    public var spacing: CGFloat
    public var padding: CGFloat
    public var cornerRadius: CGFloat
    public var maskColor: Color?
    
    public init(
        background: AnyShapeStyle = AnyShapeStyle(.ultraThinMaterial),
        spinnerColor: Color = .primary,
        spinnerScale: CGFloat = 1.0,
        textColor: Color = .primary,
        font: Font = .footnote,
        spacing: CGFloat = 12,
        padding: CGFloat = 16,
        cornerRadius: CGFloat = 12,
        maskColor: Color? = Color.black.opacity(0.2)
    ) {
        
        self.background = background
        self.spinnerColor = spinnerColor
        self.spinnerScale = spinnerScale
        self.textColor = textColor
        self.font = font
        self.spacing = spacing
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.maskColor = maskColor
        
    }
    
}
