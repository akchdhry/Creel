//
//  HomeView.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/20/25.
//
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var fishingData: FishingDataManager
    @State private var selectedLeaderboardTab = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Header
                    welcomeHeader
                    
                    // Quick Stats Cards
                    quickStatsSection
                    
                    // Recent Activity
                    recentActivitySection
                    
                    // Leaderboard Section
                    leaderboardSection
                    
                    // Quick Actions
                    quickActionsSection
                }
                .padding()
            }
            .navigationTitle("Home")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    // MARK: - Welcome Header
    private var welcomeHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome back, Angler!")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Ready for your next catch?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Profile Picture Placeholder
                Circle()
                    .fill(Color.blue)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                    )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Quick Stats Section
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Stats")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(
                    title: "Total Catches",
                    value: "\(fishingData.totalCatches)",
                    icon: "fish.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "Species",
                    value: "\(fishingData.uniqueSpecies)",
                    icon: "list.bullet.circle.fill",
                    color: .green
                )
                
                StatCard(
                    title: "Biggest Fish",
                    value: fishingData.biggestFish?.displayWeight ?? "None",
                    icon: "trophy.fill",
                    color: .orange
                )
            }
        }
    }
    
    // MARK: - Recent Activity Section
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Catches")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                NavigationLink(destination: MyFishView()) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            if fishingData.catches.isEmpty {
                EmptyStateView()
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(fishingData.catches.sorted(by: { $0.timestamp > $1.timestamp }).prefix(3)) { fish in
                        CompactFishRowView(fish: fish)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Leaderboard Section
    private var leaderboardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Friends")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "plus")
                }
            }
            
            // Leaderboard Tab Picker
            Picker("Leaderboard Type", selection: $selectedLeaderboardTab) {
                Text("Total Catches").tag(0)
                Text("Biggest Fish").tag(1)
                Text("Most Species").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Leaderboard Content
            VStack(spacing: 8) {
                // Mock leaderboard data for now
                ForEach(mockLeaderboardData(for: selectedLeaderboardTab), id: \.id) { entry in
                    LeaderboardRowView(entry: entry)
                }
            }
            
            NavigationLink(destination: LeaderboardView()) {
                HStack {
                    Text("View Full Leaderboard")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 12) {
                NavigationLink(destination: CatchLogView()) {
                    QuickActionButton(
                        title: "Log Catch",
                        icon: "camera.fill",
                        color: .blue
                    )
                }
                
                NavigationLink(destination: MapView()) {
                    QuickActionButton(
                        title: "Fishing Map",
                        icon: "map.fill",
                        color: .green
                    )
                }
            }
        }
    }
    
    // MARK: - Mock Data Helper
    private func mockLeaderboardData(for tab: Int) -> [LeaderboardEntry] {
        switch tab {
        case 0: // Total Catches
            return [
                LeaderboardEntry(id: "1", username: "You", value: "\(fishingData.totalCatches)", rank: 1, isCurrentUser: true),
                LeaderboardEntry(id: "2", username: "FishMaster99", value: "47", rank: 2),
                LeaderboardEntry(id: "3", username: "AngelAnnie", value: "42", rank: 3),
                LeaderboardEntry(id: "4", username: "BassBoss", value: "38", rank: 4),
                LeaderboardEntry(id: "5", username: "TroutTracker", value: "35", rank: 5)
            ]
        case 1: // Biggest Fish
            return [
                LeaderboardEntry(id: "1", username: "BigCatchMike", value: "15.2 lbs", rank: 1),
                LeaderboardEntry(id: "2", username: "You", value: fishingData.biggestFish?.displayWeight ?? "0.0 lbs", rank: 2, isCurrentUser: true),
                LeaderboardEntry(id: "3", username: "LunkerLisa", value: "12.8 lbs", rank: 3),
                LeaderboardEntry(id: "4", username: "MonsterMark", value: "11.5 lbs", rank: 4),
                LeaderboardEntry(id: "5", username: "WhopperWill", value: "10.9 lbs", rank: 5)
            ]
        case 2: // Most Species
            return [
                LeaderboardEntry(id: "1", username: "SpeciesSeeker", value: "23", rank: 1),
                LeaderboardEntry(id: "2", username: "DiverseDan", value: "19", rank: 2),
                LeaderboardEntry(id: "3", username: "You", value: "\(fishingData.uniqueSpecies)", rank: 3, isCurrentUser: true),
                LeaderboardEntry(id: "4", username: "VarietyVic", value: "15", rank: 4),
                LeaderboardEntry(id: "5", username: "MultiMary", value: "12", rank: 5)
            ]
        default:
            return []
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct CompactFishRowView: View {
    let fish: Fish
    
    var body: some View {
        HStack(spacing: 12) {
            // Fish Image
            if let imageData = fish.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipped()
                    .cornerRadius(6)
            } else {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "fish.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                    )
            }
            
            // Fish Info
            VStack(alignment: .leading, spacing: 2) {
                Text(fish.species)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack {
                    Text(fish.displayWeight)
                    Text("•")
                    Text(fish.displayLength)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Timestamp
            Text(timeAgo(from: fish.timestamp))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private func timeAgo(from date: Date) -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        if timeInterval < 3600 { // Less than 1 hour
            let minutes = Int(timeInterval / 60)
            return "\(minutes)m ago"
        } else if timeInterval < 86400 { // Less than 1 day
            let hours = Int(timeInterval / 3600)
            return "\(hours)h ago"
        } else {
            let days = Int(timeInterval / 86400)
            return "\(days)d ago"
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "fish.circle")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No catches yet")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Start logging your catches to see them here!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            NavigationLink(destination: CatchLogView()) {
                Text("Log Your First Catch")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(8)
            }.padding(.top, 8)
        }
        .padding(.vertical, 20).frame(maxWidth: .infinity)
    }
}

struct LeaderboardEntry {
    let id: String
    let username: String
    let value: String
    let rank: Int
    let isCurrentUser: Bool
    
    init(id: String, username: String, value: String, rank: Int, isCurrentUser: Bool = false) {
        self.id = id
        self.username = username
        self.value = value
        self.rank = rank
        self.isCurrentUser = isCurrentUser
    }
}

struct LeaderboardRowView: View {
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack(spacing: 12) {
            // Rank
            Text("#\(entry.rank)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(rankColor)
                .frame(width: 30, alignment: .leading)
            
            // Profile Icon
            Circle()
                .fill(entry.isCurrentUser ? Color.blue : Color.gray.opacity(0.3))
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.caption)
                        .foregroundColor(entry.isCurrentUser ? .white : .gray)
                )
            
            // Username
            Text(entry.username)
                .font(.subheadline)
                .fontWeight(entry.isCurrentUser ? .semibold : .regular)
                .foregroundColor(entry.isCurrentUser ? .primary : .secondary)
            
            Spacer()
            
            // Value
            Text(entry.value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(entry.isCurrentUser ? .blue : .primary)
        }
        .padding(.vertical, 6).padding(.horizontal, 15)
        .background(entry.isCurrentUser ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(8)
    }
    
    private var rankColor: Color {
        switch entry.rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .brown
        default: return .secondary
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color)
        .cornerRadius(12)
    }
}
