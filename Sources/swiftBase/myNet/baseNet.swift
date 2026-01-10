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


public enum myNet {
}
