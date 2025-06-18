//
//  ContentView.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/17/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var fishingData = FishingDataManager()
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            
            CatchLogView()
                .tabItem {
                    Image(systemName: "camera")
                    Text("Log Catch")
                }
            
            MyFishView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("My Fish")
                }
            
            LeaderboardView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Leaderboard")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .environmentObject(fishingData)
        .environmentObject(locationManager)
    }
}

#Preview {
    ContentView()
}
