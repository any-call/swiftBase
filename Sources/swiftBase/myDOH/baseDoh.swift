//
//  baseDoh.swift
//  swiftBase
//
//  Created by jinguihua on 2026/4/21.
//

import Foundation
import CryptoKit

public enum myDOH {
    
    // MARK: - Provider
    
    public struct DoHProvider: Sendable {
        public let name: String
        public let endpoint: String
        
        public init(name: String, endpoint: String) {
            self.name = name
            self.endpoint = endpoint
        }
    }
    
    public static let AliDoH = DoHProvider(
        name: "aliyun",
        endpoint: "https://dns.alidns.com/dns-query"
    )
    
    public static let TencentDoH = DoHProvider(
        name: "tencent",
        endpoint: "https://doh.pub/dns-query"
    )
    
    public static let CloudflareDoH = DoHProvider(
        name: "cloudflare",
        endpoint: "https://cloudflare-dns.com/dns-query"
    )
    
    // MARK: - DNS constants
    
    private static let dnsTypeTXT: UInt16 = 16
    private static let dnsClassIN: UInt16 = 1
    
    // MARK: - Error
    
    public enum DoHError: LocalizedError {
        case invalidURL(String)
        case invalidHTTPResponse
        case badHTTPStatus(String, Int, String)
        case invalidDNSPacket(String)
        case dnsResponseError(String, Int)
        case emptyTXT(String)
        
        public var errorDescription: String? {
            switch self {
            case .invalidURL(let s):
                return "invalid URL: \(s)"
            case .invalidHTTPResponse:
                return "invalid HTTP response"
            case .badHTTPStatus(let provider, let code, let body):
                return "[\(provider)] http status=\(code) body=\(body)"
            case .invalidDNSPacket(let provider):
                return "[\(provider)] invalid dns packet"
            case .dnsResponseError(let provider, let rcode):
                return "[\(provider)] dns rcode=\(rcode)"
            case .emptyTXT(let provider):
                return "[\(provider)] empty TXT"
            }
        }
    }
    
    // MARK: - Build DNS Query
    
    static func buildDNSQueryWire(name: String, qtype: UInt16) -> Data {
        var data = Data()
        
        let id: UInt16 = 0
        let flags: UInt16 = 0x0100   // RD=1
        let qdCount: UInt16 = 1
        let anCount: UInt16 = 0
        let nsCount: UInt16 = 0
        let arCount: UInt16 = 0
        
        data.appendUInt16(id)
        data.appendUInt16(flags)
        data.appendUInt16(qdCount)
        data.appendUInt16(anCount)
        data.appendUInt16(nsCount)
        data.appendUInt16(arCount)
        
        data.appendDNSName(name)
        data.appendUInt16(qtype)
        data.appendUInt16(dnsClassIN)
        
        return data
    }
    
    // MARK: - GET
    
    public static func queryTXTByDoHGET(
        timeout: TimeInterval,
        provider: DoHProvider,
        domain: String
    ) async throws -> [String] {
        
        let wire = buildDNSQueryWire(name: domain, qtype: dnsTypeTXT)
        let enc = wire.base64URLEncodedString()
        
        guard var comps = URLComponents(string: provider.endpoint) else {
            throw DoHError.invalidURL(provider.endpoint)
        }
        
        comps.queryItems = [
            URLQueryItem(name: "dns", value: enc)
        ]
        
        guard let url = comps.url else {
            throw DoHError.invalidURL(provider.endpoint)
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.timeoutInterval = timeout
        req.setValue("application/dns-message", forHTTPHeaderField: "Accept")
        req.setValue("swift-doh-client/1.0", forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let httpResp = response as? HTTPURLResponse else {
            throw DoHError.invalidHTTPResponse
        }
        
        guard httpResp.statusCode == 200 else {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw DoHError.badHTTPStatus(provider.name, httpResp.statusCode, body)
        }
        
        return try parseTXTResponse(data, provider: provider)
    }
    
    // MARK: - POST
    
    public static func queryTXTByDoHPOST(
        timeout: TimeInterval,
        provider: DoHProvider,
        domain: String
    ) async throws -> [String] {
        
        let wire = buildDNSQueryWire(name: domain, qtype: dnsTypeTXT)
        
        guard let url = URL(string: provider.endpoint) else {
            throw DoHError.invalidURL(provider.endpoint)
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.timeoutInterval = timeout
        req.httpBody = wire
        req.setValue("application/dns-message", forHTTPHeaderField: "Accept")
        req.setValue("application/dns-message", forHTTPHeaderField: "Content-Type")
        req.setValue("swift-doh-client/1.0", forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let httpResp = response as? HTTPURLResponse else {
            throw DoHError.invalidHTTPResponse
        }
        
        guard httpResp.statusCode == 200 else {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw DoHError.badHTTPStatus(provider.name, httpResp.statusCode, body)
        }
        
        return try parseTXTResponse(data, provider: provider)
    }
    
    // MARK: - Query API
    
    public static func QueryTxt(
        timeout: TimeInterval,
        domain: String
    ) async throws -> [String] {
        
        do {
            return try await queryTXTByDoHGET(
                timeout: timeout,
                provider: AliDoH,
                domain: domain
            )
        } catch {
            do {
                return try await queryTXTByDoHGET(
                    timeout: timeout,
                    provider: TencentDoH,
                    domain: domain
                )
            } catch {
                return try await queryTXTByDoHGET(
                    timeout: timeout,
                    provider: CloudflareDoH,
                    domain: domain
                )
            }
        }
    }
    
    public static func QueryTxtByProvider(
        timeout: TimeInterval,
        domain: String,
        provider: DoHProvider
    ) async throws -> [String] {
        try await queryTXTByDoHGET(
            timeout: timeout,
            provider: provider,
            domain: domain
        )
    }
    
    public static func QuerySingleTxt(
        timeout: TimeInterval,
        domain: String
    ) async throws -> String {
        let txts = try await QueryTxt(timeout: timeout, domain: domain)
        guard let first = txts.first, !first.isEmpty else {
            throw DoHError.emptyTXT("all")
        }
        return first
    }
    
    // MARK: - 加密/解密 Text
    /// EncryptTxt 将明文字符串加密为一个可传输的字符串。
    /// 输出格式为：base64(nonce + ciphertext + tag)。
    /// key 长度必须是 16、24、32 字节，分别对应 AES-128、AES-192、AES-256。
    
    public static func EncryptTxt(_ text: String, key: Data) throws -> String {
        guard [16, 24, 32].contains(key.count) else {
            throw CryptoError.invalidKeyLength(key.count)
            
        }
    
        let symKey = SymmetricKey(data: key)
        let plainData = Data(text.utf8)
        let sealedBox = try AES.GCM.seal(plainData, using: symKey)
        
        
        
        guard let combined = sealedBox.combined else {
            
            throw CryptoError.encryptFailed
            
        }
        
        return combined.base64EncodedString()
    }
    
    
    
    /// DecryptTxt 将加密字符串解密为原始明文字符串。
    /// 输入格式必须是：base64(nonce + ciphertext + tag)。
    /// key 长度必须是 16、24、32 字节，且必须与加密时使用的 key 一致。
    public static func DecryptTxt(_ encText: String, key: Data) throws -> String {
        guard [16, 24, 32].contains(key.count) else {
            throw CryptoError.invalidKeyLength(key.count)
        }
        
        guard let raw = Data(base64Encoded: encText) else {
            throw CryptoError.invalidBase64
        }
        
        let symKey = SymmetricKey(data: key)
        let sealedBox = try AES.GCM.SealedBox(combined: raw)
        let plainData = try AES.GCM.open(sealedBox, using: symKey)
        
        guard let text = String(data: plainData, encoding: .utf8) else {
            throw CryptoError.invalidUTF8
        }
        
        return text
        
    }
    
    
    public enum CryptoError: LocalizedError {
        case invalidKeyLength(Int)
        case invalidBase64
        case invalidUTF8
        case encryptFailed
        public var errorDescription: String? {
            switch self {
            case .invalidKeyLength(let n):
                return "invalid key length: \(n)"
            case .invalidBase64:
                return "invalid base64 text"
            case .invalidUTF8:
                return "invalid utf8 text"
            case .encryptFailed:
                return "encrypt failed"
            }
        }
    }
    
    // MARK: - Parse DNS Response
    
    private static func parseTXTResponse(_ data: Data, provider: DoHProvider) throws -> [String] {
        var reader = DNSReader(data: data)
        
        guard
            let _ = reader.readUInt16(),
            let flags = reader.readUInt16(),
            let qdCount = reader.readUInt16(),
            let anCount = reader.readUInt16(),
            let nsCount = reader.readUInt16(),
            let arCount = reader.readUInt16()
        else {
            throw DoHError.invalidDNSPacket(provider.name)
        }
        
        let rcode = Int(flags & 0x000F)
        if rcode != 0 {
            throw DoHError.dnsResponseError(provider.name, rcode)
        }
        
        for _ in 0..<qdCount {
            guard reader.skipName(),
                  reader.skip(2),
                  reader.skip(2) else {
                throw DoHError.invalidDNSPacket(provider.name)
            }
        }
        
        let totalRR = Int(anCount + nsCount + arCount)
        var txts: [String] = []
        
        for idx in 0..<totalRR {
            guard reader.skipName(),
                  let type = reader.readUInt16(),
                  let _ = reader.readUInt16(),
                  let _ = reader.readUInt32(),
                  let rdLength = reader.readUInt16(),
                  let rdata = reader.readData(count: Int(rdLength)) else {
                throw DoHError.invalidDNSPacket(provider.name)
            }
            
            if idx < Int(anCount), type == dnsTypeTXT {
                txts.append(parseTXTStrings(from: rdata))
            }
        }
        
        return txts
    }
    
    private static func parseTXTStrings(from rdata: Data) -> String {
        let bytes = Array(rdata)
        var pos = 0
        var parts: [String] = []
        
        while pos < bytes.count {
            let len = Int(bytes[pos])
            pos += 1
            
            guard pos + len <= bytes.count else { break }
            
            let sub = Data(bytes[pos..<pos + len])
            if let s = String(data: sub, encoding: .utf8) {
                parts.append(s)
            } else {
                parts.append(String(decoding: sub, as: UTF8.self))
            }
            pos += len
        }
        
        return parts.joined()
    }
}

// MARK: - DNS Reader

private struct DNSReader {
    let data: Data
    var offset: Int = 0
    
    init(data: Data) {
        self.data = data
    }
    
    mutating func readUInt16() -> UInt16? {
        guard offset + 2 <= data.count else { return nil }
        let v = (UInt16(data[offset]) << 8) | UInt16(data[offset + 1])
        offset += 2
        return v
    }
    
    mutating func readUInt32() -> UInt32? {
        guard offset + 4 <= data.count else { return nil }
        let v = (UInt32(data[offset]) << 24)
        | (UInt32(data[offset + 1]) << 16)
        | (UInt32(data[offset + 2]) << 8)
        | UInt32(data[offset + 3])
        offset += 4
        return v
    }
    
    mutating func readData(count: Int) -> Data? {
        guard offset + count <= data.count else { return nil }
        let sub = data.subdata(in: offset ..< offset + count)
        offset += count
        return sub
    }
    
    mutating func skip(_ count: Int) -> Bool {
        guard offset + count <= data.count else { return false }
        offset += count
        return true
    }
    
    mutating func skipName() -> Bool {
        var pos = offset
        var loop = 0
        
        while true {
            guard pos < data.count else { return false }
            let len = data[pos]
            
            if (len & 0xC0) == 0xC0 {
                guard pos + 1 < data.count else { return false }
                offset = pos + 2
                return true
            }
            
            if len == 0 {
                offset = pos + 1
                return true
            }
            
            pos += 1
            let n = Int(len)
            guard pos + n <= data.count else { return false }
            pos += n
            
            loop += 1
            if loop > 128 { return false }
        }
    }
}
