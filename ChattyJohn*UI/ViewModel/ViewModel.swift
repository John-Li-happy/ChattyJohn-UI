//
//  ViewModel.swift
//  ChattyJohn*UI
//
//  Created by Zhaoyang Li on 11/27/20.
//

import Foundation

class ViewModel {
    let filePath = "/Users/johnli/Library/Developer/CoreSimulator/Devices/8A1399B4-E898-4F36-88E5-25429B539132/data/Containers/Shared/AppGroup/B9003177-F6BB-44EA-9A30-A598EAC4540D/helloWorld.txt"
    
    var conversation = [(0, "hello")] // 0 for me, 1 for bot
    var currentMessage = String()
    
    func sendHandler(message: String) {
        if !message.isEmpty {
            conversation.append((0, message))
            currentMessage = message
            do {
                try message.write(toFile: filePath, atomically: true, encoding: .utf8)
            } catch { print("error in writing", error.localizedDescription) }
        }
    }
    
    @objc func waitingForResponse() {
        guard let fileData = FileManager.default.contents(atPath: self.filePath) else { return }
        let contentStringOptional = String(data: fileData, encoding: .utf8)
        if let contentString = contentStringOptional {
            if contentString != currentMessage {
                conversation.append((1, contentString))
                currentMessage = contentString
            }
        }
    }
    
    func startReceivingResponser() {
        do {
            try conversation[0].1.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch { print("error in writing", error.localizedDescription) }
        currentMessage = conversation[0].1
        let _ = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(waitingForResponse), userInfo: nil, repeats: true)
    }
}
