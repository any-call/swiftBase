//
//  File.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/8.
//

import Foundation


public enum DataState<Item>: Equatable {
    case idle
    case loading(previous: [Item]?)
    case success([Item])
    case empty
    case failure(message: String, previous: [Item]?)
    
    public static func == (
            lhs: DataState<Item>,
            rhs: DataState<Item>
        ) -> Bool {

            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            case (.success, .success):
                return true
            case (.empty, .empty):
                return true
            case (.failure, .failure):
                return true
            default:
                return false
            }
        }
}


public enum myVM {
    public typealias List<Item> = ListVM<Item> //typealias 不会继承 enum 的 public，必须加public
}
