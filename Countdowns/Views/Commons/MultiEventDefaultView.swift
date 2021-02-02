//
//  MultiEventDefaultView.swift
//  CountdownsExtension
//
//  Created by zachary on 2/2/21.


import SwiftUI
import WidgetKit

struct MultiEventDefaultView: View {
    var body: some View {
        VStack{
            Text("😭").font(.largeTitle)
            Text("Countdown is empty!").font(.title).foregroundColor(.white)
        }
    }
}

struct MultiEventDefaultView_previews : PreviewProvider {
    static var previews: some View {
        MultiEventDefaultView().previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

