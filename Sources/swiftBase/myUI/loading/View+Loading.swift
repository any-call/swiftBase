//
//  View+Loading.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/10.
//


import SwiftUI

public extension View {
    
    func myLoading(
        _ state: LoadingState,
        interaction: LoadingInteraction = .block,
        style: LoadingStyle = LoadingStyle()
    ) -> some View {
        
        modifier(
            LoadingModifier(
                state: state,
                interaction: interaction,
                style: style
            )
        )
        
    }
    
}
