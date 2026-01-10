//
//  LoadingState.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/10.
//


import SwiftUI

public enum LoadingState: Equatable {
    case hidden
    case fullscreen(LoadingConfig) ///// 覆盖整个屏幕，禁止交互
    case overlay(LoadingConfig) ///// 覆盖当前 view，禁止交互
    case inline(LoadingConfig) ///// 只显示指示器，不阻塞交互（高级用法）

    public static var fullscreenDefault: LoadingState {
        .fullscreen(.default)
    }

    public static var overlayDefault: LoadingState {
        .overlay(.default)
    }
    
    public static var inlineDefault: LoadingState {
        .inline(.default)
    }
}

