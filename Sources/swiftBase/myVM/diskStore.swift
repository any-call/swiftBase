//
//  diskFileStore.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/6.
//


import Foundation

public struct DiskFileStore {
    private static let dir: URL = {
        FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0]
    }()
    
    private static func url(for key: String) -> URL {
        dir.appendingPathComponent(key)
    }
    
    public static func save<T: Codable>(_ object: T, key: String) throws {
        let data = try JSONEncoder().encode(object)
        try data.write(to: url(for: key))
    }
    
    public static func load<T: Codable>(_ type: T.Type, key: String) throws -> T? {
        let url = url(for: key)
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(type, from: data)
    }
    
    public static func remove(key: String) {
        try? FileManager.default.removeItem(at: url(for: key))
    }
}
