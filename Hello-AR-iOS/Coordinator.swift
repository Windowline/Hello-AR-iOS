import Foundation
import ARKit
import RealityKit
import Combine

class Coordinator : NSObject {
        
    weak var view: ARView?
    var cancellable: AnyCancellable?
    
    @objc func handleTap(_ recognizer: UIGestureRecognizer) {
        guard let view = self.view else { return }
        
        let tapLoc = recognizer.location(in: view)
        let results = view.raycast(from: tapLoc, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            let anchor = AnchorEntity(raycastResult: result)
            
            cancellable = ModelEntity.loadAsync(named: "LunarRover")
                .sink { loadCompletion in
                    if case let .failure(error) = loadCompletion {
                        print("Unable to model \(error)")
                    }
                    self.cancellable?.cancel()
                } receiveValue: { entity in
                    anchor.addChild(entity)
                }
            
            
            view.scene.addAnchor(anchor)
        }
        
        if let entity = view.entity(at: tapLoc) as? ModelEntity {
            let mat = SimpleMaterial(color: .red, isMetallic: true)
            entity.model?.materials = [mat] 
        }
        
    }
    
}
