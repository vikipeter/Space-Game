//
//  GameEndScene.swift
//  Space Game
//
//  Created by Vigneshkumar G on 05/12/16.
//  Copyright © 2016 Vigneshkumar G. All rights reserved.
//

import UIKit
import SpriteKit

class GameEndScene: SKScene {

    var message : String!
    
    init(size: CGSize,won:Bool) {
        
        super.init(size: size)
        if won {
            
            message = "You won !!!"
        }
        else{
            
            message = "Game over !!"
        }
        doInitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doInitialize()
    {
        self.backgroundColor = SKColor.black
        
        let labelNode : SKLabelNode = SKLabelNode(fontNamed: "Avenir-LightOblique")
        labelNode.text = message
        labelNode.fontColor = SKColor.white
        labelNode.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        labelNode.fontSize = 50.0
        self.addChild(labelNode)
        
        let waitAction = SKAction.wait(forDuration: 3.0)
        let blockAction = SKAction.run { 
            let transition : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameScene : SKScene = GameScene(size: self.size)
            self.view?.presentScene(gameScene, transition: transition)
        }
        self.run(SKAction.sequence([waitAction,blockAction]))
    }
}
