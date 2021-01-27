//
//  countdownWidget.swift
//  countdownWidget
//
//  Created by zachary on 27/1/21.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData



struct Provider: IntentTimelineProvider {

    func placeholder(in context: Context) -> countdownEvent {
        countdownEvent(date: Date() , eventName: "do" , configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (countdownEvent) -> ()) {
        
        let entry = countdownEvent(date: Date() , eventName: "do", configuration: ConfigurationIntent())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [countdownEvent] = []
                
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = countdownEvent(date: entryDate, eventName: "do", configuration: ConfigurationIntent())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// Structure of each event
struct countdownEvent: TimelineEntry {
    var date: Date
    var eventName:String
    let configuration: ConfigurationIntent
}

extension Color {
    public static var outlineGreen: Color {
        return Color(decimalRed: 0, green: 0, blue: 0)
    }
    
    public static var darkGreen: Color {
        return Color(decimalRed: 48, green: 209, blue: 88)
    }
    
    public static var lightGreen: Color {
        return Color(decimalRed: 52, green: 199, blue: 89)
    }
    
    public init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
}

// Widget view UI
struct countdownWidgetEntryView : View {
    var entry: Provider.Entry
    var progress: Float = 0.5
    var colors: [Color] = [Color.darkGreen, Color.lightGreen]
    var body: some View {
        ZStack{
            ZStack {
//                        Circle()
//                            .stroke(Color.outlineGreen, lineWidth: 20)
                        Circle()
                            .trim(from: 0, to: CGFloat(progress))
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: colors),
                                    center: .center,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360)
                                ),
                                style: StrokeStyle(lineWidth: 15, lineCap: .round)
                        ).rotationEffect(.degrees(-90))
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.darkGreen)
                            .offset(y: -150)
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(progress > 0.95 ? Color.lightGreen: Color.lightGreen.opacity(0))
                            .offset(y: -150)
                            .rotationEffect(Angle.degrees(360 * Double(progress)))
                            .shadow(color: progress > 0.96 ? Color.black.opacity(0.1): Color.clear, radius: 3, x: 4, y: 0)
            }.frame(idealWidth: 230, idealHeight: 130, alignment: .center).fixedSize()
            VStack{
                Text(entry.eventName)
                Text(entry.eventName)
            }
            
        }
    }
}

// About Widget
@main
struct countdownWidget: Widget {
    let kind: String = "countdownWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            countdownWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Countdown Widget")
        .description("This is a widget for viewing your countdowns.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct countdownWidget_Previews: PreviewProvider {
    static var previews: some View {
        countdownWidgetEntryView(entry: countdownEvent(date: Date(), eventName: "do ",configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
