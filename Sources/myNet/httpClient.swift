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

public struct BaseResp<T:Codable>:Codable {
    let code :Int
    let msg: String
    let data:T?
}

public typealias ReqCallback = (inout URLRequest) throws -> (TimeInterval)
public typealias ParseCallback = (Data,Int) throws -> Void

let ContentTypeJson = "application/json"
let ContentTypeForm = "application/x-www-form-urlencoded"


public func doReq(
    method: HttpMethod,
    url: String,
    reqCB: ReqCallback?,
    parseCB: ParseCallback?
) async throws {

    guard let urlObj = URL(string: url) else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: urlObj)
    request.httpMethod = method.rawValue
    
//    var isTLS = url.lowercased().hasPrefix("https")

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

    try parseCB?(data, httpResp.statusCode)
}


public func getJson(
    url: String,
    inParam: Encodable?,
    timeout: TimeInterval,
    parseCB: ParseCallback?
) async throws {
    
    try await doReq(
           method: .get,
           url: url,
           reqCB: { req in
               req.addValue(ContentTypeJson, forHTTPHeaderField: "Content-Type")

               if let param = inParam {
                   let data = try JSONEncoder().encode(param)
                   req.httpBody = data
               }

               return timeout
           },
           parseCB: parseCB
       )
}

public func postJson(
    url: String,
    inParam: Encodable?,
    timeout: TimeInterval,
    parseCB: ParseCallback?
) async throws {
    
    try await doReq(
        method: .post,
        url: url,
        reqCB: { req in
            req.addValue(ContentTypeJson, forHTTPHeaderField: "Content-Type")
            
            if let param = inParam {
                let data = try JSONEncoder().encode(param)
                req.httpBody = data
            }

            return timeout
        },
        parseCB: parseCB
    )
}

public func getQuery(
    url: String,
    params: [String: String],
    timeout: TimeInterval,
    parseCB: ParseCallback?
) async throws {

    var comp = URLComponents(string: url)!
    comp.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }

    try await doReq(
        method: .get,
        url: comp.string!,
        reqCB: { req in
            req.addValue(ContentTypeForm, forHTTPHeaderField: "Content-Type")
            return timeout
        },
        parseCB: parseCB
    )
}


public func postForm(
    url: String,
    values: [String: String],
    timeout: TimeInterval,
    parseCB: ParseCallback?
) async throws {

    let form = values
        .map { "\($0.key)=\($0.value)" }
        .joined(separator: "&")

    try await doReq(
        method: .post,
        url: url,
        reqCB: { req in
            req.addValue(ContentTypeForm, forHTTPHeaderField: "Content-Type")
            req.httpBody = form.data(using: .utf8)

            return timeout
        },
        parseCB: parseCB
    )
}


//通用响应结构处理
public func parseResponse<T: Codable>(
    data: Data,
    httpCode: Int,
    onCodeErr: ((Int) -> Void)? = nil
) throws -> T? {
    
    guard httpCode == 200 else {
        onCodeErr?(httpCode)
        throw URLError(.badServerResponse)
    }

    let resp = try JSONDecoder().decode(BaseResp<T>.self, from: data)

    if resp.code != 0 {
        onCodeErr?(resp.code)

        throw NSError(
            domain: "API",
            code: resp.code,
            userInfo: [NSLocalizedDescriptionKey: resp.msg]
        )
    }

    return resp.data
}
