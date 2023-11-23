//
//  Item.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
