//
//  CountdownLargeWidget.swift
//  CountdownsExtension
//
//  Created by shadow on 31/1/21.
//

import SwiftUI
import WidgetKit

func shouldShowViewLarge(c:Int) -> Bool {
    return c < 7
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
                Spacer()
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
