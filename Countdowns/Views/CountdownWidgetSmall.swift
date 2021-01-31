//
//  CountdownWidgetSmall.swift
//  CountdownsExtension
//
//  Created by shadow on 29/1/21.
//

import SwiftUI
import WidgetKit

struct CountdownWidgetSmall: View {
    let entry:EventEntry
    let utils:Utils = Utils()
    
    var body: some View {
        let combined = utils.combineDateAndTime(entry.event[0].date, entry.event[0].time, entry.event[0].includedTime)
        let days = utils.calculateCountDown(combined)
        
        ZStack{
            Color(utils.colourSchemeList[entry.event[0].colour].colorWithHexString()).edgesIgnoringSafeArea(.all)
            VStack( spacing: 10){
                HStack{
                    Text(decode((entry.event[0].emoji))!).foregroundColor(.white)
                    Text(entry.event[0].name).foregroundColor(.white).font(.headline)
                }
                VStack{
                    Text(String(days)).font(.title).foregroundColor(.white)
                    Text(utils.getCountDownDesc(combined)).foregroundColor(.white)
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
