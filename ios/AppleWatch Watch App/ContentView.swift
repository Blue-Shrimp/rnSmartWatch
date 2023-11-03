//
//  ContentView.swift
//  AppleWatch Watch App
//
//  Created by logsynk on 2023/10/10.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var phoneConnector = PhoneConnector()

    struct Item {
        let title: String
        let keyPath: ReferenceWritableKeyPath<PhoneConnector, Int>
    }

    let items: [Item] = [
        Item(title: "수분", keyPath: \.waterNumber),
        Item(title: "배변", keyPath: \.bowelNumber),
        Item(title: "수면", keyPath: \.sleepNumber),
        Item(title: "혈압", keyPath: \.bpNumber),
        Item(title: "혈당", keyPath: \.bsNumber)
    ]

    var body: some View {
        List {
            ForEach(items, id: \.title) { item in
                createHStack(title: item.title, keyPath: item.keyPath)
            }
        }
    }

    @ViewBuilder
    private func createHStack(title: String, keyPath: ReferenceWritableKeyPath<PhoneConnector, Int>) -> some View {
        HStack(spacing: 10) {
            Text(title)
            Text("\(phoneConnector[keyPath: keyPath])")

            Spacer()

            Button(action: {
                if phoneConnector[keyPath: keyPath] > 0 {
                    phoneConnector[keyPath: keyPath] -= 1
                    self.sendMessage()
                }
            }) {
                Text("-")
            }.buttonStyle(PlainButtonStyle())

            Button(action: {
                phoneConnector[keyPath: keyPath] += 1
                self.sendMessage()
            }) {
                Text("+")
            }.buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(getBackgroundColor(for: title))
        .cornerRadius(10)
    }

    private func getBackgroundColor(for title: String) -> Color {
        switch title {
        case "수분":
            return .blue
        case "배변":
            return .green
        case "수면":
            return .gray
        case "혈압":
            return .purple
        case "혈당":
            return .red
        default:
            return .primary
        }
    }

    private func sendMessage() {
        var message: [String: Any] = [:]
        
        for item in items {
            message[item.title] = phoneConnector[keyPath: item.keyPath]
        }

        phoneConnector.session.sendMessage(message, replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

