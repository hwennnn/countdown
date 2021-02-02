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
    let utils:Utility = Utility()
    
    var body: some View {
        let combined = utils.combineDateAndTime(entry.event[selected].date, entry.event[selected].time, entry.event[selected].includedTime)
        let days = utils.calculateCountDown(combined)
        HStack(){
            Rectangle().fill(Color(utils.colourSchemeList[entry.event[selected].colour].colorWithHexString())).frame(width: 5, height: 40).padding(4)
            VStack(alignment: .leading){
                HStack{
                    Text(decode((entry.event[selected].emoji))!)
                    Text(entry.event[selected].name).bold().foregroundColor(.black)
                }.lineLimit(1)
                Text(utils.convertDateToString(entry.event[selected])).font(.system(size: 13)).foregroundColor(.black)
            }
            Spacer()
            VStack{
                Text(String(days)).font(.system(size: 20)).bold().foregroundColor(.black)
                Text(utils.getCountDownDesc(combined)).font(.system(size: 13)).foregroundColor(.black)
            }.padding(5)
        }.minimumScaleFactor(0.5)
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(entry: EventEntry.placeholder,selected: -1).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
