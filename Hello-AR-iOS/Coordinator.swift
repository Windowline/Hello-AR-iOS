import Foundation
import ARKit
import RealityKit

class Coordinator : NSObject {
        
    weak var view: ARView?
    
    
    @objc func handleTap(_ recognizer: UIGestureRecognizer) {
        guard let view = self.view else { return }
        
        let tapLoc = recognizer.location(in: view)
        let results = view.raycast(from: tapLoc, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            let anchorEntity = AnchorEntity(raycastResult: result)
            let boxEntity = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
            anchorEntity.addChild(boxEntity)
            view.scene.addAnchor(anchorEntity)
            
            view.installGestures(.all, for: boxEntity)
        }
        
        if let entity = view.entity(at: tapLoc) as? ModelEntity {
            let mat = SimpleMaterial(color: .red, isMetallic: true)
            entity.model?.materials = [mat] 
        }
        
    }
    
}
