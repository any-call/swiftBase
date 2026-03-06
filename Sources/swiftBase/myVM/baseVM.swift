//
//  File.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/8.
//

import Foundation


public enum DataState: Equatable {
    case idle
    case loading
    case success
    case empty
    case failure(message: String)
}


public enum myVM {
    public typealias List<Item:Codable> = ListVM<Item> //typealias 不会继承 enum 的 public，必须加public
    public typealias Object<Item: Codable> = ObjectVM<Item>
    public typealias CachePrefStore  = UserDefaultsStore
    public typealias CacheDisk = DiskFileStore
}
