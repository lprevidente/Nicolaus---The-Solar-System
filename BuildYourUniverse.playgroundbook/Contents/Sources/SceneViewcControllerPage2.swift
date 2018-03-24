import UIKit
import ARKit
import PlaygroundSupport

@available(iOS 11.0, *)
extension SceneViewController {
    
    // MARK: - Functions For the Sun
    func createSun(radius: CGFloat, position: SCNVector3) {
        // TODO: Check on value
        // TODO: Add only after that the scanning is completed
        let sun = SCNNode(geometry: SCNSphere(radius: radius))
        sun.name = "Sun"
        sun.position = position
        // Check if there is another sun, and replace it with the new one
        if let sunEx = self.sceneView.scene.rootNode.childNode(withName: "Sun", recursively: false) {
            self.sceneView.scene.rootNode.replaceChildNode(sunEx, with: sun)
        } else {
            self.sceneView.scene.rootNode.addChildNode(sun)
        }
    }
    
    func setTextureToSun() {
        guard let sun = self.sceneView.scene.rootNode.childNode(withName: "Sun", recursively: false) else {
            statusViewController.show(message: whereIsTheSun)
            return
        }
        sun.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "SunTexture.jpg")
        
        if sun.hasActions {
            self.send(MessageFromLiveViewToContents.succeeded.playgroundValue)
        }
    }
    
    // Give rotation to Sun
    func setSpeedRotationToSun(speedRotation: Int){
        guard let sun = self.sceneView.scene.rootNode.childNode(withName: "Sun", recursively: false) else {
            statusViewController.show(message: whereIsTheSun)
            return
        }
        // Do a check on values
        if speedRotation < 1 {
            statusViewController.show(message: tooSpeed)
            return
        } else if  speedRotation > 15 {
            statusViewController.show(message: tooSlow)
            return
        }
        
        self.speedRotation = speedRotation
        let sunAction = Rotation(time: TimeInterval(self.speedRotation))
        // If there is a previous action I'll remove it
        if sun.hasActions {
            sun.removeAction(forKey: "sunRotation")
        }
        sun.runAction(sunAction, forKey: "sunRotation")
        if (sun.geometry?.firstMaterial?.diffuse.contents) != nil {
            self.send(MessageFromLiveViewToContents.succeeded.playgroundValue)
        }
    }
    
    func Rotation(time: TimeInterval) -> SCNAction {
        let Rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
        let foreverRotation = SCNAction.repeatForever(Rotation)
        return foreverRotation
    }
    
    // MARK: - Handle Gesture Recognizer
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if !hitTest.isEmpty {
            let resultName = hitTest.first!.node.name
            switch resultName {
            case "Sun"?:
                statusViewController.show(message: touchOnSun);
            default:
                break;
            }
        }
    }
    
    // Increase the speed of The sun
    @objc func handleSwipeRight(sender: UISwipeGestureRecognizer) {
        guard let sun = self.sceneView.scene.rootNode.childNode(withName: "Sun", recursively: false) else {
            return
        }
        if sun.hasActions {
            self.speedRotation += 1
            setSpeedRotationToSun(speedRotation: self.speedRotation)
        }
    }
    
    // Decrease the speed of the sun
    @objc func handleSwipeLeft(sender: UISwipeGestureRecognizer) {
        guard let sun = self.sceneView.scene.rootNode.childNode(withName: "Sun", recursively: false) else {
            return
        }
        if !sun.hasActions {
            setSpeedRotationToSun(speedRotation: 10)
        } else {
            self.speedRotation += -1
            setSpeedRotationToSun(speedRotation: self.speedRotation)
        }
    }
}