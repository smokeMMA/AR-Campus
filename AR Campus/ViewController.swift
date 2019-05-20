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

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        placeCampus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

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
        let tree = getTreeNode()
        node.addChildNode(tree)
        node.position.z -= 0.8
        sceneView.scene.rootNode.addChildNode(node)
    }
    
//    func placeTree() {
//        let tree = getTreeNode()
//        sceneView.scene.rootNode.addChildNode(tree)
//    }
    
    
    func getTreeNode() -> SCNNode {
        //parent node
        let tree = SCNNode()
        //materials
        let croneMaterial = SCNMaterial()
        croneMaterial.diffuse.contents = UIColor.green
        
        let stallMaterial = SCNMaterial()
        stallMaterial.diffuse.contents = UIColor.brown
        
        //stall node
        let stallGeometry = SCNCylinder(radius: 0.05, height: 0.5)
        stallGeometry.materials = [stallMaterial]
        let stall = SCNNode(geometry: stallGeometry)
        stall.position.y -= 0.4
        
        
        //crone node
        let croneGeometry = SCNSphere(radius: 0.3)
        croneGeometry.materials = [croneMaterial]
        let crone = SCNNode(geometry: croneGeometry)
        
        
        tree.addChildNode(crone)
        tree.addChildNode(stall)
        
        tree.position.x -= 0.3
        tree.position.y -= 0.13
        tree.scale = SCNVector3(0.2, 0.2, 0.2)
        
        return tree
    }
}
