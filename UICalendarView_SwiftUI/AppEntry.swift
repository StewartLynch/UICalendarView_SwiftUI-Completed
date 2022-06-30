//
// Created for UICalendarView_SwiftUI
// by Stewart Lynch on 2022-06-28
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import SwiftUI

@main
struct AppEntry: App {
    @StateObject var myEvents = EventStore(preview: true)

    var body: some Scene {
        WindowGroup {
            StartTabView()
                .environmentObject(myEvents)
        }
    }
}
