//
// Created for UICalendarView_SwiftUI
// by Stewart Lynch on 2022-06-29
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import SwiftUI

struct StartTabView: View {
    @EnvironmentObject var myEvents: EventStore
    var body: some View {
        TabView{
            EventsListView()
                .tabItem {
                    Label("List", systemImage: "list.triangle")
                }
            EventsCalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                    
                }
        }
    }
}

struct StartTabView_Previews: PreviewProvider {
    static var previews: some View {
        StartTabView()
            .environmentObject(EventStore(preview: true))
    }
}
