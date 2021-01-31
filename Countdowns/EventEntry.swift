//
//  EventEntry.swift
//  CountdownsExtension
//
//  Created by shadow on 29/1/21.
//

import Foundation
import WidgetKit

struct EventEntry : TimelineEntry{
    var date: Date
    let event:Event
    var isPlaceholder = false
    
}

extension EventEntry{
    static var stub: EventEntry{
        EventEntry(date: Date(), event: .init("UX", Date(), Date() , progress: 10.0, false, 1))
    }
    
    static var placeholder: EventEntry{
        EventEntry(date: Date(), event: .init("UX", Date(), Date() , progress: 10.0, false, 1),isPlaceholder: true)
    }
    
}
