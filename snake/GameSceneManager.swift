// GameSceneManager.swift
//  snake
//
//  Created by Tyler Fehr on 11/13/18.
//  Copyright © 2018 James Ahrens. All rights reserved.
//

import Foundation

class GameSceneManager{
    
    var scene: GameScene
    
    init(game: GameScene){
        self.scene = game
    }
    
    func initGame() {
        self.scene.snakePositions.append(SnakePosition(x: 10, y: 10))
        self.scene.snakePositions.append(SnakePosition(x: 10, y: 11))
        self.scene.snakePositions.append(SnakePosition(x: 10, y: 12))
        updateBoard()
    }
    
    func updateBoard() {
        
    }
}

