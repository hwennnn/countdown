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

var colourSchemeList:[String] = ["#DFC8F2", "#A0C5E8", "#AEFFBD", "#FFEAAB", "#5854D5", "#D92728"]
var selectedName:String = ""

// MARK: - Core Data stack
var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSCustomPersistentContainer(name: "countdown")
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()

// MARK: - Core Data Saving support

func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

func fetchdata() -> ([Event]){
    let managedContext = persistentContainer.viewContext
    var eventList:[Event] = []
    var events:[CDEvent] = []

    let fetchRequest = NSFetchRequest<CDEvent>(entityName: "CDEvent")
    do {
        events = try managedContext.fetch(fetchRequest)

        for e in events{
            let id = e.eventID!
            let name = e.name!
            let emoji = e.emoji!
            let includedTime = e.includedTime
            let date = e.date!
            let time = e.time!
            let created_at = e.created_at!
            let reminders = e.reminders!
            let colour = Int(e.colour)
            let progress = e.progress

            let event = Event(id,name,emoji,includedTime,date,time,created_at,reminders,colour,progress)
            eventList.append(event)
            WidgetCenter.shared.reloadAllTimelines()

        }
    } catch let error as NSError{
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    eventList.sort { (event1, event2) -> Bool in
        return event1.date < event2.date
    }
    
    return eventList
}

struct EventTimelineProvider: IntentTimelineProvider {
    typealias Intent = SelectEventIntent
    
    typealias Entry = EventEntry
    
    func placeholder(in context: Context) -> EventEntry {
        EventEntry.placeholder
    }
    
    func getSnapshot(for configuration: SelectEventIntent, in context: Context, completion: @escaping (EventEntry) -> Void) {
        if context.isPreview {
            completion(EventEntry.placeholder)
        }else{
            let entry: EventEntry
            if let event:[Event]? = fetchdata(){
                print(selectedName)
                entry = EventEntry(date: Date(), event: event!,configuration: configuration)
            }else{
                entry = EventEntry.placeholder
            }
            completion(entry)
        }
    }
    
    func getTimeline(for configuration: SelectEventIntent, in context: Context, completion: @escaping (Timeline<EventEntry>) -> Void) {
        if let event:[Event]? = fetchdata(){
            let entry = EventEntry(date: Date(), event: event! ,configuration: configuration)
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(1)))
            completion(timeline)
        }else{
            let timeline = Timeline(entries: [EventEntry.placeholder], policy: .after(Date().addingTimeInterval(1)))
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
        EventEntry(date: Date(), event: [.init("", "EventName", "", false, Date(), Date(), Date(), "", 3, 0.0)], isPlaceholder: true ,configuration: SelectEventIntent())
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
