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
            let date = e.date!
            let created_at = e.created_at!
            let progress = e.progress
            let includedTime = e.includeTime
            let reminderPicked = e.reminderPicked
            
            let event = Event(id,name,date,created_at,progress,includedTime, Int(reminderPicked))
            eventList.append(event)
            
        }
    } catch let error as NSError{
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    eventList.sort { (event1, event2) -> Bool in
        return event1.date < event2.date
    }
    
    return eventList
}

//struct Provider: IntentTimelineProvider {
//
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), event: fetchdata(), configuration: ConfigurationIntent())
//    }
//
//    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), event: fetchdata(), configuration: ConfigurationIntent())
//        completion(entry)
//    }
//
//    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry]
//        let entry = SimpleEntry(date: Date(), event: fetchdata(), configuration: ConfigurationIntent())
//        entries = [entry]
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}

struct EventTimelineProvider: TimelineProvider {
    typealias Entry = EventEntry
    
    func placeholder(in context: Context) -> EventEntry {
        EventEntry.placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (EventEntry) -> Void) {
        if context.isPreview {
            completion(EventEntry.placeholder)
        }else{
            let entry: EventEntry
            if let event:[Event]? = fetchdata(){
                entry = EventEntry(date: Date(), event: event![0])
            }else{
                entry = EventEntry.placeholder
            }
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<EventEntry>) -> Void) {

        if let event:[Event]? = fetchdata(){
            let entry = EventEntry(date: Date(), event: event![0])
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60*10)))
            completion(timeline)
        }else{
            let timeline = Timeline(entries: [EventEntry.placeholder], policy: .after(Date().addingTimeInterval(60*2)))
            completion(timeline)
        }


    }
}

struct EventEntry: TimelineEntry {
    let date: Date
    var event:Event?
//    let configuration: ConfigurationIntent
    var isPlaceholder = false
}

extension EventEntry{
    static var stub: EventEntry{
        EventEntry(date: Date(), event: .init("", "UX" , Date() , Date() , 10.0, false, 1))
    }

    static var placeholder: EventEntry{
        EventEntry(date: Date(), event: .init("UX", Date(), Date() , progress: 10.0, false, 1),isPlaceholder: true)
    }
}





struct CountdownsEntryView : View {
    var entry: EventEntry
    let formatter = RelativeDateTimeFormatter()
    let progress:String = "30%"
    let icon = "\u{1F496}"
    
    var body: some View {
        ZStack{
            Color.orange.edgesIgnoringSafeArea(.all)
            VStack( spacing: 10){
                HStack{
                    Text((entry.event?.icon)!).foregroundColor(.white)
                    Text((entry.event?.name)!).foregroundColor(.white).font(.headline)
                }
                Text("Progress: \(progress)").foregroundColor(.white)
                Text(formatter.localizedString(from: DateComponents(day: 36))).font(.title).foregroundColor(.white)
            }
        }
        
        
    }
}

@main
struct Countdowns: Widget {
    let kind: String = "Countdown"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EventTimelineProvider()) { entry in
            CountdownsEntryView(entry:entry)
        }
        .configurationDisplayName("Single Event Widget")
        .description("Get updates on one event")
    }
}

struct Countdowns_Previews: PreviewProvider {
    static var previews: some View {
        CountdownsEntryView(entry: EventEntry.stub )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


