//
//  FlutterHomeWidgetBundle.swift
//  FlutterHomeWidget
//
//  Created by 박찬섭 on 3/7/25.
//

import WidgetKit
import SwiftUI

@main
struct FlutterHomeWidgetBundle: WidgetBundle {
    var body: some Widget {
        FlutterHomeWidget()
        FlutterHomeWidgetControl()
        FlutterHomeWidgetLiveActivity()
    }
}
