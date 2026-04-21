//
//  baseDoh+Data.swift
//  swiftBase
//
//  Created by jinguihua on 2026/4/21.
//

// MARK: - Data Extension

public extension Data {
    
    mutating func appendUInt16(_ value: UInt16) {
        var be = value.bigEndian
        Swift.withUnsafeBytes(of: &be) { rawBuf in
            append(contentsOf: rawBuf)
        }
    }
    
    mutating func appendUInt32(_ value: UInt32) {
        var be = value.bigEndian
        Swift.withUnsafeBytes(of: &be) { rawBuf in
            append(contentsOf: rawBuf)
        }
    }
    
    mutating func appendDNSName(_ name: String) {
        let normalized = name.hasSuffix(".") ? String(name.dropLast()) : name
        if normalized.isEmpty {
            append(0)
            return
        }
        
        let labels = normalized.split(separator: ".", omittingEmptySubsequences: true)
        for label in labels {
            let bytes = Array(label.utf8)
            append(UInt8(bytes.count))
            append(contentsOf: bytes)
        }
        append(0)
    }
    
    func base64URLEncodedString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
