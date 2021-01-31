//
//  CountdownMediumWidget.swift
//  CountdownsExtension
//
//  Created by shadow on 31/1/21.
//

import SwiftUI
import WidgetKit

struct CountdownMediumWidget: View {
    let entry:EventEntry
    
    var body: some View {
        VStack{
            ForEach(0 ..< entry.event.count){
                EventView(entry: entry,selected: $0)
            }
        }.padding(10).redacted(reason: entry.isPlaceholder ? .placeholder : .init())
    }
}

struct CountdownMediumWidget_Previews: PreviewProvider {
    static var previews: some View {
        CountdownMediumWidget(entry: EventEntry.placeholder)
                    .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

