//
//  GameViewController.swift
//  Lucky Thief
//
//  Created by Matheus Cardoso kuhn on 07/06/16.
//  Copyright (c) 2016 Warrior Iena. All rights reserved.
//

import UIKit
import SpriteKit
import GameController

class GameViewController: GCEventViewController {

    var scene: GameMountainScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameMountainScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            self.controllerUserInteractionEnabled = true
            
            self.scene = scene
            
            skView.presentScene(scene)
        }
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        
        self.scene.pressesBegan(presses, withEvent: event)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
