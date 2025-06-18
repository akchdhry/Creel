//
//  Fish.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/18/25.
//

import Foundation
import CoreLocation

struct Fish: Identifiable, Codable {
    let id = UUID()
    let species: String
    let weight: Double // in pounds
    let length: Double // in inches
    let imageData: Data?
    let location: FishingLocation
    let timestamp: Date
    let confidence: Double // ML model confidence
    
    var displayWeight: String {
        return String(format: "%.1f lbs", weight)
    }
    
    var displayLength: String {
        return String(format: "%.1f\"", length)
    }
}
