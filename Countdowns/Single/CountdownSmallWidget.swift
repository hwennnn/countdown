//
//  CountdownWidgetSmall.swift
//  CountdownsExtension
//
//  Created by shadow on 29/1/21.
//

import SwiftUI
import WidgetKit

func fetchEvent(entry:SingleEventEntry) -> Event {
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
    if entry.event.count == 0 {
        return SingleEventEntry.placeholder.event[0]
    }else{
        return entry.event[0]
    }
    
}

struct CountdownSmallWidget: View {
    let entry:SingleEventEntry
    let utils:Utility = Utility()
   
    var body: some View {
        let event:Event = fetchEvent(entry: entry)
        let combined = utils.combineDateAndTime(event.date, event.time, event.includedTime)
        let days = utils.calculateCountDown(combined)
        
        ZStack{
            Color(utils.colourSchemeList[event.colour].colorWithHexString()).edgesIgnoringSafeArea(.all)
            VStack( spacing: 10){
                HStack{
                    Text(utils.decode((event.emoji))!).foregroundColor(.white)
                    Text(event.name).foregroundColor(.white).font(.subheadline).lineLimit(1)
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
        CountdownSmallWidget(entry:SingleEventEntry.placeholder).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
    
}
