//
//  myAppContext.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/14.
//


import Foundation

@objcMembers
public final class AppGroup: NSObject {

    public let appGroupID: String
    public let containerURL: URL
    public let userDefaults: UserDefaults

    public init(appGroupID: String) {
        self.appGroupID = appGroupID

        guard let url = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
        else {
            fatalError("❌ Invalid AppGroupID: \(appGroupID)")
        }

        self.containerURL = url
        self.userDefaults = UserDefaults(suiteName: appGroupID)!
    }

    public func fileURL(_ fileName: String) -> URL {
        containerURL.appendingPathComponent(fileName)
    }
}
