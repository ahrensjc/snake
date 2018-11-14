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
    let updateInterval = 0.5
    var nextUpdateTime = 0.0
    var direction = directions.left
    
    var headPosX = 10 // initial position of snake
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
    
    
    func generateFood(){
        let fx = Int.random(in: 5...scene.numRows - 5)
        let fy = Int.random(in: 5...scene.numCols - 5)
        
        self.scene.boardArr[fx][fy].node.fillColor = SKColor.green
        self.scene.boardArr[fx][fy].isFood = true
        
        scene.foodExists = true
    }
    
    func updateBoard(timePassed: Double) {
        if timePassed >= nextUpdateTime {
            nextUpdateTime = timePassed + updateInterval
            
            
            let motionDataX = motionManager.accelerometerData?.acceleration.x
            let motionDataY = motionManager.accelerometerData?.acceleration.y
            
            
            if abs(motionDataX ?? 0) > abs(motionDataY ?? 0) {
                if motionDataX ?? 0 >= 0 {
                    direction = directions.up
                }
                else {
                    direction = directions.down
                }
            }
            else if motionDataY ?? 0 >= 0 {
                direction = directions.left
            }
            else {
                direction = directions.right
            }
            
            adjustDirection()
            
            
            let snakePos = self.scene.snakePositions
            
            self.scene.boardArr[snakePos[0].x][snakePos[0].y].node.fillColor = SKColor.red
            
            // append next position to head
            self.scene.snakePositions.append(SnakePosition(x: headPosX, y: headPosY))
            
            // remove tail if it hasn't collided with food
            if !foodAtHead(){
                self.scene.snakePositions.remove(at: 0)
            }
            
            // color position of snake
            self.scene.snakePositions.forEach{ self.scene.boardArr[$0.x][$0.y].node.fillColor = SKColor.red }
        }
    }
    func adjustDirection(){
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
    }
    
    func died() -> Bool{
        
        var dead: Bool = false
        
        var pos = scene.snakePositions
        let head = pos[0]
        pos.remove(at: 0) // don't check if head collides with head
        
        // if it collided with itself
        pos.forEach{ if $0.x == head.x && $0.y == head.y { dead = true } }
        
        // if it went off screen
        if (head.x > scene.numRows || head.x < 0) || (head.y > scene.numCols || head.y < 0) {
            dead = true
        }
        
        return dead
    }
    
    func foodAtHead() -> Bool{
        var pos = scene.snakePositions
        let head = pos[0]
        
        if scene.boardArr[head.x][head.y].isFood {
            return true
        }
        else{
            return false
        }
    }
}

