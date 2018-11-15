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
    let updateInterval = 0.75
    var nextUpdateTime = 0.0
    var direction = directions.down
    
    var headPosX = 10  // initial position of snake
    var headPosY = 10
    
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
            
            // append next position to head
            self.scene.snakePositions.append(SnakePosition(x: headPosX, y: headPosY))
            
            // remove tail if it hasn't collided with food
            if !foodAtHead(){
                self.scene.boardArr[self.scene.snakePositions[0].x][self.scene.snakePositions[0].y].node.fillColor = SKColor.darkGray
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
        // if it collided with itself
        self.scene.snakePositions.forEach{ if $0.x == headPosX && $0.y == headPosY { dead = true } }
        
        // if it went off screen
        if (headPosX > scene.numRows || headPosX < 0) || (headPosY > scene.numCols || headPosY < 0) { dead = true }
        
        return dead
    }
    
    func foodAtHead() -> Bool{
        print("(\(headPosX)) - (\(headPosY))")
        if scene.boardArr[headPosX][headPosY].isFood {
            return true
        }
        else{
            return false
        }
    }
}

