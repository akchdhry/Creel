//
//  User.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/18/25.
//

import Foundation
import CoreLocation

struct User: Codable {
    let id: String
    let username: String
    let email: String
    var totalCatches: Int
    var biggestFish: Fish?
    var friends: [String] // User IDs
}
