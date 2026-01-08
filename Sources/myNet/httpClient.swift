//
//  File.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/6.
//

import Foundation

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

public enum ApiError: LocalizedError {
    case http(code: Int)
    case server(code: Int, msg: String)
    
    public var localizedDescription: String{
        switch self {
        case .http(let code):
            // 返回您希望用户看到的友好描述
            return "HTTP请求失败，状态码：\(code)"
        case .server(let code, let msg):
            return "服务器返回错误：代码 \(code)，信息：\(msg)"
        }
    }
}

public typealias ReqCallback = (inout URLRequest) throws -> (TimeInterval)

let ContentTypeJson = "application/json"
let ContentTypeForm = "application/x-www-form-urlencoded"


public func doReq(
    method: HttpMethod,
    url: String,
    reqCB: ReqCallback?
) async throws ->(Data,Int) {

    guard let urlObj = URL(string: url) else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: urlObj)
    request.httpMethod = method.rawValue

    var timeout: TimeInterval = 30
    if let cb = reqCB {
        timeout = try cb(&request)
    }

    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = timeout

    let session = URLSession(configuration: config)

    let (data, response) = try await session.data(for: request)

    guard let httpResp = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }

    return (data,httpResp.statusCode)
}


public func getJson<T:Decodable>(
    url: String,
    inParam: Encodable?,
    timeout: TimeInterval
) async throws ->T? {
    
    let (data,httpCode) = try await doReq(
           method: .get,
           url: url,
           reqCB: { req in
               req.addValue(ContentTypeJson, forHTTPHeaderField: "Content-Type")

               if let param = inParam {
                   let data = try JSONEncoder().encode(param)
                   req.httpBody = data
               }

               return timeout
           }
       )
    
    return try parseResponse(data: data, httpCode: httpCode)
}

public func postJson<T:Decodable>(
    url: String,
    inParam: Encodable?,
    timeout: TimeInterval
) async throws ->T? {
    
    let (data,code) =  try await doReq(
        method: .post,
        url: url,
        reqCB: { req in
            req.addValue(ContentTypeJson, forHTTPHeaderField: "Content-Type")
            
            if let param = inParam {
                let data = try JSONEncoder().encode(param)
                req.httpBody = data
            }

            return timeout
        }
    )
    return try parseResponse(data: data, httpCode: code)
}

public func getQuery<T:Decodable>(
    url: String,
    params: [String: String],
    timeout: TimeInterval,
) async throws -> T? {
    var comp = URLComponents(string: url)!
    comp.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }

    let (data,code) = try await doReq(
        method: .get,
        url: comp.string!,
        reqCB: { req in
            req.addValue(ContentTypeForm, forHTTPHeaderField: "Content-Type")
            return timeout
        }
    )
    
    return try parseResponse(data: data, httpCode: code)
}


public func postForm<T:Decodable>(
    url: String,
    values: [String: String],
    timeout: TimeInterval,
) async throws -> T? {

    let form = values
        .map { "\($0.key)=\($0.value)" }
        .joined(separator: "&")

    let (data,code) = try await doReq(
        method: .post,
        url: url,
        reqCB: { req in
            req.addValue(ContentTypeForm, forHTTPHeaderField: "Content-Type")
            req.httpBody = form.data(using: .utf8)

            return timeout
        }
    )
    
    return try parseResponse(data: data, httpCode: code)
}


//通用响应结构处理
public func parseResponse<T: Decodable>(
    data: Data,
    httpCode: Int
) throws -> T? {
    
    guard httpCode == 200 else {
        throw ApiError.http(code: httpCode)
    }

    let resp = try JSONDecoder().decode(BaseResp<T>.self, from: data)

    if resp.code != 0 {
        throw ApiError.server(code: resp.code, msg: resp.msg)
    }

    return resp.data
}
