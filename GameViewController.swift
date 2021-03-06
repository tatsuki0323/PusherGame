//
//  GameViewController.swift
//  PusherGame
//
//  Created by 川崎　樹 on 2016/03/07.
//  Copyright (c) 2016年 tatsuki kawasaki. All rights reserved.
//

import SceneKit

class GameViewController:UIViewController {
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
        let pushtable = SCNBox(width: 50.0, height: 4.0, length: 80.0, chamferRadius: 0.0)
        let pushtableNode = SCNNode()
        pushtable.firstMaterial?.diffuse.contents = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        pushtableNode.geometry = pushtable
        pushtableNode.position = SCNVector3(x: 0, y: 2, z: -50)
        pushtableNode.name = "pushtable"
        pushtableNode.physicsBody = SCNPhysicsBody.kinematicBody()
        pushtableNode.physicsBody?.friction = 1.0
        pushtableNode.physicsBody?.restitution = 0.0
        pushtableNode.physicsBody?.physicsShape = SCNPhysicsShape(node: pushtableNode, options: nil)
        self.scnView?.scene?.rootNode.addChildNode(pushtableNode)
        
        //押す板の動き
        let moveA = SCNAction.moveByX(0, y: 0, z: 18, duration: 8)
        let moveB = SCNAction.moveByX(0, y: 0, z: -18, duration: 8)
        let moveSequence = SCNAction.sequence([moveA,moveB])
        let moveRepeatAction =  SCNAction.repeatActionForever(moveSequence)
        pushtableNode.runAction(moveRepeatAction)

        //コイン出るとこ
        let generator = SCNBox(width: 50.0, height: 5.0, length: 10.0, chamferRadius: 0.0)
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
        groundNode.physicsBody?.restitution = 0.0
        groundNode.physicsBody?.friction =  1.0
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
                        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
                        //print(myBoundSize.width)//414
                        //print(myBoundSize.height)//736
                        //コインの落とされる場所
                        geomNode.position = SCNVector3(x: Float((p.x-myBoundSize.width/2)/((myBoundSize.width/2)/25)), y:30, z: randValue())
                        /*
                        print(p.x)
                        print(p.y)
                        */
                        geomNode.name = "geometry"
                        geomNode.physicsBody = SCNPhysicsBody.dynamicBody()
                        //geomNode.physicsBody?.contactTestBitMask = 0
                        //geomNode.physicsBody?.categoryBitMask = 1
                        //geomNode.physicsBody?.collisionBitMask = 1
                        geomNode.physicsBody?.friction = 1.0
                        geomNode.physicsBody?.velocity = SCNVector3(x:0,y:-50,z:0)
                        geomNode.physicsBody?.restitution = 0.0
                        geomNode.physicsBody?.physicsShape = SCNPhysicsShape(node: geomNode, options: nil)
                        self.scnView?.scene?.rootNode.addChildNode(geomNode)
                    }
                }
            }
        }
    }
    
    //出てくる物体の形を決める関数
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
    //色をランダムに生成するための関数
    func colorValue() -> CGFloat{
        let rand = CGFloat(arc4random() % 100)
        return rand / 100
    }
    
    //いい感じのとこにコイン落とすための関数
    func randValue() -> Float{
        let rand = -(Float(arc4random() % 150))
        return rand / 10
    }
    //回転に対応するかどうか
    override func shouldAutorotate() -> Bool {
        return false
    }
    //ステータスバーを非表示にする
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
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
