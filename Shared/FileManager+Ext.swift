//
//  FileManager+Ext.swift
//  countdown
//
//  Created by shadow on 30/1/21.
//

import Foundation

extension FileManager {
    static let appGroupContainerURL = FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: "group.com.coundown")!
}
