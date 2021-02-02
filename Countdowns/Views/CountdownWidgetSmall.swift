//
//  CountdownWidgetSmall.swift
//  CountdownsExtension
//
//  Created by zachary on 29/1/21.
//

import SwiftUI
import WidgetKit

// fetches event by id , else if cannot be found , the recent one will be return else if defaultview
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
    if entry.event.count > 0 {
        return entry.event[0]
    }
    return EventEntry.defaultview.event[0]
    
}

// helper function to check if a entry is a placeholder
//func shouldDisplayView(entry:EventEntry) -> Bool{
//    return entry.isPlaceholder
//}

struct CountdownWidgetSmall: View {
    let entry:EventEntry
    let utils:Utility = Utility()
   
    var body: some View {
        let event:Event = fetchEvent(entry: entry)
        let combined = utils.combineDateAndTime(event.date, event.time, event.includedTime)
        let days = utils.calculateCountDown(combined)
        
        
        ZStack(alignment: .topLeading){
            Color(utils.colourSchemeList[event.colour].colorWithHexString()).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading){
                    
                HStack(){
                    Text(event.emoji.decodeEmoji).foregroundColor(.black)
                    Text(event.name).bold().foregroundColor(.black).font(.subheadline).lineLimit(2)
                }.lineSpacing(1)
                
                Spacer()
                
                VStack(alignment: .leading)
                {
                    Text(String(days)).font(.title).foregroundColor(.black)
                    Text(utils.getCountDownDesc(combined)).foregroundColor(.black).font(.system(size: 12))
                }
                
                Spacer()

                HStack{
                    Text(utils.convertDateToString(event)).foregroundColor(.black).font(.system(size: 13)).lineLimit(2)
                }
                
            
            }.padding(15)
                
        }
    }
}

struct CountdownWidgetSmall_Previews: PreviewProvider {
    static var previews: some View {
        CountdownWidgetSmall(entry:EventEntry.placeholder).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
    
}
