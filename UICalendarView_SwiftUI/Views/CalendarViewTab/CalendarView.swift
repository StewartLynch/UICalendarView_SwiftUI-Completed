//
// Created for UICalendarView_SwiftUI
// by Stewart Lynch on 2022-07-01
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import SwiftUI

struct CalendarView: UIViewRepresentable {
    let interval: DateInterval
    @ObservedObject var eventStore: EventStore
    @Binding var dateSelected: DateComponents?
    @Binding var displayEvents: Bool
    
    func makeUIView(context: Context) -> some UICalendarView {
        let view = UICalendarView()
        view.delegate = context.coordinator
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = dateSelection
        return view
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, eventStore: _eventStore)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let changedEvent = eventStore.changedEvent {
            uiView.reloadDecorations(forDateComponents: [changedEvent.dateComponents], animated: true)
            eventStore.changedEvent = nil
        }

        if let movedEvent = eventStore.movedEvent {
            uiView.reloadDecorations(forDateComponents: [movedEvent.dateComponents], animated: true)
            eventStore.movedEvent = nil
        }
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarView
        @ObservedObject var eventStore: EventStore
        init(parent: CalendarView, eventStore: ObservedObject<EventStore>) {
            self.parent = parent
            self._eventStore = eventStore
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView,
                          decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let foundEvents = eventStore.events
                .filter {$0.date.startOfDay == dateComponents.date?.startOfDay}
            if foundEvents.isEmpty { return nil }

            if foundEvents.count > 1 {
                return .image(UIImage(systemName: "doc.on.doc.fill"),
                              color: .red,
                              size: .large)
            }
            let singleEvent = foundEvents.first!
            return .customView {
                let icon = UILabel()
                icon.text = singleEvent.eventType.icon
                return icon
            }
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate,
                           didSelectDate dateComponents: DateComponents?) {
            parent.dateSelected = dateComponents
            guard let dateComponents else { return }
            let foundEvents = eventStore.events
                .filter {$0.date.startOfDay == dateComponents.date?.startOfDay}
            if !foundEvents.isEmpty {
                parent.displayEvents.toggle()
            }
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate,
                           canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }
        
    }
    
    
}
