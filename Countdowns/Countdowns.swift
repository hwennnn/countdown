//
//  Countdowns.swift
//  Countdowns
//
//  Created by shadow on 28/1/21.
//

import WidgetKit
import SwiftUI

@main
struct Countdowns: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        SingleEvent()
        MultiEvent()
    }
}
