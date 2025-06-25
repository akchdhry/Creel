//
//  NativeAquariumView.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/25/25.
//

import SwiftUI

struct NativeAquariumView: View {
    @EnvironmentObject var fishingData: FishingDataManager
    @State private var selectedFish: Fish?
    @State private var bubbles: [Bubble] = []
    @State private var fishPositions: [UUID: CGPoint] = [:]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Ocean background
                oceanBackground
                
                // Seaweed and coral
                seaweedAndCoral(in: geometry)
                
                // Bubbles
                bubblesView
                
                // Fish
                fishView(in: geometry)
                
                // Water surface effect
                waterSurface
                
                // Header
                headerView
            }
            .onAppear {
                startBubbleAnimation()
                initializeFishPositions(in: geometry)
            }
            .sheet(item: $selectedFish) { fish in
                FishDetailSheet(fish: fish)
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Background Elements
    
    private var oceanBackground: some View {
        LinearGradient(
            colors: [
                Color(red: 0.12, green: 0.23, blue: 0.37),
                Color(red: 0.18, green: 0.35, blue: 0.63),
                Color(red: 0.29, green: 0.56, blue: 0.89),
                Color(red: 0.53, green: 0.81, blue: 0.92)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .overlay(
            // Water light rays
            RadialGradient(
                colors: [Color.white.opacity(0.1), Color.clear],
                center: UnitPoint(x: 0.3, y: 0.2),
                startRadius: 0,
                endRadius: 300
            )
        )
    }
    
    private var waterSurface: some View {
        VStack {
            LinearGradient(
                colors: [
                    Color.white.opacity(0.3),
                    Color.blue.opacity(0.2),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)
            .scaleEffect(x: 1.1, y: 1)
            .animation(
                Animation.easeInOut(duration: 3)
                    .repeatForever(autoreverses: true),
                value: UUID()
            )
            
            Spacer()
        }
    }
    
    private func seaweedAndCoral(in geometry: GeometryProxy) -> some View {
        ZStack {
            // Seaweed
            ForEach(0..<4, id: \.self) { index in
                SeaweedView()
                    .position(
                        x: geometry.size.width * [0.1, 0.2, 0.8, 0.9][index],
                        y: geometry.size.height - 50
                    )
            }
            
            // Coral
            ForEach(0..<3, id: \.self) { index in
                CoralView()
                    .position(
                        x: geometry.size.width * [0.3, 0.6, 0.75][index],
                        y: geometry.size.height - 20
                    )
            }
        }
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("The Aquarium")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .padding(.top, 25)
                    
                    Text("\(fishingData.catches.count) fish in your collection")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(radius: 1)
                }
                Spacer()
            }
            .padding(.top, 50)
            
            Spacer()
        }
    }
    
    // MARK: - Interactive Elements
    
    private var bubblesView: some View {
        ForEach(bubbles, id: \.id) { bubble in
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.8),
                            Color.white.opacity(0.3)
                        ],
                        center: .topLeading,
                        startRadius: 1,
                        endRadius: bubble.size
                    )
                )
                .frame(width: bubble.size, height: bubble.size)
                .position(bubble.position)
                .opacity(bubble.opacity)
        }
    }
    
    private func fishView(in geometry: GeometryProxy) -> some View {
        ForEach(fishingData.catches, id: \.id) { fish in
            SwiftUIFishView(fish: fish)
                .position(fishPositions[fish.id] ?? CGPoint(x: 100, y: 200))
                .onTapGesture {
                    selectedFish = fish
                }
                .animation(
                    Animation.easeInOut(duration: Double.random(in: 3...8))
                        .repeatForever(autoreverses: false),
                    value: fishPositions[fish.id]
                )
        }
        .onReceive(Timer.publish(every: 5, on: .main, in: .common).autoconnect()) { _ in
            animateFish(in: geometry)
        }
    }
    
    // MARK: - Animation Logic
    
    private func startBubbleAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            addBubble()
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateBubbles()
        }
    }
    
    private func addBubble() {
        guard bubbles.count < 15 else { return }
        
        let bubble = Bubble(
            position: CGPoint(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: UIScreen.main.bounds.height + 10
            ),
            size: CGFloat.random(in: 5...15)
        )
        bubbles.append(bubble)
    }
    
    private func updateBubbles() {
        bubbles = bubbles.compactMap { bubble in
            var updatedBubble = bubble
            updatedBubble.position.y -= 2
            updatedBubble.position.x += sin(updatedBubble.position.y * 0.01) * 0.5
            updatedBubble.opacity = max(0, updatedBubble.opacity - 0.01)
            
            return updatedBubble.position.y > -50 && updatedBubble.opacity > 0 ? updatedBubble : nil
        }
    }
    
    private func initializeFishPositions(in geometry: GeometryProxy) {
        for fish in fishingData.catches {
            fishPositions[fish.id] = CGPoint(
                x: CGFloat.random(in: 50...geometry.size.width - 50),
                y: CGFloat.random(in: 150...geometry.size.height - 150)
            )
        }
    }
    
    private func animateFish(in geometry: GeometryProxy) {
        for fish in fishingData.catches {
            fishPositions[fish.id] = CGPoint(
                x: CGFloat.random(in: 50...geometry.size.width - 50),
                y: CGFloat.random(in: 150...geometry.size.height - 150)
            )
        }
    }
}

// MARK: - Supporting Views

struct SwiftUIFishView: View {
    let fish: Fish
    @State private var isSwimming = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Fish body
            Ellipse()
                .fill(fishColor)
                .frame(width: 60, height: 35)
                .overlay(
                    // Eye
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .fill(Color.black)
                                .frame(width: 4, height: 4)
                        )
                        .offset(x: -10, y: -5)
                )
            
            // Tail
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 20, y: -15))
                path.addLine(to: CGPoint(x: 20, y: 15))
                path.closeSubpath()
            }
            .fill(fishColor.opacity(0.8))
        }
        .scaleEffect(x: isSwimming ? -1 : 1, y: 1)
        .animation(
            Animation.easeInOut(duration: 2)
                .repeatForever(autoreverses: true),
            value: isSwimming
        )
        .onAppear {
            isSwimming.toggle()
        }
        .shadow(radius: 3)
    }
    
    private var fishColor: Color {
        let species = fish.species.lowercased()
        if species.contains("trout") {
            return Color.green
        } else if species.contains("bass") {
            return Color.orange
        } else if species.contains("pike") {
            return Color.purple
        } else {
            return Color.blue
        }
    }
}

struct SeaweedView: View {
    @State private var sway = false
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.green.opacity(0.8),
                        Color.green.opacity(0.6),
                        Color.green.opacity(0.4)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(width: 8, height: CGFloat.random(in: 80...120))
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .rotationEffect(.degrees(sway ? -5 : 5))
            .animation(
                Animation.easeInOut(duration: Double.random(in: 2...4))
                    .repeatForever(autoreverses: true),
                value: sway
            )
            .onAppear {
                sway.toggle()
            }
    }
}

struct CoralView: View {
    var body: some View {
        Ellipse()
            .fill(
                LinearGradient(
                    colors: [Color.pink, Color.orange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 30, height: 20)
            .clipShape(Ellipse())
    }
}

struct FishDetailSheet: View {
    let fish: Fish
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Fish image placeholder
                if let imageData = fish.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(15)
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: "fish.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                        )
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(fish.species)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Weight")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(fish.displayWeight)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Length")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(fish.displayLength)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Caught on \(fish.timestamp.formatted(date: .abbreviated, time: .omitted))")
                            .font(.subheadline)
                        
                        if let locationName = fish.location.name {
                            Text("Location: \(locationName)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Fish Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Data Models

struct Bubble {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    var opacity: Double = 1.0
}
