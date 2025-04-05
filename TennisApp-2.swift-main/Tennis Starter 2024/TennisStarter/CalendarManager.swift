import EventKit
import UIKit

class CalendarManager {
    private let eventStore = EKEventStore()

    // Request permission to access calendar
    func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            if let error = error {
                print("Error requesting calendar access: \(error.localizedDescription)")
            }
            completion(granted)
        }
    }

    // Schedule a match and add it to a writable calendar
    func scheduleMatch(title: String, date: Date, duration: TimeInterval = 3600, on viewController: UIViewController) {
        requestCalendarAccess { [weak self] granted in
            guard let self = self else { return }

            if !granted {
                print("Calendar access not granted.")
                return
            }

            // Find a calendar that allows event creation
            guard let calendar = self.eventStore.calendars(for: .event).first(where: { $0.allowsContentModifications }) else {
                print("No writable calendar available.")
                return
            }
           // code adapted from apple Docuentation 2025
            let event = EKEvent(eventStore: self.eventStore)
            event.title = title
            event.startDate = date
            event.endDate = date.addingTimeInterval(duration)
            event.calendar = calendar
           // end of adapted code
            do {
                try self.eventStore.save(event, span: .thisEvent)
                DispatchQueue.main.async {
                    self.showScheduledAlert(title: title, date: date, on: viewController)
                }
                print(" Event saved to calendar: \(event.title ?? "No Title") on \(event.startDate)")
            } catch {
                print(" Error saving event: \(error.localizedDescription)")
            }
        }
    }

    // Show alert confirming the event was scheduled
    private func showScheduledAlert(title: String, date: Date, on viewController: UIViewController) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        let alert = UIAlertController(
            title: "Match Scheduled!",
            message: "\"\(title)\" on \(formatter.string(from: date)) has been added to your calendar.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true)
    }
}

