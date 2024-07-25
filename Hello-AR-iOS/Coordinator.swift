import Foundation
import ARKit
import RealityKit

class Coordinator : NSObject, ARSessionDelegate {
        
    weak var view: ARView?
    
    
    @objc func handleTap(_ recognizer: UIGestureRecognizer) {
        guard let view = self.view else { return }
        
        let tapLoc = recognizer.location(in: view)
        let results = view.raycast(from: tapLoc, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            let anchor = ARAnchor(name: "Plane", transform: result.worldTransform)
            view.session.add(anchor: anchor)
            
            let mat = SimpleMaterial(color: .blue, isMetallic: true)
            let boxEntity = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [mat])
            
            
            let anchorEntity = AnchorEntity(anchor: anchor)
            anchorEntity.addChild(boxEntity)
            
            view.scene.addAnchor(anchorEntity)
        }
        
        if let entity = view.entity(at: tapLoc) as? ModelEntity {
            let mat = SimpleMaterial(color: .red, isMetallic: true)
            entity.model?.materials = [mat] 
        }
        
    }
    
}
