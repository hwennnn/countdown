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



struct EventTimelineProvider: IntentTimelineProvider {
    typealias Intent = SelectEventIntent
    typealias Entry = EventEntry
    let coredatautils = CoredataUtils()
    
    func placeholder(in context: Context) -> EventEntry {
        EventEntry.placeholder
    }
    
    func getSnapshot(for configuration: SelectEventIntent, in context: Context, completion: @escaping (EventEntry) -> Void) {
        if context.isPreview {
            completion(EventEntry.placeholder)
        }else{
            let entry: EventEntry
            if let event:[Event]? = coredatautils.fetchdata(){
                entry = EventEntry(date: Date(), event: event!,configuration: configuration)
            }else{
                entry = EventEntry.placeholder
            }
            completion(entry)
        }
    }
    
    func getTimeline(for configuration: SelectEventIntent, in context: Context, completion: @escaping (Timeline<EventEntry>) -> Void) {
        if let event:[Event]? = coredatautils.fetchdata(){
            let entry = EventEntry(date: Date(), event: event! ,configuration: configuration)
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
            completion(timeline)
        }else{
            let timeline = Timeline(entries: [EventEntry.placeholder], policy: .after(Date().addingTimeInterval(60)))
            completion(timeline)
        }
    }
}

struct EventEntry: TimelineEntry {
    let date: Date
    var event:[Event]
    var isPlaceholder = false
    var configuration:SelectEventIntent
}

extension EventEntry{
    static var stub: EventEntry{
        EventEntry(date: Date(), event: [.init("", "EventName", "", false, Date(), Date(), Date(), "", 3, 0.0)],configuration: SelectEventIntent())
    }

    static var placeholder: EventEntry{
        EventEntry(date: Date(), event: [.init("", "Doctor appointment", "🏥".encodeEmoji
                                               , false, Date(), Date(), Date(), "", 4, 0.0) ,.init("", "Homework", "📚".encodeEmoji, false, Date(), Date(), Date(), "", 1, 0.0),.init("", "Ballet Reciet", "🩰".encodeEmoji, false, Date(), Date(), Date(), "", 2, 0.0) ], isPlaceholder: true ,configuration: SelectEventIntent())
    }
}

struct CountdownsEntryView : View {
    var entry: EventEntry
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family{
            case .systemMedium:
                CountdownMediumWidget(entry: entry)
            case .systemLarge:
                CountdownLargeWidget(entry: entry)
            default:
                CountdownWidgetSmall(entry: entry)
        }
    }
    
    
}

func decode(_ s: String) -> String? {
    let data = s.data(using: .utf8)!
    return String(data: data, encoding: .nonLossyASCII)
}


@main
struct Countdowns: Widget {
    let kind: String = "Countdown"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,  intent: SelectEventIntent.self, provider: EventTimelineProvider()) { entry in
            CountdownsEntryView(entry:entry)
        }
        .configurationDisplayName("Event Widgets")
        .description("Get updates on events")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct Countdowns_Previews: PreviewProvider {
    static var previews: some View {
        CountdownsEntryView(entry: EventEntry.stub )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension EventParam{
    convenience init(event:Event){
        self.init(identifier: event.id, display: event.name)
    }
}
