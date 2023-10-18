//
//  AppleWatchApp.swift
//  AppleWatch Watch App
//
//  Created by logsynk on 2023/10/10.
//

import SwiftUI
import UserNotifications

@main
struct AppleWatch_Watch_AppApp: App {
    let center = UNUserNotificationCenter.current()
    
    init() {
        center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
            if let error: Error {
                print(error)
            }
        })
    }
  
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    #if os(watchOS)
        WKNotificationScene(controller: NotificationController.self, category: "LandmarkNear")
    #endif
    }
}
