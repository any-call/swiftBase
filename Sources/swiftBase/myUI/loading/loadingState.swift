//
//  loadingState.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/13.
//
import SwiftUI

public enum LoadingState : Equatable {
    case hidden
    
    /// 覆盖在当前 view 上
    case overlay(text:String? = nil)
    
    /// 替换当前 view
    case replace(text:String? = nil)
}


