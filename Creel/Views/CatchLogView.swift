//
//  CatchLogView.swift
//  Creel
//
//  Created by Aareb Chowdhury on 6/18/25.
//

struct CatchLogView: View {
    @EnvironmentObject var fishingData: FishingDataManager
    @EnvironmentObject var locationManager: LocationManager
    @StateObject private var fishClassifier = FishClassificationService()
    
    @State private var showingCamera = false
    @State private var capturedImage: UIImage?
    @State private var species = ""
    @State private var weight = ""
    @State private var length = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button("Take Photo") {
                    showingCamera = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Species:")
                        TextField("Auto-detected", text: $species)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text("Weight (lbs):")
                        TextField("0.0", text: $weight)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Length (inches):")
                        TextField("0.0", text: $length)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                    }
                }
                .padding(.horizontal)
                
                Button("Log Catch") {
                    logCatch()
                }
                .buttonStyle(.borderedProminent)
                .disabled(capturedImage == nil || weight.isEmpty || length.isEmpty)
                
                Spacer()
            }
            .navigationTitle("Log New Catch")
            .sheet(isPresented: $showingCamera) {
                CameraView { image in
                    capturedImage = image
                    classifyFish(image)
                }
            }
        }
    }
    
    private func classifyFish(_ image: UIImage) {
        fishClassifier.classifyFish(image: image) { detectedSpecies, confidence in
            if confidence > 0.5 {
                species = detectedSpecies
            }
        }
    }
    
    private func logCatch() {
        guard let image = capturedImage,
              let weightValue = Double(weight),
              let lengthValue = Double(length),
              let currentLocation = locationManager.location else { return }
        
        let fishingLocation = FishingLocation(
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude,
            name: nil
        )
        
        let imageData = image.jpegData(compressionQuality: 0.8)
        
        let newFish = Fish(
            species: species.isEmpty ? "Unknown" : species,
            weight: weightValue,
            length: lengthValue,
            imageData: imageData,
            location: fishingLocation,
            timestamp: Date(),
            confidence: 1.0
        )
        
        fishingData.addCatch(newFish)
        
        // Reset form
        capturedImage = nil
        species = ""
        weight = ""
        length = ""
    }
}
