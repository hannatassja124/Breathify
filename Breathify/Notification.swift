//
//  Notification.swift
//  Breathify
//
//  Created by Hannatassja Hardjadinata on 30/04/21.
//

import Foundation
import UserNotifications

struct Notification {
    var id: String
    var title: String
    var datetime: DateComponents
    var body: String
}

class NotificationReminder {
    var notifications: [Notification] = []
    
    func listScheduledNotifications()
    {
        print("kepanggil list pending schedule")
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

            for notification in notifications {
                print("Pending Notif : ", notification)
            }
        }
    }

    func listDeliveredNotifications()
    {
        print("kepanggil list delivered schedule")
        UNUserNotificationCenter.current().getDeliveredNotifications {
            notifications in
            
            for notification in notifications {
                print("Delivered Notif : ", notification)
            }
        }
    }
    
    func removeWithIdentifiers(identifier: [String]){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifier)
        print("Delete pending notif dengan identifier ", identifier)
    }
    
    func removeAllNotification(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Deleted All Notif")
    }
    
    private func requestAuthorization(timeInterval: Double?)
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if granted == true && error == nil {
                self.scheduleNotifications(timeInterval: timeInterval)
            }
        }
    }
    
    func schedule(timeInterval: Double? = 0.0)
    {
        let newTimeInterval = timeInterval != nil ? timeInterval : 0.0
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined, .denied:
                self.requestAuthorization(timeInterval: newTimeInterval)
                print("access", settings.authorizationStatus)
            case .authorized, .provisional:
                self.scheduleNotifications(timeInterval: newTimeInterval)
            default:
                break // Do nothing
            }
        }
    }
    
    private func scheduleNotifications(timeInterval: Double?)
    {
        for notification in notifications
        {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title
            content.body     = notification.body
            content.sound    = .default
            
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: timeInterval == 0.0 ? UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false) : UNTimeIntervalNotificationTrigger(timeInterval: timeInterval!, repeats: false))

            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let id = response.notification.request.identifier
        print("Received notification with ID = \(id)")

        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let id = notification.request.identifier
        print("Received notification with ID = \(id)")

        completionHandler([.sound, .banner])
    }
}
