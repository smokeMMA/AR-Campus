//
//  ViewController.swift
//  AR Campus
//
//  Created by Михаил Медведев on 20/05/2019.
//  Copyright © 2019 Михаил Медведев. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Enable default lighting
        sceneView.autoenablesDefaultLighting = true
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //Show feature points
        sceneView.debugOptions = [.showFeaturePoints]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //placeCampus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //Detect planes
        configuration.planeDetection = [.horizontal]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
}

extension ViewController {
    
    func placeCampus() {

        let scene = SCNScene(named:"art.scnassets/campus.scn")!
        let node = scene.rootNode.clone()

        //adding tree in code
        let tree = getTreeNode()
        node.addChildNode(tree)


        //set position
        tree.position.x -= 0.3
        tree.position.y -= 0.3
        tree.scale = SCNVector3(0.2, 0.2, 0.2)

        node.position.z -= 0.8
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func getTreeNode() -> SCNNode {
        
        //parent node
        let tree = SCNNode()
        
        //materials
        let croneMaterial = SCNMaterial()
        croneMaterial.diffuse.contents = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        let stallMaterial = SCNMaterial()
        stallMaterial.diffuse.contents = UIColor.brown
        
        //stall node
        let stallGeometry = SCNCylinder(radius: 0.05, height: 0.5)
        stallGeometry.materials = [stallMaterial]
        let stall = SCNNode(geometry: stallGeometry)
        stall.position.y -= 0.4
        
        tree.addChildNode(stall)
        
        //crone node
        let croneGeometry = SCNSphere(radius: 0.3)
        croneGeometry.materials = [croneMaterial]
        let crone = SCNNode(geometry: croneGeometry)
        
        tree.addChildNode(crone)
        
        
        return tree
    }
    
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        print(Date(), #line, #function, "Founded plane")
        
        //avoid crash
        DispatchQueue.global().async {
            let campus = self.createCampus(with: planeAnchor)
            campus.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            node.addChildNode(campus)
        }
       
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        guard let campusNode = node.childNodes.first else { return }
        
        campusNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
    }
    
    func createCampus(with planeAnchor: ARPlaneAnchor) -> SCNNode {

        let scene = SCNScene(named:"art.scnassets/campus.scn")!
        let node = scene.rootNode.clone()
        
        //adding tree in code
        let tree = getTreeNode()
        
        //set position
        tree.position.x -= 0.1
        tree.position.y += 0.05
        tree.scale = SCNVector3(0.1, 0.1, 0.1)
        
        node.addChildNode(tree)
        return node
    }
    
}
