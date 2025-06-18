//
//  MyFishView.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/18/25.
//

struct MyFishView: View {
    @EnvironmentObject var fishingData: FishingDataManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fishingData.catches.sorted(by: { $0.timestamp > $1.timestamp })) { fish in
                    FishRowView(fish: fish)
                }
                .onDelete(perform: deleteFish)
            }
            .navigationTitle("My Catches")
        }
    }
    
    private func deleteFish(offsets: IndexSet) {
        for index in offsets {
            let fish = fishingData.catches[index]
            fishingData.deleteCatch(fish)
        }
    }
}
