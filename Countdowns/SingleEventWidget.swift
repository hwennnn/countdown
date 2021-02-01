//
//  SingleWidget.swift
//  countdown
//
//  Created by zachary on 1/2/21.
//
import WidgetKit
import SwiftUI
import Intents
import Foundation
import CoreData
import UIKit

let coredatautil = CoredataUtils()

struct SingleEventTimelineProvider: IntentTimelineProvider {
    typealias Intent = SelectEventIntent
    typealias Entry = SingleEventEntry
    
    func placeholder(in context: Context) -> SingleEventEntry {
        SingleEventEntry.placeholder
    }
    
    func getSnapshot(for configuration: SelectEventIntent, in context: Context, completion: @escaping (SingleEventEntry) -> Void) {
        if context.isPreview {
            completion(SingleEventEntry.placeholder)
        }else{
            let entry: SingleEventEntry
            if let event:[Event]? = coredatautil.fetchdata(){
                entry = SingleEventEntry(date: Date(), event: event!,configuration: configuration)
            }else{
                entry = SingleEventEntry.placeholder
            }
            completion(entry)
        }
    }
    
    func getTimeline(for configuration: SelectEventIntent, in context: Context, completion: @escaping (Timeline<SingleEventEntry>) -> Void) {
        if let event:[Event]? = coredatautil.fetchdata(){
            let entry = SingleEventEntry(date: Date(), event: event! ,configuration: configuration)
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
            completion(timeline)
        }else{
            let timeline = Timeline(entries: [SingleEventEntry.placeholder], policy: .after(Date().addingTimeInterval(60)))
            completion(timeline)
        }
    }
}

struct SingleEventEntry: TimelineEntry {
    let date: Date
    var event:[Event]
    var isPlaceholder = false
    var configuration:SelectEventIntent
}

extension SingleEventEntry{
    static var stub: SingleEventEntry{
        SingleEventEntry(date: Date(), event: [.init("", "EventName", "", false, Date(), Date(), Date(), "", 3, 0.0)],configuration: SelectEventIntent())
    }

    static var placeholder: SingleEventEntry{
        SingleEventEntry(date: Date(), event: [.init("", "EventName", "", false, Date(), Date(), Date(), "", 3, 0.0)], isPlaceholder: true ,configuration: SelectEventIntent())
    }
}

struct SingleEventEntryView : View {
    var entry: SingleEventTimelineProvider.Entry
    var body: some View {
        CountdownWidgetSmall(entry: entry)
    }
}


@main
struct SingleEventView: Widget {
    let kind: String = "Countdown"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,  intent: SelectEventIntent.self, provider: SingleEventTimelineProvider()) { entry in
            SingleEventEntryView(entry:entry)
        }
        .configurationDisplayName("Single Event Widget")
        .description("Get updates on one event")
    }
}

//struct SmallEvent_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleEventView(entry: SingleEventEntry.stub )
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}

extension EventParam{
    convenience init(event:Event){
        self.init(identifier: event.id, display: event.name)
    }
}

