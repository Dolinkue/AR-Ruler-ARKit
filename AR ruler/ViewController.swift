//
//  ViewController.swift
//  AR ruler
//
//  Created by Nicolas Dolinkue on 17/04/2022.
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
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let query: ARRaycastQuery? = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneGeometry, alignment: .horizontal)
                    guard let nonOptQuery = query else {
                        print("query is nil")
                        return
                    }
                    let results: [ARRaycastResult] = sceneView.session.raycast(nonOptQuery)
            if let hitResult = results.first {
                addDot(at: hitResult)
        
            }
        
        }

    
    }
    
    func addDot(at hitresult: ARRaycastResult) {
        
         //creamos el cubo desde xcode
            let sphere = SCNSphere(radius: 0.005)
        
                let material = SCNMaterial()
        
                // para entrar dentro de las propiedades del cubo, el material, son propiedades dentro de ARkit
                material.diffuse.contents = UIColor.red
        
                // creamos un array por si le damos mas materiales al objeto, en este caso uno solo que es el color
                sphere.materials = [material]
        
                // posicion del objeto
                let node = SCNNode(geometry: sphere)
        
         
                node.position = SCNVector3(hitresult.worldTransform.columns.3.x, hitresult.worldTransform.columns.3.y, hitresult.worldTransform.columns.3.z)
        
        
                //el rootnode en la base y se le pueden ir agrendo hijos por si queres poner mas de  uno
                sceneView.scene.rootNode.addChildNode(node)
        
                
    }
    
}
