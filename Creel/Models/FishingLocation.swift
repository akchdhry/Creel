//
//  FishingLocation.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/18/25.
//

import Foundation
import CoreLocation

struct FishingLocation: Codable {
    let latitude: Double
    let longitude: Double
    let name: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
