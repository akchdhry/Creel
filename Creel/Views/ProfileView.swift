//
//  ProfileView.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/18/25.
//

struct ProfileView: View {
    @EnvironmentObject var fishingData: FishingDataManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("Angler")
                    .font(.title)
                
                VStack(spacing: 10) {
                    StatRowView(title: "Total Catches", value: "\(fishingData.totalCatches)")
                    StatRowView(title: "Biggest Fish", value: fishingData.biggestFish?.displayWeight ?? "None")
                    StatRowView(title: "Species Caught", value: "\(fishingData.uniqueSpecies)")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}
