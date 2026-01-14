//
//  myApp.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/14.
//


import Foundation

/// App / Extension 必须提供的上下文信息
public protocol AppProvider {
    /// App Group ID
    var appGroupID: String { get }
}


/// myApp 命名空间（统一入口）
public enum myApp {

    // ⚠️ 明确告诉编译器：我知道这是全局可变状态，但我自己保证安全
    nonisolated(unsafe)
    private static var _appGroup: AppGroup?

    /// 对外只读
    public static var appGroup: AppGroup {
        guard let value = _appGroup else {
            fatalError("❌ myApp.appGroup 未初始化，请先调用 myApp.setup(appGroupID:)")
        }
        return value
    }

    /// 启动时调用（只允许一次）
    public static func setup(appGroupID: String) {
        precondition(_appGroup == nil, "❌ myApp.setup 只能调用一次")
        _appGroup = AppGroup(appGroupID: appGroupID)
    }
}
