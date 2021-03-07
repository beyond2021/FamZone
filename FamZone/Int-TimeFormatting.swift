//
//  Int-TimeFormatting.swift
//  FamZone
//
//  Created by KEEVIN MITCHELL on 3/6/21.
//

import Foundation
extension Int {
    func timeString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        // positioning
        formatter.unitsStyle = .positional // separated by colons
        let formattedString = formatter.string(from: TimeInterval(self)) ?? "0"
        
        if formattedString == "0" {
            return "GMT"
        } else {
            if formattedString.hasPrefix("-") {
                return "GMT\(formattedString)"
            } else {
                return "GMT+\(formattedString)"
            }
        }
        
    }
    
    
}
