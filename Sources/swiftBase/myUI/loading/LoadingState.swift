//
//  LoadingState.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/10.
//


import SwiftUI

public enum LoadingState: Equatable {
    case hidden
    case loading(style: LoadingStyle)

    public static var fullscreen: LoadingState {
        .loading(style: .fullscreen)
    }

    public static var overlay: LoadingState {
        .loading(style: .overlay)
    }
}