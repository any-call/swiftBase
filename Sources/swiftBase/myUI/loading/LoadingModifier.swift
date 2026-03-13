//
//  LoadingModifier.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/10.
//


import SwiftUI

struct LoadingModifier: ViewModifier {
    
    let state: LoadingState
    let interaction: LoadingInteraction
    let style: LoadingStyle
    
    func body(content: Content) -> some View {
        
        switch state {
            
        case .hidden:
            
            content
            
        case .overlay(let text):
            content.overlay {
                
                ZStack {
                    
                    if let mask = style.maskColor {
                        
                        mask
                            .ignoresSafeArea()
                        
                    }
                    
                    LoadingView(
                        text: text,
                        style: style
                    )
                    
                }
                .allowsHitTesting(interaction == .block)
            }
            
        case .replace(let text):
            
            LoadingView(
                text: text,
                style: style
            )
            .allowsHitTesting(interaction == .block)
            
        }
        
    }
    
}
