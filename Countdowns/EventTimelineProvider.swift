//
//  EventTimelineProvider.swift
//  CountdownsExtension
//
//  Created by shadow on 29/1/21.
//

import Foundation
import WidgetKit

struct EventTimelineProvider: TimelineProvider {
    typealias Entry = EventEntry
//    let coredata = EventController()
    
    
    
    func placeholder(in context: Context) -> EventEntry {
        EventEntry.placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (EventEntry) -> Void) {
        if context.isPreview {
            completion(EventEntry.placeholder)
        }else{
            
//            let entry: EventEntry
//            if let event:Event? = coredata.retrieveAllEvent()[0]{
//                entry = EventEntry(date: Date(), event: event!)
//            }else{
//                entry = EventEntry.placeholder
//            }
//            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<EventEntry>) -> Void) {
        
//        if let event:Event? = coredata.retrieveAllEvent()[0]{
//            let entry = EventEntry(date: Date(), event: event!)
//            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60*10)))
//            completion(timeline)
//        }else{
//            let timeline = Timeline(entries: [EventEntry.placeholder], policy: .after(Date().addingTimeInterval(60*2)))
//            completion(timeline)
//        }
        
       
    }
    
    
    
}



