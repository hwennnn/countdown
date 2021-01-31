//
//  EventView.swift
//  CountdownsExtension
//
//  Created by shadow on 29/1/21.
//

import SwiftUI
import WidgetKit

struct EventView: View {
    
    
    var body: some View {
        HStack{
            Divider().foregroundColor(.blue)
            Text("\u{2665}")
            Text("Hello")
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView().previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
