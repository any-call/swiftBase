//
//  int64.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/4.
//
import Foundation

public extension Int64 {
    var msDate : Date {
        Date(timeIntervalSince1970: TimeInterval(self) / 1000)
    }
    
    var  secDate : Date {
        Date(timeIntervalSince1970: TimeInterval(self))
    }
    
    /// 流量格式化
    /// - Parameter use1024: true = 1024进制 (默认)；false = 1000进制
    func trafficString(use1024: Bool = true) -> String {
        
        let formatter = ByteCountFormatter()
        
        formatter.allowedUnits = [
            .useBytes,
            .useKB,
            .useMB,
            .useGB,
            .useTB
        ]
        
        formatter.countStyle = use1024 ? .binary : .decimal
        formatter.includesUnit = true
        formatter.isAdaptive = true
        
        return formatter.string(fromByteCount: self)
    }
}
