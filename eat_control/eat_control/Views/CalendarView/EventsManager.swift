
#if KDCALENDAR_EVENT_MANAGER_ENABLED
import Foundation
import EventKit

enum EventsManagerError: Error {
    case Authorization
}

open class EventsManager {
    
    private static let store = EKEventStore()
    
    static func load(from fromDate: Date, to toDate: Date, complete onComplete: @escaping ([CalendarEvent]?) -> Void) {
        
        let q = DispatchQueue.main
        
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
            
            return EventsManager.store.requestAccess(to: EKEntityType.event, completion: {(granted, error) -> Void in
                guard granted else {
                    return q.async { onComplete(nil) }
                }
                EventsManager.fetch(from: fromDate, to: toDate) { events in
                    q.async { onComplete(events) }
                }
            })
        }
        
        EventsManager.fetch(from: fromDate, to: toDate) { events in
            q.async { onComplete(events) }
        }
    }
    
    static func add(event calendarEvent: CalendarEvent) -> Bool {
        
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
            return false
        }
        
        let secondsFromGMTDifference = TimeInterval(TimeZone.current.secondsFromGMT()) * -1
        
        let event = EKEvent(eventStore: store)
        event.title = calendarEvent.title
        event.startDate = calendarEvent.startDate.addingTimeInterval(secondsFromGMTDifference)
        event.endDate = calendarEvent.endDate.addingTimeInterval(secondsFromGMTDifference)
        event.calendar = store.defaultCalendarForNewEvents
        do {
            try store.save(event, span: .thisEvent)
            return true
        } catch {
            return false
        }
    }
    
    private static func fetch(from fromDate: Date, to toDate: Date, complete onComplete: @escaping ([CalendarEvent]) -> Void) {
        
        let predicate = store.predicateForEvents(withStart: fromDate, end: toDate, calendars: nil)
        
        let secondsFromGMTDifference = TimeInterval(TimeZone.current.secondsFromGMT())
        
        let events = store.events(matching: predicate).map {
            return CalendarEvent(
                title:      $0.title,
                startDate:  $0.startDate.addingTimeInterval(secondsFromGMTDifference),
                endDate:    $0.endDate.addingTimeInterval(secondsFromGMTDifference)
            )
        }
        
        onComplete(events)
    }
}
#endif
