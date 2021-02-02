//
//  CountdownMediumWidget.swift
//  CountdownsExtension
//
//  Created by shadow on 31/1/21.
//

import SwiftUI
import WidgetKit
import Foundation

func shouldShowViewMedium(c:Int) -> Bool {
    return c < 3
}

struct CountdownMediumWidget: View {
    let entry:EventEntry

    var body: some View {
        Color(.white).edgesIgnoringSafeArea(.all).overlay(
            VStack(alignment: .leading,spacing:15){
                VStack(alignment: .leading){
                    ForEach(0 ..< entry.event.count){
                        if shouldShowViewMedium(c:$0){
                            EventView(entry: entry,selected: $0)
                        }
                    }
                }.padding(10)
                Spacer()
            }
        )
        
    }
}



struct CountdownMediumWidget_Previews: PreviewProvider {
    static var previews: some View {
        CountdownMediumWidget(entry: EventEntry.placeholder)
                    .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

