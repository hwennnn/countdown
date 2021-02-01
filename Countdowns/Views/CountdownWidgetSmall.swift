//
//  CountdownWidgetSmall.swift
//  CountdownsExtension
//
//  Created by shadow on 29/1/21.
//

import SwiftUI
import WidgetKit

func fetchEvent(entry:EventEntry) -> Event {
    for event in entry.event{
        if entry.configuration.Event != nil {
            if(entry.configuration.Event!.identifier == event.id){
                return event
            }
        } else {
            print("Doesn’t contain a value.")
        }
    }
    WidgetCenter.shared.reloadAllTimelines()
    return EventEntry.placeholder.event[0]
    
}

struct CountdownWidgetSmall: View {
    let entry:EventEntry
    let utils:Utility = Utility()
   
    var body: some View {
        let event:Event = fetchEvent(entry: entry)
        let combined = utils.combineDateAndTime(event.date, event.time, event.includedTime)
        let days = utils.calculateCountDown(combined)
        
        ZStack{
            Color(utils.colourSchemeList[event.colour].colorWithHexString()).edgesIgnoringSafeArea(.all)
            VStack( spacing: 10){
                HStack{
                    Text(decode((event.emoji))!).foregroundColor(.white)
                    Text(event.name).foregroundColor(.white).font(.subheadline).lineLimit(2)
                }
                
                
                VStack(alignment: .leading)
                {
                    Text(String(days)).font(.title).foregroundColor(.white)
                    Text(utils.getCountDownDesc(combined)).foregroundColor(.white)
                }.padding(.trailing,65)
                
                Text(utils.convertDateToString(event)).foregroundColor(.white).font(.subheadline)
            }
            
        }.redacted(reason: entry.isPlaceholder ? .placeholder : .init())
    }
}

struct CountdownWidgetSmall_Previews: PreviewProvider {
    static var previews: some View {
        CountdownWidgetSmall(entry:EventEntry.placeholder).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
    
}
