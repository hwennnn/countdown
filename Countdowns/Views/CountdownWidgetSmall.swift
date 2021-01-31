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
            if(entry.configuration.Event!.displayString == event.name){
                return event
            }
        } else {
            print("Doesn’t contain a value.")
        }
    }
    return EventEntry.placeholder.event[0]
}

struct CountdownWidgetSmall: View {
    let entry:EventEntry
    let utils:Utils = Utils()
   
    var body: some View {
        let combined = utils.combineDateAndTime(entry.event[0].date, entry.event[0].time, entry.event[0].includedTime)
        let days = utils.calculateCountDown(combined)
        let event:Event = fetchEvent(entry: entry)
        
        ZStack{
            Color(utils.colourSchemeList[event.colour].colorWithHexString()).edgesIgnoringSafeArea(.all)
            VStack( spacing: 10){
                HStack{
                    Text(decode((event.emoji))!).foregroundColor(.white)
                    Text(event.name).foregroundColor(.white).font(.subheadline).lineLimit(2)
                }
                HStack(alignment: .lastTextBaseline){
                    VStack{
                        Text(String(days)).font(.title).foregroundColor(.white)
                        Text(utils.getCountDownDesc(combined)).foregroundColor(.white)
                    }.padding(.trailing,10)
                }
                
                Text(utils.convertDateToString(date: combined)).foregroundColor(.white)
            }
            
        }.redacted(reason: entry.isPlaceholder ? .placeholder : .init())
    }
}

struct CountdownWidgetSmall_Previews: PreviewProvider {
    static var previews: some View {
        CountdownWidgetSmall(entry:EventEntry.placeholder).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
