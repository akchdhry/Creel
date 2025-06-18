//
//  MapView.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/18/25.
//

struct MapView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var fishingData: FishingDataManager
    
    var body: some View {
        NavigationView {
            VStack {
                // TODO: Implement MapKit view showing fishing locations
                Text("Map View - Coming Soon")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Fishing Map")
        }
    }
}
