//
//  IntentHandler.swift
//  CountdownIntentExtension
//
//  Created by shadow on 31/1/21.
//

import Intents
import CoreData
import WidgetKit

class IntentHandler: INExtension,SelectEventIntentHandling{
    
    let coredatautil = CoredataUtils()
    
    func provideEventOptionsCollection(for intent: SelectEventIntent, with completion: @escaping (INObjectCollection<EventParam>?, Error?) -> Void) {
            let events = coredatautil.fetchdata()
            let items = events.map {
                EventParam(identifier: $0.id, display: $0.name)
            }
            completion(INObjectCollection(items: items), nil)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
      
        
        return self
    }
    
}
