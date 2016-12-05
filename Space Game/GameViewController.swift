//
//  GameViewController.swift
//  Space Game
//
//  Created by Vigneshkumar G on 05/12/16.
//  Copyright © 2016 Vigneshkumar G. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {

    var bgMusicPlayer : AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgMusicFileUrl = Bundle.main.url(forResource: "bgmusic", withExtension: "mp3")
        
        do{
            bgMusicPlayer = try AVAudioPlayer(contentsOf: bgMusicFileUrl!)
            bgMusicPlayer.numberOfLoops = -1
            bgMusicPlayer.prepareToPlay()
//            bgMusicPlayer.play()
        }
        catch
        {
            
        }
        
        if let view = self.view as! SKView? {
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
            
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
        }
    }
 
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
