//
//  FlutterHomeWidgetLiveActivity.swift
//  FlutterHomeWidget
//
//  Created by 박찬섭 on 3/7/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FlutterHomeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct FlutterHomeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FlutterHomeWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension FlutterHomeWidgetAttributes {
    fileprivate static var preview: FlutterHomeWidgetAttributes {
        FlutterHomeWidgetAttributes(name: "World")
    }
}

extension FlutterHomeWidgetAttributes.ContentState {
    fileprivate static var smiley: FlutterHomeWidgetAttributes.ContentState {
        FlutterHomeWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FlutterHomeWidgetAttributes.ContentState {
         FlutterHomeWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FlutterHomeWidgetAttributes.preview) {
   FlutterHomeWidgetLiveActivity()
} contentStates: {
    FlutterHomeWidgetAttributes.ContentState.smiley
    FlutterHomeWidgetAttributes.ContentState.starEyes
}
