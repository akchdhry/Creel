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
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            CatchLogView()
                .tabItem {
                    Image(systemName: "fish.fill")
                    Text("Log Catch")
                }
            
            MyFishView()
                .tabItem {
                    Image(systemName: "shippingbox.fill")
                    Text("Creelket")
                }
        }
        .environmentObject(fishingData)
        .environmentObject(locationManager)
    }
}

#Preview {
    ContentView()
}
