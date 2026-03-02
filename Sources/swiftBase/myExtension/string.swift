//
//  string.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/2.
//

import CryptoKit
import Foundation

extension String {
    func md5() -> String {
        let data = Data(self.utf8)
        let digest = Insecure.MD5.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
