//
//  NotificationManager.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 28.03.24.
//

import UIKit
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func scheduleRecipeSuggestionsNotifications() {
        scheduleNotification(title: "დილა მშვიდობისა", body: "☀️ დილა რომ ენერგიულად დაიწყო, მიიღე საუზმის რეკომენდაციები აპლიკაციაში", hour: 9, minute: 30)
        scheduleNotification(title: "შუადღე მშვიდობისა", body: "მგონი უკვე დროა სადილისთვის მზადება დაიწყო 🍔", hour: 15, minute: 0)
        scheduleNotification(title: "საღამო მშვიდობისა", body: "მოამზადე და მოიმარაგე სნექები 🍟 და ჩაუჯექი ფილმებს", hour: 18, minute: 50)
    }
    
    private func scheduleNotification(title: String, body: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
}
