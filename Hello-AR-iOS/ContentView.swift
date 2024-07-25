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
        
        let mat = SimpleMaterial(color: .blue, isMetallic: true)
        let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [mat])
        box.generateCollisionShapes(recursive: true)
            
        anchor.addChild(box)
        arView.scene.anchors.append(anchor)
        
        return arView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
