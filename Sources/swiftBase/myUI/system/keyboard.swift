//
//  keyboard.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/13.
//

#if os(iOS)
import UIKit

extension myUI {
    
    public enum Keyboard {
        
        @MainActor
        public static func hide() {
            
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
            
        }
        
    }
    
}
#endif
