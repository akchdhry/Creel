//
//  ContentView.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/17/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var fishingData = FishingDataManager()
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    
                    CatchLogView()
                        .tabItem {
                            Image(systemName: "figure.fishing")
                            Text("Log Catch")
                        }
                    
                    NativeAquariumView()
                        .tabItem {
                            Image(systemName: "fish.fill")
                            Text("The Aquarium")
                        }
                }
                .environmentObject(fishingData)
                .environmentObject(locationManager)
                .environmentObject(authManager)
            } else {
                AuthenticationView(isAuthenticated: $authManager.isAuthenticated)
            }
        }
    }
}

#Preview {
    ContentView()
}
