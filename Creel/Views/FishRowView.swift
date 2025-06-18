//
//  FishRowView.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/18/25.
//

import SwiftUI

struct FishRowView: View {
    let fish: Fish
    
    var body: some View {
        HStack {
            if let imageData = fish.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(8)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(fish.species)
                    .font(.headline)
                
                HStack {
                    Text(fish.displayWeight)
                    Text("•")
                    Text(fish.displayLength)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Text(fish.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
