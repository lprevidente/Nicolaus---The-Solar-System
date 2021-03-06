/*:
 # **Start from the basis**
 
 Venturing in the `On the Revolutions of the Heavenly Spheres` (1543) we can found out how the solar system referred is `Heliocentric`: the centre of everything is the Sun, it is fixed and it's 'near' the centre of the universe, but *why near?*.
 
 So start to build the solar system:
 
 1. You need to **Create the Sun**. *Remember*: It will be in front of you.
 2. What is a sun without anything? We know is mainly composed of Hydrogen and Helium, so put a **Texture** on it.
 3. It isn't totally fixed, it rotates around its own axis. You have two ways to put it into motion. `Try to discover what are`.
 */
//#-hidden-code
import PlaygroundSupport
import UIKit
import ARKit

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

func createSun(radius: CGFloat, position: SCNVector3) {
    proxy?.send(MessageFromContentsToLiveView.createSun(radius: radius, position: position).playgroundValue)
}

func setTextureToSun() {
    proxy?.send(MessageFromContentsToLiveView.setTextureToSun.playgroundValue)
}

func setSpeedRotationToSun(speedRotation: Int) {
    proxy?.send(MessageFromContentsToLiveView.setSpeedRotationToSun(speedRotation: speedRotation).playgroundValue)
}
let hints : [String] = ["Radius is in meters. I suggest you to don't use a big number. SCNVector3 has 3 parameters: x, y, z.", "The value of speed rotation is time of rotation period, so minor is and faster is the rotation","Have you put the texture on the Sun and the rotation?", "Have you found the second way?"]

// Handle messages from the live view.
class Listener: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy,
                             received message: PlaygroundValue) {
        guard let liveViewMessage = MessageFromLiveViewToContents(playgroundValue: message) else { return }
        switch liveViewMessage {
        case .succeeded:
            page.assessmentStatus = .pass(message: "Now we have a beautiful sun! [Next](@next)")
        case .failed:
            page.assessmentStatus = .fail(hints: hints, solution: "Try to swipe left and right. See what happens")
            break
        }
    }
    func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) { }
}

let listener = Listener()
proxy?.delegate = listener
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, setSpeedRotationToSun(speedRotation:), setTextureToSun())
//#-code-completion(identifier, show)
//#-end-hidden-code
createSun(radius:/*#-editable-code*/0.35/*#-end-editable-code*/, position: SCNVector3(/*#-editable-code 0*/0/*#-end-editable-code*/,/*#-editable-code */0/*#-end-editable-code*/,/*#-editable-code -1*/-2/*#-end-editable-code*/))
//#-editable-code

//#-end-editable-code
