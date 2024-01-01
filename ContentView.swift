import SwiftUI
import RealityKit
import ARKit
import AVFoundation

struct ContentView: View {
    @State private var distance: Float = 0.0
    @State private var isTellingDistance = true
    private let speechSynthesizer = AVSpeechSynthesizer()
    // Implementation details for ContentView
    var body: some View {
        ZStack {
            ARViewContainer(distance: $distance)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Text("Distance: \(String(format: "%.2f", distance)) meters")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.bottom, 100)
                // Implementation for the "Update Distance" button
                HStack {
                    Button(action: {
                        updateDistanceManually()
                    }) {
                        Text("Update Distance")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        toggleTellingDistance()
                    }) {
                        // Implementation for the "Start/Stop Telling Distance" button
                        Text(isTellingDistance ? "Stop Telling Distance" : "Start Telling Distance")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        checkForHazard()
                    }) {
                        // Implementation for the "Check for Hazard" button
                        Text("Check for Hazard")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .onAppear {
            startDistanceUpdates()
        }
    }

    private func startDistanceUpdates() {
        Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true) { timer in
            if isTellingDistance {
                speakDistance()
                checkForHazard()
            }
        }
    }

    private func speakDistance() {
        // Check the condition before announcing the distance
        if distance < 30.0 {
            let speechUtterance = AVSpeechUtterance(string: "Obstruction in \(String(format: "%.2f", distance)) meters")
            speechSynthesizer.speak(speechUtterance)
        }
    }

    private func updateDistanceManually() {
        // Simulate a manual distance update,
        // Implementation for speaking distance
        //distance = Float.random(in: 0.1...10.0)
        speakDistance()
        checkForHazard()
    }

    private func toggleTellingDistance() {
        isTellingDistance.toggle()
    }

    private func checkForHazard() {
        if distance < 0.50 {
            let hazardUtterance = AVSpeechUtterance(string: "Hazard ahead!")
            speechSynthesizer.speak(hazardUtterance)
        } else if distance > 30 {
            let straightenPhoneUtterance = AVSpeechUtterance(string: "Straighten your phone.")
            speechSynthesizer.speak(straightenPhoneUtterance)
        } else {
            let noObjectUtterance = AVSpeechUtterance(string: "No object nearby.")
            speechSynthesizer.speak(noObjectUtterance)
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var distance: Float
    // Implementation details for ARViewContainer
    func makeUIView(context: Context) -> some UIView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic

        arView.session.delegate = context.coordinator
        arView.session.run(config)

        return arView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}

    func makeCoordinator() -> ARSessionDelegateCoordinator {
        return ARSessionDelegateCoordinator(distance: $distance)
    }
}

class ARSessionDelegateCoordinator: NSObject, ARSessionDelegate {
    @Binding var distance: Float
    // Implementation details for ARSessionDelegateCoordinator
    init(distance: Binding<Float>) {
        _distance = distance
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let currentPointCloud = frame.rawFeaturePoints else { return }
        let cameraTransform = frame.camera.transform
        // Implementation for updating distance based on feature points
        var closestDistance: Float = Float.greatestFiniteMagnitude

        for point in currentPointCloud.points {
            let pointInCameraSpace = cameraTransform.inverse * simd_float4(point, 1)
            let distanceToCamera = sqrt(pointInCameraSpace.x + pointInCameraSpace.y * pointInCameraSpace.y + pointInCameraSpace.z * pointInCameraSpace.z)
            if distanceToCamera < closestDistance {
                closestDistance = distanceToCamera
            }
        }
        distance = closestDistance
    }
}
