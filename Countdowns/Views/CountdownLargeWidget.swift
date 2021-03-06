//
//  CountdownLargeWidget.swift
//  CountdownsExtension
//
//  Created by zachary on 31/1/21.
//

import SwiftUI
import WidgetKit


//limiting the number of events to 7
func shouldShowViewLarge(c:Int) -> Bool {
    return c < 7
}

// adding blank space when less than 7 events
func shouldPlaceSpacerLarge(entry:EventEntry) -> Bool {
    return entry.event.count < 7
}

struct CountdownLargeWidget: View {
    let entry:EventEntry
    var body: some View {
        
        Color(.white).edgesIgnoringSafeArea(.all).overlay(
            VStack(alignment: .leading,spacing:15){
                VStack(alignment: .leading){
                    ForEach(0 ..< entry.event.count){
                        if shouldShowViewLarge(c:$0){
                            EventView(entry: entry,selected: $0)
                        }
                    }
                }.padding(10)
                if shouldPlaceSpacerLarge(entry: entry){
                    Spacer()
                }
            }
        )
    }
}

struct CountdownLargeWidget_Previews: PreviewProvider {
    static var previews: some View {
        CountdownLargeWidget(entry: EventEntry.placeholder)
                    .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
