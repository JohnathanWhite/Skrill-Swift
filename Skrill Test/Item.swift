//
//  Item.swift
//  Skrill Test
//
//  Created by Johnathan White on 9/4/24.
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
