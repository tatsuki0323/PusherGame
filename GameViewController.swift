//
//  GameViewController.swift
//  PusherGame
//
//  Created by 川崎　樹 on 2016/03/07.
//  Copyright (c) 2016年 tatsuki kawasaki. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController:UIViewController {
    //押す板
    let pushtable = SCNBox(width: 50.0, height: 4.0, length: 80.0, chamferRadius: 0.0)
    let pushtableNode = SCNNode()
    
    weak var scnView : SCNView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        //重力の設定
        scene.physicsWorld.gravity = SCNVector3(x: 0.0, y: -9.8, z: 0.0)
        
        scnView = self.view as? SCNView
        scnView?.scene = scene
        //背景の色
        scnView?.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        //カメラの移動
        scnView?.allowsCameraControl = false
        //押す板の動き
        let moveA = SCNAction.moveByX(0, y: 0, z: 20, duration: 8)
        let moveB = SCNAction.moveByX(0, y: 0, z: -20, duration: 8)
        let moveSequence = SCNAction.sequence([moveA,moveB])
        let moveRepeatAction =  SCNAction.repeatActionForever(moveSequence)
        pushtableNode.runAction(moveRepeatAction)
        
        setObject()
        setCamera()
        setLight()
    }
    
    func setObject(){
        //タイトルロゴ
        let titleText = SCNText(string: "コイン落とし", extrusionDepth: 1.0)
        titleText.font = UIFont(name: "AvenirNext-Heavy", size: 6)
        titleText.firstMaterial!.diffuse.contents  = UIColor.greenColor()
        let titleNode = SCNNode(geometry: titleText)
        titleNode.position = SCNVector3(x: -18, y: 40, z: -7)
        //titleNode.runAction(SCNAction.rotateByX(0, y: 5, z: 0, duration: 2.5))
        self.scnView?.scene?.rootNode.addChildNode(titleNode)
        //右の壁
        let rightwall = SCNBox(width: 2.0, height: 20.0, length: 50.0, chamferRadius: 0.0)
        rightwall.firstMaterial?.diffuse.contents = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        let rightwallNode = SCNNode()
        rightwallNode.geometry = rightwall
        rightwallNode.position = SCNVector3(x: 26, y: 11, z: 0)
        rightwallNode.name = "rightwall"
        rightwallNode.physicsBody = SCNPhysicsBody.staticBody()
        rightwallNode.physicsBody?.physicsShape = SCNPhysicsShape(node: rightwallNode, options: nil)
        self.scnView?.scene?.rootNode.addChildNode(rightwallNode)
        //左の壁
        let leftwall = SCNBox(width: 2.0, height: 20.0, length: 50.0, chamferRadius: 0.0)
        leftwall.firstMaterial?.diffuse.contents = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        let leftwallNode = SCNNode()
        leftwallNode.geometry = leftwall
        leftwallNode.position = SCNVector3(x: -26, y: 11, z: 0)
        leftwallNode.name = "leftwall"
        leftwallNode.physicsBody = SCNPhysicsBody.staticBody()
        leftwallNode.physicsBody?.physicsShape = SCNPhysicsShape(node: leftwallNode, options: nil)
        self.scnView?.scene?.rootNode.addChildNode(leftwallNode)
        //後ろの壁
        let backwall = SCNBox(width: 50.0, height: 17.0, length: 2.0, chamferRadius: 0.0)
        backwall.firstMaterial?.diffuse.contents = UIColor(red: 0.1, green: 1.0, blue: 0.0, alpha: 1.0)
        let backwallNode = SCNNode()
        backwallNode.geometry = backwall
        backwallNode.position = SCNVector3(x: 0, y: 11, z: -24)
        backwallNode.name = "backwall"
        backwallNode.physicsBody = SCNPhysicsBody.staticBody()
        backwallNode.physicsBody?.physicsShape = SCNPhysicsShape(node: backwallNode, options: nil)
        self.scnView?.scene?.rootNode.addChildNode(backwallNode)
        //押す板
        pushtable.firstMaterial?.diffuse.contents = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        pushtableNode.geometry = pushtable
        pushtableNode.position = SCNVector3(x: 0, y: 2, z: -50)
        pushtableNode.name = "pushtable"
        pushtableNode.physicsBody = SCNPhysicsBody.kinematicBody()
        pushtableNode.physicsBody?.friction = 0.8
        pushtableNode.physicsBody?.restitution = 0.0001
        pushtableNode.physicsBody?.physicsShape = SCNPhysicsShape(node: pushtableNode, options: nil)
        self.scnView?.scene?.rootNode.addChildNode(pushtableNode)
        
        //コイン出るとこ
        let generator = SCNBox(width: 50.0, height: 5.0, length: 10.0, chamferRadius: 0.0)
        //拡散光の色を設定
        generator.firstMaterial?.diffuse.contents = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.7)
        let generatorNode = SCNNode()
        generatorNode.geometry = generator
        generatorNode.position = SCNVector3(x: 0, y: 30, z: -10)
        generatorNode.name = "generator"
        self.scnView?.scene?.rootNode.addChildNode(generatorNode)
        //床
        let ground = SCNBox(width: 50.0, height: 2.0, length: 50.0, chamferRadius: 0.0)
        ground.firstMaterial?.diffuse.contents = UIColor(red: 0.8, green: 0.8, blue: 0.3, alpha: 1.0)
        let groundNode = SCNNode()
        groundNode.geometry = ground
        groundNode.position = SCNVector3(x: 0, y: 0, z: 0)
        groundNode.name = "ground"
        groundNode.physicsBody?.restitution = 0.0001
        groundNode.physicsBody?.friction = 0.8
        groundNode.physicsBody = SCNPhysicsBody.kinematicBody()
        groundNode.physicsBody?.physicsShape = SCNPhysicsShape(node: groundNode, options: nil)
        self.scnView?.scene?.rootNode.addChildNode(groundNode)
    }
    
    func setCamera(){
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        self.scnView?.scene?.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 50, z: 60)
        cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: -0.5)
        /*
        cameraNode.position = SCNVector3(x: 0, y: 50, z: 50)
        cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: -0.5)
        */
    }
    
    func setLight(){
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = SCNLightTypeAmbient
        ambientLightNode.light?.color = UIColor.darkGrayColor()
        self.scnView?.scene?.rootNode.addChildNode(ambientLightNode)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLightTypeSpot
        lightNode.light?.spotOuterAngle = 90
        lightNode.light?.color = UIColor.whiteColor()
        lightNode.light?.castsShadow = true
        lightNode.position = SCNVector3(x: 0, y: 80, z: 10)
        
        if let ground = self.scnView?.scene?.rootNode.childNodeWithName("ground", recursively: false){
            let cons = SCNLookAtConstraint(target: ground)
            cons.influenceFactor = 1.0
            lightNode.constraints = [cons]
        }
        self.scnView?.scene?.rootNode.addChildNode(lightNode)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let p = touch.locationInView(self.scnView)
            
            if let hitResults = self.scnView?.hitTest(p, options: nil) {
                if hitResults.count > 0 {
                    let result = hitResults.first?.node
                    
                    if result?.name == "generator"{
                        let geom = generateRandomGeometry()
                        geom.firstMaterial?.diffuse.contents =
                            UIColor(red: colorValue(), green: colorValue(), blue: colorValue(), alpha: 1.0)
                        let geomNode = SCNNode(geometry: geom)
                        if(geomNode.position.y <= -10){
                            geomNode.removeFromParentNode()
                        }
                        geomNode.position = SCNVector3(x: Float(p.x-100)/20, y:30, z: randValue())
                        geomNode.name = "geometry"
                        /*
                        geomNode.position = SCNVector3(x: 0, y: 30, z: -10)
                        geomNode.name = "geometry"
                        */
                        geomNode.physicsBody = SCNPhysicsBody.dynamicBody()
                        //geomNode.physicsBody?.contactTestBitMask = 0
                        //geomNode.physicsBody?.categoryBitMask = 1
                        //geomNode.physicsBody?.collisionBitMask = 1
                        geomNode.physicsBody?.friction = 0.8
                        geomNode.physicsBody?.velocity = SCNVector3(x:0,y:-50,z:0)
                        geomNode.physicsBody?.restitution = 0.0001
                        geomNode.physicsBody?.physicsShape = SCNPhysicsShape(node: geomNode, options: nil)
                        self.scnView?.scene?.rootNode.addChildNode(geomNode)
                    }
                    /*
                    else if result?.name == "geometry"{
                    result!.runAction(SCNAction.sequence([
                    SCNAction.fadeOutWithDuration(0.5),
                    SCNAction.removeFromParentNode()
                    ]))
                    }
                    */
                }
            }
        }
    }
    
    /*
    func didBeginContact(contact: SCNPhysicsContact ) {
    if (contact.nodeA == "geomNode" ||
    contact.nodeB == "geomNode") &&
    (contact.nodeA == "pushtableNode" ||
    contact.nodeB == "pushtableNode" ){
    pushtableNode.position.y + 20
    }
    }
    */
    
    
    func generateRandomGeometry() -> SCNGeometry{
        let kind = arc4random() % 100
        
        switch kind{
        case 0:
            let cylinder = SCNCylinder(radius: 3.0, height: 4.0)
            return cylinder
        case 1:
            let sphere = SCNSphere(radius: 5.0)
            return sphere
        default:
            let medal = SCNCylinder(radius: 3.0, height: 0.4)
            return medal
        }
    }
    
    func colorValue() -> CGFloat{
        let rand = CGFloat(arc4random() % 100)
        return rand / 100
    }
    
    func randValue() -> Float{
        let rand = -(Float(arc4random() % 150))
        return rand / 10
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    //画面の向きを固定する関数
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
