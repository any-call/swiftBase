//
//  ToastView.swift
//  iosVpn
//
//  Created by jinguihua on 2026/3/15.
//

import SwiftUI

struct ToastView: View {
    
    let toast: ToastData
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            if let icon = toast.style.icon {
                Image(systemName: icon)
            }
            
            Text(toast.message)
        }
        .font(toast.style.font)
        .foregroundColor(toast.style.textColor)
        .padding(.horizontal, toast.style.horizontalPadding)
        .padding(.vertical, toast.style.verticalPadding)
        .background(toast.style.backgroundColor)
        .clipShape(
            RoundedRectangle(
                cornerRadius: toast.style.cornerRadius
            )
        )
        .shadow(radius: toast.style.shadowRadius)
        .onTapGesture {
            withAnimation {
                ToastManager.shared.toast = nil
            }
        }
        
    }
}


public struct ToastHost: View {
    
    @ObservedObject var manager = ToastManager.shared
    
    public init() {}
    
    public var body: some View {
        
        GeometryReader { geo in
            
            if let toast = manager.toast {
                
                ToastView(toast: toast)
                    .frame(maxWidth: .infinity)
                    .padding(toastPadding(for: toast.position, geo: geo))
                    .transition(
                        .move(edge: edge(for: toast.position))
                        .combined(with: .opacity)
                    )
            }
        }
        .animation(.easeInOut, value: manager.toast?.id)
    }
}


private func toastPadding(
    for position: ToastPosition,
    geo: GeometryProxy
) -> EdgeInsets {
    
    switch position {
        
    case .top:
        return EdgeInsets(
            top: 60,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        
    case .center:
        return EdgeInsets(
            top: geo.size.height / 2 - 40,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        
    case .bottom:
        return EdgeInsets(
            top: 0,
            leading: 16,
            bottom: 100,
            trailing: 16
        )
    }
}

private func edge(
    for position: ToastPosition
) -> Edge {
    
    switch position {
        
    case .top:
        return .top
        
    case .center:
        return .top
        
    case .bottom:
        return .bottom
    }
}
