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

//MARK: 通用的网络处理入口中断
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

//MARK: 通用网络响应中断
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

//MARK: 业务错误处理回调
public actor NetBusinessHandler {
    
    public static let shared = NetBusinessHandler()
    
    private var handler: ((Int,String) async -> Void)?
    
    public func setHandler(
        _ handler: @escaping (Int,String) async -> Void
    ) {
        self.handler = handler
    }
    
    public func handle(code:Int,msg:String) async {
        await handler?(code,msg)
    }
}

public enum myNet {
}


//MARK: 响应解析
public protocol MyNetResponseParser: Sendable {
    func parse<T: Decodable>(
        data: Data,
        httpCode: Int,
        decoder: JSONDecoder
    ) throws -> T
}
