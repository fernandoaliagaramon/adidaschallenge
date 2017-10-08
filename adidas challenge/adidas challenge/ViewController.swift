//
//  ViewController.swift
//  ARKit2d
//
//  Created by Andrew Seeley on 5/7/17.
//  Copyright © 2017 Seemu. All rights reserved.
//
import UIKit
import ARKit
import SceneKit
import AVFoundation


class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    // Position and orientation of text 2D images
    var anchors: [ARAnchor] = []
    // Iterador balones
    var i_ball = 0
    // Clock (Conection animation)
    var spawnTime:TimeInterval = 0
    // Number of conection points (Conection animation)
    var num_conection = 20
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        sceneView.delegate = self
    }
    
    // Creates a ball with an image texture (radius: 0.1)
    func createBall(file_name: String) -> SCNNode {
        let newBall = SCNSphere(radius: 0.1)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: file_name)
        newBall.firstMaterial = material
        let newBallNode = SCNNode(geometry: newBall)
        newBallNode.eulerAngles = SCNVector3Make(Float(M_PI/2), 0, Float(M_PI/2));
        return newBallNode
    }
    
    // Response to touch event.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Check if we have printed all the balls
        if(i_ball>7){
            return
        }
        // Create the anchor of a new label image in real world coordinates
        if let currentFrame = sceneView.session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.5
            let transform = simd_mul(currentFrame.camera.transform, translation)
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
            anchors.append(anchor)
        }
    }
    
    // Make a SCNNode object with a 2D image
    func make2dNode(image: UIImage, width: CGFloat = 0.1, height: CGFloat = 0.1, z: Float = 0) -> SCNNode {
        let plane = SCNPlane(width: width, height: height)
        plane.firstMaterial!.diffuse.contents = image
        let node = SCNNode(geometry: plane)
        node.constraints = [SCNBillboardConstraint()]
        node.position = SCNVector3(node.position.x, node.position.y, node.position.z + z)
        return node
    }
    
    // Before ading the nodes, we create the ball and label as child nodes
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //  get back to
        i_ball+=1
        num_conection = 20
        let text_layer = make2dNode(image: UIImage(named: "art.scnassets/text_"+String(i_ball)+".png")!, width: 0.64, height: 0.5)
        let ballon = createBall(file_name: "art.scnassets/"+String(i_ball)+".png")
        node.addChildNode(text_layer)
        node.addChildNode(ballon)
    }
    
    // After rendering the scene, check if there is a new conection animation (new ball)
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if time > spawnTime {
            spawnTime = time + 0.4
            if(i_ball>1 && num_conection>0){
                startBouncing(from: i_ball-2, to: i_ball-1)
                num_conection -= 1
            }
        }
    }
    
    // Conection animation
    func startBouncing(from: Int, to: Int) {
        var ballNode = SCNNode()
        ballNode = make2dNode(image: #imageLiteral(resourceName: "ball"), width: 0.02, height: 0.02)
        
        let first = anchors[from]
        let last = anchors[to]
        guard let start = sceneView.node(for: first),
            let end = sceneView.node(for: last)
            else { return }
        
        if ballNode.parent == nil {
            sceneView.scene.rootNode.addChildNode(ballNode)
        }
        
        let animation = CABasicAnimation(keyPath: #keyPath(SCNNode.transform))
        animation.fromValue = start.transform
        animation.toValue = end.transform
        animation.duration = 3
        animation.repeatCount = .infinity
        ballNode.removeAllAnimations()
        ballNode.addAnimation(animation, forKey: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
