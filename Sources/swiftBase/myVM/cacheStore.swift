//
//  cacheStore.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/5.
//

import Foundation

public struct CacheStore {
    
    public static func save<T: Codable>(_ object: T, key: String) throws {
        let data = try JSONEncoder().encode(object)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    public static func load<T: Codable>(_ type: T.Type, key: String) throws -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        
        return try JSONDecoder().decode(type, from: data)
    }
    
    public static func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
