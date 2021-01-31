//
//  EventView.swift
//  CountdownsExtension
//
//  Created by shadow on 29/1/21.
//

import SwiftUI
import WidgetKit

struct EventView: View {
    
    let entry:EventEntry
    let selected:Int
    let utils:Utils = Utils()
    
    var body: some View {
        let combined = utils.combineDateAndTime(entry.event[selected].date, entry.event[selected].time, entry.event[selected].includedTime)
        let days = utils.calculateCountDown(combined)
        HStack(){
            Rectangle().fill(Color(utils.colourSchemeList[entry.event[selected].colour].colorWithHexString())).frame(width: 5, height: 30).padding(4)
            VStack{
                HStack{
                    Text(decode((entry.event[selected].emoji))!)
                    Text(entry.event[selected].name)
                    
                }
                Text(utils.convertDateToString(date: combined))
            }
            Spacer()
            VStack{
                Text(String(days)).font(.title)
                Text(utils.getCountDownDesc(combined))
            }.padding(10)
        }.minimumScaleFactor(0.5).redacted(reason: entry.isPlaceholder ? .placeholder : .init())
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(entry: EventEntry.placeholder,selected: -1).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
