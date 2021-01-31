//
//  AppGroup.swift
//  countdown
//
//  Created by shadow on 30/1/21.
//

import Foundation

public enum AppGroup: String {
  case facts = "group.com.coundown"

  public var containerURL: URL {
    switch self {
    case .facts:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
