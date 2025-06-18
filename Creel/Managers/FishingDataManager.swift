//
//  FishingDataManager.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/18/25.
//

import Foundation
import Combine

class FishingDataManager: ObservableObject {
    @Published var catches: [Fish] = []
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadLocalData()
    }
    
    func addCatch(_ fish: Fish) {
        catches.append(fish)
        saveLocalData()
        // TODO: Sync to cloud/backend
    }
    
    func deleteCatch(_ fish: Fish) {
        catches.removeAll { $0.id == fish.id }
        saveLocalData()
    }
    
    private func loadLocalData() {
        // Load from UserDefaults or Core Data
        if let data = UserDefaults.standard.data(forKey: "catches"),
           let decodedCatches = try? JSONDecoder().decode([Fish].self, from: data) {
            catches = decodedCatches
        }
    }
    
    private func saveLocalData() {
        if let encoded = try? JSONEncoder().encode(catches) {
            UserDefaults.standard.set(encoded, forKey: "catches")
        }
    }
    
    // Analytics helpers
    var totalCatches: Int { catches.count }
    var biggestFish: Fish? { catches.max(by: { $0.weight < $1.weight }) }
    var uniqueSpecies: Int { Set(catches.map { $0.species }).count }
}
