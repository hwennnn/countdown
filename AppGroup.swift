//
//  AppGroup.swift
//  countdown
//
//  Created by zachary on 27/1/21.
//

import Foundation

public enum AppGroup: String {
  case facts = "group.com.countdown"

  public var containerURL: URL {
    switch self {
    case .facts:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
