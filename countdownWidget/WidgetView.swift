//
//  WidgetView.swift
//  countdown
//
//  Created by zachary on 27/1/21.
//

import SwiftUI
import WidgetKit

struct WidgetData{
    let eventName:String
    let date: Date
}

extension WidgetData{
    static let previewData = WidgetData(eventName: "MAD" , date: Date())
}

struct WidgetView:View {
    let data:WidgetData

    var body: some View{
        Text("Hello World")
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            WidgetView(data: .previewData).previewContext(WidgetPreviewContext(family: .systemSmall))
        }

    }
}
