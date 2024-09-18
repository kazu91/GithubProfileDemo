//
//  Item.swift
//  GithubProfileDemo
//
//  Created by Kazu on 18/9/24.
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
