//
//  haptic.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/13.
//

#if os(iOS)
import UIKit

extension myUI {
    
    public enum Haptic {
        
        @MainActor
        public static func light() {
            impact(.light)
        }
        
        @MainActor
        public static func medium() {
            impact(.medium)
        }
        
        @MainActor
        public static func heavy() {
            impact(.heavy)
        }
        
        @MainActor
        private static func impact(
            _ style: UIImpactFeedbackGenerator.FeedbackStyle
        ) {
            
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
            
        }
        
    }
    
}
#endif
