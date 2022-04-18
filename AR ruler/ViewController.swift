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
    
    // var para rastrar todos los puntos
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        

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
        
        if dotNodes.count >= 2 {
            
            for dot in dotNodes {
                dot.removeFromParentNode()
                
            }
            
            textNode.removeFromParentNode()
            dotNodes = [SCNNode]()
            
        }
        
        
        if let touchLocation = touches.first?.location(in: sceneView) {
         
            if let query = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .any) {
         
                let hitTestResults = sceneView.session.raycast(query)
         
                if let hitResult = hitTestResults.first {
                    addDot(at: hitResult)
                }
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
        
        
        dotNodes.append(node)
        
        if dotNodes.count >= 2 {
            calculate()
        }
                
    }
    
    //func para calcular la distancia
    func calculate () {
        
        let start = dotNodes[0]
        let end = dotNodes[1]
    
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        //formula para calcular la distancia en 3d
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        updateText(text: "\(abs(distance) * 100)cm", atPosition: end.position)
    }
    
    // text geometry
    func updateText(text: String, atPosition: SCNVector3) {
        
        
        
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(atPosition.x, atPosition.y + 0.01, atPosition.z)
        
        textNode.scale = SCNVector3(0.005, 0.005, 0.005)
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
}
