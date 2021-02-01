//
//  MultieventWidget.swift
//  countdown
//
//  Created by shadow on 1/2/21.
//

import WidgetKit
import CoreData
import SwiftUI

struct MultiEventTimelineProvider: TimelineProvider {
    
    typealias Entry = MultiEventEntry
    let coredatautil = CoredataUtils()
 
    func placeholder(in context: Context) -> MultiEventEntry {
        MultiEventEntry.placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MultiEventEntry) -> Void) {
        if context.isPreview {
            completion(MultiEventEntry.placeholder)
        }else{
            let entry: MultiEventEntry
            if let event:[Event]? = coredatautil.fetchdata(){
                entry = MultiEventEntry(date: Date(), event: event!)
            }else{
                entry = MultiEventEntry.placeholder
            }
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MultiEventEntry>) -> Void) {
        if let event:[Event]? = coredatautil.fetchdata(){
            let entry = MultiEventEntry(date: Date(), event: event!)
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
            completion(timeline)
        }else{
            let timeline = Timeline(entries: [MultiEventEntry.placeholder], policy: .after(Date().addingTimeInterval(60)))
            completion(timeline)
        }
    }
}

struct MultiEventEntry: TimelineEntry {
    let date: Date
    var event:[Event]
    var isPlaceholder = false
}

extension MultiEventEntry{
    static var stub: MultiEventEntry{
        MultiEventEntry(date: Date(), event: [.init("", "EventName", "", false, Date(), Date(), Date(), "", 3, 0.0)])
    }

    static var placeholder: MultiEventEntry{
        MultiEventEntry(date: Date(), event: [.init("", "EventName", "", false, Date(), Date(), Date(), "", 3, 0.0)], isPlaceholder: true)
    }
}

struct MultiEventEntryView : View {
    var entry: MultiEventEntry
    @Environment(\.widgetFamily) var family
    var body: some View {
        switch family{
           case .systemLarge:
                CountdownLargeWidget(entry: entry)
           default:
                CountdownMediumWidget(entry: entry)
        }
    }
}


@main
struct MultiEventView: Widget {
    let kind: String = "Countdown"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MultiEventTimelineProvider(), content: { entry in
            MultiEventEntryView(entry: entry)
        })
        .configurationDisplayName("Multi Event Widget")
        .description("Get updates on multi event")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
