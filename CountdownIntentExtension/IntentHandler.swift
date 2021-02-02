//
//  IntentHandler.swift
//  CountdownIntentExtension
//
//  Created by shadow on 31/1/21.
//

import Intents
import CoreData
import WidgetKit

// fetching available events from coredata populating options when editing widget
class IntentHandler: INExtension,SelectEventIntentHandling{
    func provideEventOptionsCollection(for intent: SelectEventIntent, with completion: @escaping (INObjectCollection<EventParam>?, Error?) -> Void) {
            let coredatautils = CoredataUtils()
            let events = coredatautils.fetchdata()
            let items = events.map {
                EventParam(identifier: $0.id, display: $0.name)
            }
            completion(INObjectCollection(items: items), nil)
    }

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        return self
    }
    
}
