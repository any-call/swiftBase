//
//  File.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/8.
//

import Foundation


public enum DataState<Item> {
    case idle
    case loading(previous: [Item]?)
    case success([Item])
    case empty
    case failure(message: String, previous: [Item]?)
}


public enum myVM {
    typealias List<Item> = ListVM<Item>
}
