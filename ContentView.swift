import SwiftUI
import RealityKit
import ARKit
import AVFoundation

struct ContentView: View {
    @State private var distance: Float = 0.0
    private let speechSynthesizer = AVSpeechSynthesizer()

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
            }
        }
        .onAppear {
            startDistanceUpdates()
        }
    }

    private func startDistanceUpdates() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            speakDistance()
        }
    }

    private func speakDistance() {
        let speechUtterance = AVSpeechUtterance(string: "Obstruction in \(String(format: "%.2f", distance)) meters")
        speechSynthesizer.speak(speechUtterance)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var distance: Float

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

    init(distance: Binding<Float>) {
        _distance = distance
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let currentPointCloud = frame.rawFeaturePoints else { return }
        let cameraTransform = frame.camera.transform

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
