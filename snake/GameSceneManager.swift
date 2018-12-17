// GameSceneManager.swift
//  snake
//
//  Created by Tyler Fehr on 11/13/18.
//  Copyright © 2018 James Ahrens. All rights reserved.
//

import SpriteKit
import CoreMotion
import Foundation

class GameSceneManager {
    
    enum directions {
        case up, down, left, right
    }
    
    var scene: GameScene
    var motionManager = CMMotionManager()
    var updateInterval = 0.75
    var nextUpdateTime = 0.0
    var direction = directions.down
    
    var headPosX = 10{
        didSet{
            if headPosX < 0 {
                headPosX = self.scene.numRows-1
            }
            if headPosX > self.scene.numRows-1 {
                headPosX = 0
            }
        }
    }
    var headPosY = 10 {
        didSet{
            if headPosY < 0 {
                headPosY = self.scene.numCols-1
            }
            if headPosY > self.scene.numCols-1 {
                headPosY = 0
            }
        }
    }
    
    init(game: GameScene){
        self.scene = game
    }
    
    func initGame() {
        self.scene.snakePositions.append(SnakePosition(x: 10, y: 12))
        self.scene.snakePositions.append(SnakePosition(x: 10, y: 11))
        self.scene.snakePositions.append(SnakePosition(x: 10, y: 10))
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates()
        
        updateBoard(timePassed: 0)
    }
    
    func isConflict(x: Int, y: Int) -> Bool {
        for pos in self.scene.snakePositions{
            if pos.x == x || pos.y == y {
                return true
            }
        }
        return false
    }
    
    func generateFood(){
        
        
        var rx = Int.random(in: 5...scene.numRows - 5)
        var ry = Int.random(in: 5...scene.numCols - 5)

        while isConflict(x: rx, y: ry) {
            rx = Int.random(in: 5...scene.numRows - 5)
            ry = Int.random(in: 5...scene.numCols - 5)
        }
        
        self.scene.boardArr[rx][ry].node.fillColor = SKColor.green
        self.scene.boardArr[rx][ry].isFood = true
        self.scene.foodExists = true
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
            else{
                self.scene.gameScore += 1
                self.scene.foodExists = false
                updateInterval = updateInterval * 0.90
            }
            
            // color snake
            for part in self.scene.snakePositions {
                self.scene.boardArr[part.x][part.y].node.fillColor = SKColor.red
            }
        }
    }
    
    func adjustDirection(){
        switch direction {
        case .up:
            headPosX += 1
        case .down:
            headPosX -= 1
        case .left:
            headPosY -= 1
        case .right:
            headPosY += 1
        }
    }
    
    func died(){
        for i in 0..<self.scene.snakePositions.count - 1 {
            if self.scene.snakePositions[i].x == headPosX && self.scene.snakePositions[i].y == headPosY {
                self.scene.dead = true
            }
        }
        
        
    }
    
    func foodAtHead() -> Bool{
        if scene.boardArr[headPosX][headPosY].isFood {
            return true
        }
        else{
            return false
        }
    }
    
    func resetGame(){
        self.scene.snakePositions.removeAll()
        self.scene.gameScore = 0
        updateInterval = 0.75
        self.scene.dead = false
        
        self.scene.snakePositions.append(SnakePosition(x: 10, y: 12))
        self.scene.snakePositions.append(SnakePosition(x: 10, y: 11))
        self.scene.snakePositions.append(SnakePosition(x: 10, y: 10))
        headPosX = 10
        headPosY = 10
    }
    
    func presentHighScoreAlert(name: String, score: Int){
        self.scene.sentData = true
        let alertController = UIAlertController(title: "New High Score", message: "Enter your name:", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Name"
        })
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let input = alertController.textFields?[0].text
            
            self.scene.userName = (input == nil) ? "Snake Player" : input!
            
            self.scene.singleton?.addScore(name: self.scene.userName, score: self.scene.gameScore)
            
            print("Score added for \(String(describing: self.scene.userName))")
        })
        
        alertController.addAction(confirmButton)
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

