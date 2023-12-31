//
//  PhoneConnector.swift
//  AppleWatch Watch App
//
//  Created by logsynk on 2023/10/10.
//

import SwiftUI
import WatchKit
import WatchConnectivity
import UserNotifications


final class PhoneConnector: NSObject ,ObservableObject{
  @Published var receivedMessage = "Waiting..."
  @Published var waterNumber:Int = 0
  @Published var bowelNumber:Int = 0
  @Published var sleepNumber:Int = 0
  @Published var bpNumber:Int = 0
  @Published var bsNumber:Int = 0
  
  var session: WCSession
  init(session: WCSession  = .default) {
    self.session = session
    super.init()
    if WCSession.isSupported() {
      session.delegate = self
      session.activate()
    }
  }
}

extension PhoneConnector: WCSessionDelegate {
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
    
    guard let waterCnt = message["waterCnt"] as? Int else { return }
    guard let bowelCnt = message["bowelCnt"] as? Int else { return }
    guard let sleepCnt = message["sleepCnt"] as? Int else { return }
    guard let bpCnt = message["bpCnt"] as? Int else { return }
    guard let bsCnt = message["bsCnt"] as? Int else { return }
//    guard let objectFromApp = message["objectFromApp"] as? [ListData] else { return }
    
//    let notification = UNMutableNotificationContent()
//                notification.title = "애플워치 알림 테스트입니다."
//                notification.body = messageFromApp
//
//    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
//                
//    let request = UNNotificationRequest(identifier: "customNotification", content: notification, trigger: trigger)
//    UNUserNotificationCenter.current().add(request) { error in
//        if let error = error {
//            print("알림 표시 오류: \(error.localizedDescription)")
//        }
//    }
    
    DispatchQueue.main.async {
      self.waterNumber = waterCnt
      self.bowelNumber = bowelCnt
      self.sleepNumber = sleepCnt
      self.bpNumber = bpCnt
      self.bsNumber = bsCnt
    }
  }
}
