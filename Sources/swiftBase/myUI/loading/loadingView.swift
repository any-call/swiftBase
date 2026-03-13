//
//  Untitled.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/13.
//
import SwiftUI

struct LoadingView: View {
    
    let text: String?
    let style: LoadingStyle
    
    var body: some View {
        
        VStack(spacing: style.spacing) {
            
            ProgressView()
                .tint(style.spinnerColor)
                .scaleEffect(style.spinnerScale)
            
            if let text {
                
                Text(text)
                    .font(style.font)
                    .foregroundColor(style.textColor)
                
            }
            
        }
        .padding(style.padding)
        .background(style.background)
        .cornerRadius(style.cornerRadius)
        .fixedSize()
        
    }
}
