//
//  date.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/4.
//

import Foundation

public extension Date {
    
    // MARK: - 常用固定格式
    
    /// 2026-02-07 22:15
    var yyyyMMddHHmm: String {
        formatted(
            .dateTime
                .year()
                .month(.twoDigits)
                .day(.twoDigits)
                .hour(.twoDigits(amPM: .omitted))
                .minute(.twoDigits)
        )
    }
    
    /// 2026-02-07
    var yyyyMMdd: String {
        formatted(
            .dateTime
                .year()
                .month(.twoDigits)
                .day(.twoDigits)
        )
    }
    
    /// 22:15
    var HHmm: String {
        formatted(
            .dateTime
                .hour(.twoDigits(amPM: .omitted))
                .minute(.twoDigits)
        )
    }
    
    /// 02-07 22:15
    var MMddHHmm: String {
        formatted(
            .dateTime
                .month(.twoDigits)
                .day(.twoDigits)
                .hour(.twoDigits(amPM: .omitted))
                .minute(.twoDigits)
        )
    }
    
    // MARK: - 自定义格式（支持 yyyy-MM-dd 这种）
    
    func string(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
    
    // MARK: - 相对时间
    
    /// 刚刚 / 5分钟前 / 3小时前 / 昨天 / 2天前
    var relative: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale.current
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    // MARK: - 倒计时（用于到期时间）
    
    /// 距离当前还有多少秒
    var secondsRemaining: Int {
        max(0, Int(timeIntervalSinceNow))
    }
    
    /// 距离当前还有多少天
    var daysRemaining: Int {
        max(0, Int(timeIntervalSinceNow / 86400))
    }
    
    /// 生成 "27天后到期"
    var countdownDescription: String {
        let days = daysRemaining
        if days <= 0 {
            return "已到期"
        } else {
            return "\(days)天后"
        }
    }
}
