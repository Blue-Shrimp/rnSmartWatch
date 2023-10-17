//
//  PhoneConnector.swift
//  AppleWatch Watch App
//
//  Created by logsynk on 2023/10/10.
//

import SwiftUI
import WatchKit
import WatchConnectivity


final class PhoneConnector: NSObject ,ObservableObject{
  @Published var receivedMessage = "Waiting..."
  
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
    
    guard let messageFromApp = message["messageFromApp"] as? String else { return }
    
    
    DispatchQueue.main.async {
      self.receivedMessage = messageFromApp
    }
  }
}
