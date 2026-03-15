//
//  ToastStyle.swift
//  iosVpn
//
//  Created by jinguihua on 2026/3/15.
//

import SwiftUI

public struct ToastStyle {
    
    public var backgroundColor: Color
    public var textColor: Color
    public var font: Font
    public var icon: String?
    
    public var cornerRadius: CGFloat
    public var shadowRadius: CGFloat
    public var horizontalPadding: CGFloat
    public var verticalPadding: CGFloat
    
    public init(
        backgroundColor: Color = Color.black.opacity(0.9),
        textColor: Color = .white,
        font: Font = .system(size: 14),
        icon: String? = nil,
        cornerRadius: CGFloat = 10,
        shadowRadius: CGFloat = 2,
        horizontalPadding: CGFloat = 14,
        verticalPadding: CGFloat = 10
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        self.icon = icon
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }
}

public extension ToastStyle {
    
    static var `default`: ToastStyle {
        ToastStyle()
    }
    
    static var success: ToastStyle {
        
        var style = ToastStyle()
        style.backgroundColor = .green.opacity(0.9)
        style.icon = "checkmark.circle.fill"
        return style
    }
    
    static var error: ToastStyle {
        
        var style = ToastStyle()
        style.backgroundColor = .red.opacity(0.9)
        style.icon = "xmark.circle.fill"
        return style
    }
    
    static var warning: ToastStyle {
        
        var style = ToastStyle()
        style.backgroundColor = .orange.opacity(0.9)
        style.icon = "exclamationmark.triangle.fill"
        return style
    }
    
    static var info: ToastStyle {
        
        var style = ToastStyle()
        style.backgroundColor = .blue.opacity(0.9)
        style.icon = "info.circle.fill"
        return style
    }
}
