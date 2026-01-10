//
//  LoadingStyle.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/10.
//


import SwiftUI

public enum LoadingStyle: Equatable {
    /// 覆盖整个屏幕，禁止交互
    case fullscreen

    /// 覆盖当前 view，禁止交互
    case overlay

    /// 只显示指示器，不阻塞交互（高级用法）
    case inline
}