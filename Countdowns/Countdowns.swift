//
//  Countdowns.swift
//  Countdowns
//
//  Created by shadow on 28/1/21.
//

import WidgetKit
import SwiftUI
import Intents
import Foundation
import CoreData
import UIKit

@main
struct Countdowns:WidgetBundle{
    var body : some Widget{
        SingleEventWidget()
        MultiEventWidget()
    }
}

