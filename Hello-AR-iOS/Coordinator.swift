import Foundation
import ARKit
import RealityKit
import Combine

class Coordinator: NSObject, ARSessionDelegate, UIGestureRecognizerDelegate {
    
    weak var view: ARView?
    
    var movableEntities = [MovableEntity]()
    
    var planeAnchor: AnchorEntity?
    
    func buildEnvironment() {
        guard let view = view else { return }
        
        let planeAnchor = AnchorEntity(plane: .horizontal)
        
        let floor = ModelEntity(mesh: MeshResource.generatePlane(width: 2.0, depth: 0.9), materials: [SimpleMaterial(color: .darkGray, isMetallic: true)])
        floor.generateCollisionShapes(recursive: true)
        floor.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
        
        let box1 = MovableEntity(size: 0.2, color: .purple, shape: .box, ypos: 0)
        let box2 = MovableEntity(size: 0.2, color: .gray, shape: .box, ypos: 0)
        let sphere1 = MovableEntity(size: 0.2, color: .systemPink, shape: .sphere, ypos: 0)
        let sphere2 = MovableEntity(size: 0.2, color: .brown, shape: .sphere, ypos: 0)
        
        let light = DirectionalLight()
        light.light.color = .red
        light.light.intensity = 1000
        light.light.isRealWorldProxy = true
        light.shadow?.maximumDistance = 2
        light.shadow?.depthBias = 5
        light.position.y += 0.4
        
        planeAnchor.addChild(floor)
        planeAnchor.addChild(box1)
        planeAnchor.addChild(box2)
        planeAnchor.addChild(sphere1)
        planeAnchor.addChild(sphere2)
        planeAnchor.addChild(light)

        movableEntities.append(box1)
        movableEntities.append(box2)
        movableEntities.append(sphere1)
        movableEntities.append(sphere2)
        
        view.scene.addAnchor(planeAnchor)
        
        movableEntities.forEach {
            view.installGestures(.all, for: $0).forEach {
                $0.delegate = self
            }
        }
        
        setupGestures()
    }
    
    fileprivate func setupGestures() {
        guard let view = view else { return }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let translationGesture = gestureRecognizer as? EntityTranslationGestureRecognizer,
              let entity = translationGesture.entity as? MovableEntity else {
            return true
        }
        
        entity.physicsBody?.mode = .kinematic
        return true
    }
    
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer) {
        guard let view = view else { return }

        let loc = recognizer.location(in: view)
        let raycastResults = view.raycast(from: loc, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let raycastResult = raycastResults.first {
            let raycastAnchor = AnchorEntity(raycastResult: raycastResult)
            let input = MovableEntity(size: 0.05, color: .systemMint, shape: .sphere, ypos: 0.7)
            movableEntities.append(input)
            raycastAnchor.addChild(input)
            view.scene.addAnchor(raycastAnchor)
        }
    }
    
    @objc func panned(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .ended, .cancelled, .failed:
                movableEntities.compactMap { $0 }.forEach {
                    $0.physicsBody?.mode = .dynamic
                }
            default:
                return
        }
    }
}
