// GameSceneManager.swift
//  snake
//
//  Created by Tyler Fehr on 11/13/18.
//  Copyright © 2018 James Ahrens. All rights reserved.
//

import SpriteKit
import CoreMotion
import Foundation

class GameSceneManager{
    
    enum directions {
        case up, down, left, right
    }
    
    var scene: GameScene
    var motionManager = CMMotionManager()
    let updateInterval = 1.0
    var nextUpdateTime = 0.0
    var direction = directions.down
    var headPosX = 10
    var headPosY = 11
    
    init(game: GameScene){
        self.scene = game
    }
    
    func initGame() {
        self.scene.snakePositions.append(SnakePosition(x: 10, y: 10))
        self.scene.snakePositions.append(SnakePosition(x: 10, y: 11))
        self.scene.snakePositions.append(SnakePosition(x: 10, y: 12))
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates()
        
        updateBoard(timePassed: 0)
    }
    
    func updateBoard(timePassed: Double) {
        if timePassed >= nextUpdateTime {
            nextUpdateTime = timePassed + updateInterval
            
            if abs(motionManager.accelerometerData?.acceleration.x ?? 0) > abs(motionManager.accelerometerData?.acceleration.y ?? 0) {
                if motionManager.accelerometerData?.acceleration.x ?? 0 >= 0 {
                    direction = directions.up
                } else {
                    direction = directions.down
                }
            } else if motionManager.accelerometerData?.acceleration.y ?? 0 >= 0 {
                direction = directions.left
            } else {
                direction = directions.right
            }
            
            switch direction {
            case .up:
                headPosY -= 1
            case .down:
                headPosY += 1
            case .left:
                headPosX -= 1
            case .right:
                headPosX += 1
            }
            
            //self.scene.boardArr[(self.scene.snakePositions[self.scene.snakePositions.count - 1].y * scene.numCols) + self.scene.snakePositions[self.scene.snakePositions.count - 1].x].node.fillColor = SKColor.red
            //self.scene.snakePositions.remove(at: self.scene.snakePositions.count - 1)
            
            self.scene.boardArr[(self.scene.snakePositions[0].y * scene.numCols) + self.scene.snakePositions[0].x].node.fillColor = SKColor.red
            self.scene.snakePositions.remove(at: 0)
            self.scene.snakePositions.append(SnakePosition(x: headPosX, y: headPosY))
            
            for part in self.scene.snakePositions {
                self.scene.boardArr[(part.y * scene.numCols) + part.x].node.fillColor = SKColor.white
            }
        }
    }
}

