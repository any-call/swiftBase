//
//  date.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/4.
//

import Foundation

public enum DateDisplayStyle {
    case fixed
    case localized
}

public extension Date {
    
    // MARK: - yyyy-MM-dd HH:mm
    
    func yyyyMMddHHmm(style: DateDisplayStyle = .localized) -> String {
        switch style {
        case .localized:
            return formatted(
                .dateTime
                    .year()
                    .month(.twoDigits)
                    .day(.twoDigits)
                    .hour(.twoDigits(amPM: .omitted))
                    .minute(.twoDigits)
            )
            
        case .fixed:
            return fixedFormat("yyyy-MM-dd HH:mm")
        }
    }
    
    // MARK: - yyyy-MM-dd
    
    func yyyyMMdd(style: DateDisplayStyle = .localized) -> String {
        switch style {
        case .localized:
            return formatted(
                .dateTime
                    .year()
                    .month(.twoDigits)
                    .day(.twoDigits)
            )
            
        case .fixed:
            return fixedFormat("yyyy-MM-dd")
        }
    }
    
    // MARK: - HH:mm
    
    func HHmm(style: DateDisplayStyle = .localized) -> String {
        switch style {
        case .localized:
            return formatted(
                .dateTime
                    .hour(.twoDigits(amPM: .omitted))
                    .minute(.twoDigits)
            )
            
        case .fixed:
            return fixedFormat("HH:mm")
        }
    }
    
    // MARK: - MM-dd HH:mm
    
    func MMddHHmm(style: DateDisplayStyle = .localized) -> String {
        switch style {
        case .localized:
            return formatted(
                .dateTime
                    .month(.twoDigits)
                    .day(.twoDigits)
                    .hour(.twoDigits(amPM: .omitted))
                    .minute(.twoDigits)
            )
            
        case .fixed:
            return fixedFormat("MM-dd HH:mm")
        }
    }
    
    // MARK: - 固定格式核心函数
    
    private func fixedFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter.string(from: self)
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
    
    /// 转为 int64 的时间错
    /// 秒
    var unix:Int64 {
        Int64(timeIntervalSince1970)
    }
    
    /// 毫秒
    var unixMilli:Int64 {
        Int64(timeIntervalSince1970 * 1000)
    }
    
    /// 微秒
    var unixMicro:Int64 {
        Int64(timeIntervalSince1970 * 1_000_000)
    }
    
    /// 纳秒
    var unixNano:Int64 {
        Int64(timeIntervalSince1970 * 1_000_000_000)
    }
}
