//
//  ToastManager.swift
//  iosVpn
//
//  Created by jinguihua on 2026/3/15.
//

import Foundation
import Combine
import SwiftUI

@MainActor
public final class ToastManager: ObservableObject {
    
    public static let shared = ToastManager()
    
    @Published var toast: ToastData?
    
    public func show(
        message: String,
        duration: TimeInterval = 3,
        style: ToastStyle? = nil,
        position: ToastPosition = .top
    ) {
        let finalStyle = style ?? ToastStyle()
        
        let data = ToastData(
            message: message,
            duration: duration,
            style: finalStyle,
            position: position
        )
        
        toast = data
        
        Task { @MainActor in
            
            try? await Task.sleep(
                nanoseconds: UInt64(duration * 1_000_000_000)
            )
            
            if toast?.id == data.id {
                
                withAnimation {
                    toast = nil
                }
            }
        }
    }
}
