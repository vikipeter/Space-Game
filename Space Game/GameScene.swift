//
//  GameScene.swift
//  Space Game
//
//  Created by Vigneshkumar G on 05/12/16.
//  Copyright © 2016 Vigneshkumar G. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    let alienCategory : UInt32 = 0x1 << 0
    let bulletCategory : UInt32 = 0x1 << 1
    
    
    var aliendsDestroyed : Int = 0
    
    var playerNode : SKSpriteNode!
  
    override init(size: CGSize) {
        super.init(size: size)
        doInitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doInitialize()
    }
    
    func doInitialize()
    {
        self.backgroundColor = SKColor.black
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        self.addPlayer()
        self.addAlien()
    }
    
    func addPlayer()
    {
        playerNode = SKSpriteNode(imageNamed: "shuttle")
        playerNode.position = CGPoint(x: self.frame.size.width/2.0, y: 50)
        self.addChild(playerNode)
    }
    
    func addAlien()
    {
        let alienNode = SKSpriteNode(imageNamed: "alien")
        alienNode.physicsBody = SKPhysicsBody(rectangleOf: alienNode.size)
        alienNode.physicsBody?.isDynamic = true
        alienNode.physicsBody?.categoryBitMask = alienCategory
        alienNode.physicsBody?.contactTestBitMask = bulletCategory
        alienNode.physicsBody?.collisionBitMask = 0
        
        let minX = alienNode.size.width / 2
        let maxX = self.frame.size.width - alienNode.size.width / 2
        let rangeX = maxX - minX
        
        let randomNumber = abs(Int(arc4random()))
        let randomPositionX = CGFloat(randomNumber).truncatingRemainder(dividingBy:CGFloat(rangeX)) + CGFloat(minX)
        alienNode.position = CGPoint(x: randomPositionX, y: self.frame.size.height - alienNode.size.height/2)
        self.addChild(alienNode)
        
        let minDuration = 4
        let maxDuration = 6
        let rangeDuration = maxDuration - minDuration
        let randomDuration = CGFloat(randomNumber).truncatingRemainder(dividingBy: CGFloat(rangeDuration)) + CGFloat(minDuration)
        
        let moveAction = SKAction.move(to: CGPoint(x: randomPositionX, y: -alienNode.size.height), duration: TimeInterval(randomDuration))
        
        let blockAction = SKAction.run { 
            let transition : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene : SKScene = GameEndScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: transition)
        }
        
        let removeAction = SKAction.removeFromParent()
        
        let sequenceAction = SKAction.sequence([moveAction,blockAction,removeAction])
        
        alienNode.run(sequenceAction)
    }
    
    override func didMove(to view: SKView) {
        
        /*
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }*/
    }
    
    /*
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    */
    
    var lastYieldTimeInterval:TimeInterval = TimeInterval()
    var lastUpdateTimerInterval:TimeInterval = TimeInterval()
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate:CFTimeInterval){
        
        lastYieldTimeInterval += timeSinceLastUpdate
        if (lastYieldTimeInterval > 1){
            lastYieldTimeInterval = 0
            addAlien()
        }
        
    }
    
    private var lastArrival : TimeInterval = TimeInterval()
    
    override func update(_ currentTime: TimeInterval)
    {
        var timeSinceLastUpdate = currentTime - lastUpdateTimerInterval
        lastUpdateTimerInterval = currentTime
        
        if (timeSinceLastUpdate > 1){
            timeSinceLastUpdate = 1/60
            lastUpdateTimerInterval = currentTime
        }
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate: timeSinceLastUpdate)
    }
    
    //MARK : Touches
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let soundAction = SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false)
        self.run(soundAction)
        
        let touch : UITouch = touches.first! as UITouch
        let location : CGPoint = touch.location(in: self)
        
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.position = playerNode.position
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width/2)
        torpedoNode.physicsBody?.isDynamic = true
        torpedoNode.physicsBody?.categoryBitMask = bulletCategory
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        let offset = VectorArithmetic.vectorSubtract(a: location, b: torpedoNode.position)
        if offset.y < 0
        {
            return
        }
        self.addChild(torpedoNode)
        
        let direction : CGPoint = VectorArithmetic.vectorNormalize(a: offset)
        
        let shortLength : CGPoint = VectorArithmetic.vectorMultiplay(a: direction, b: 2000)
        let finalDestination : CGPoint = VectorArithmetic.vectorAdd(a: torpedoNode.position, b: shortLength)
        
        let velocity = 2 * 568 / 1
        let moveDuration = CGFloat(self.size.width) / CGFloat(velocity)
        
        let moveAction = SKAction.move(to: finalDestination, duration: TimeInterval(moveDuration))
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([moveAction,removeAction])
        torpedoNode.run(sequenceAction)
    }
}

extension GameScene : SKPhysicsContactDelegate
{
    func torpedoCollideWithAlien(torpedoNode:SKSpriteNode,aliendNode:SKSpriteNode)
    {
        print("Hit")
        torpedoNode.removeFromParent()
        aliendNode.removeFromParent()
 
        aliendsDestroyed = aliendsDestroyed + 1
        
        if aliendsDestroyed > 10
        {
            let transition : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameWinScene : GameEndScene = GameEndScene(size: self.size, won: true)
            self.view?.presentScene(gameWinScene, transition: transition)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask == alienCategory && contact.bodyB.categoryBitMask == bulletCategory)
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        else if (contact.bodyA.categoryBitMask == bulletCategory && contact.bodyB.categoryBitMask == alienCategory)
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else
        {
            return
        }
        torpedoCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, aliendNode: secondBody.node as! SKSpriteNode)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
