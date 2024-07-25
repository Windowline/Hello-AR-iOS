//
//  ContentView.swift
//  Hello-AR-iOS
//
//  Created by 박창선 on 7/25/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        
        let anchor = AnchorEntity(plane: .horizontal)
        
        context.coordinator.view = arView
        arView.session.delegate = context.coordinator
        
        let mat = SimpleMaterial(color: .blue, isMetallic: true)
        let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [mat])
        box.generateCollisionShapes(recursive: true)
            
        anchor.addChild(box)
        arView.scene.anchors.append(anchor)
        
        return arView
        
        // Create a cube model
//        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
//        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
//        let model = ModelEntity(mesh: mesh, materials: [material])
//        model.transform.translation.y = 0.05
//
//        // Create horizontal plane anchor for the content
//        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
//        anchor.children.append(model)
//
//        // Add the horizontal plane anchor to the scene
//        arView.scene.anchors.append(anchor)
//
//        return arView
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
