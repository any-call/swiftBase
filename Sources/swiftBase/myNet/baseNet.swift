//
//  File.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/9.
//

import Foundation

let ContentTypeJson = "application/json"
let ContentTypeForm = "application/x-www-form-urlencoded"

public typealias ReqCallback = (inout URLRequest) throws -> (TimeInterval)

public enum HttpMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public struct BaseResp<T:Decodable>:Decodable {
    let code :Int
    let msg: String
    let data:T?
}

/// 通用的网络处理入口
public actor NetRequestInterceptor{
    public static let shared = NetRequestInterceptor()
    
    private var requestInterceptor: ((inout URLRequest) -> Void)?
    
    public func setInterceptor(
        _ interceptor: @escaping (inout URLRequest) -> Void
    ) {
        self.requestInterceptor = interceptor
    }
    
    public func apply(to request: inout URLRequest) {
        requestInterceptor?(&request)
    }
}

public actor NetResponseInterceptor {
    
    public static let shared = NetResponseInterceptor()
    
    private var interceptor: ((Data, Int) async throws -> (Data, Int))?
    
    public func setInterceptor(
        _ handler: @escaping (Data, Int) async throws -> (Data, Int)
    ) {
        interceptor = handler
    }
    
    public func apply(
        data: Data,
        code: Int
    ) async throws -> (Data, Int) {
        
        if let interceptor {
            return try await interceptor(data, code)
        }
        
        return (data, code)
    }
}

public enum myNet {
}
