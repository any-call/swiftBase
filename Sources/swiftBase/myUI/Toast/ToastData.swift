//
//  ToastData.swift
//  iosVpn
//
//  Created by jinguihua on 2026/3/15.
//

import Foundation

public enum ToastPosition {
    case top
    case center
    case bottom
}

struct ToastData: Identifiable {
    
    let id = UUID()
    
    let message: String
    
    let duration: TimeInterval
    
    let style: ToastStyle
    
    let position: ToastPosition
}
