//GameScene.swift
//  snake
//
//  Created by James Ahrens on 11/13/18.
//  Copyright © 2018 James Ahrens. All rights reserved.
//

import SpriteKit
import GameplayKit


class SnakePosition{
    var x: Int = 0
    var y: Int = 0
    
    init(x: Int, y: Int){
        self.x = x
        self.y = y
    }
}

class BoardCell{
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var node: SKShapeNode = SKShapeNode()
    
    init(node: SKShapeNode, x: CGFloat, y: CGFloat){
        self.x = x
        self.y = y
        self.node = node
    }
}

class GameScene: SKScene {
    
    var game: GameSceneManager!
    var snakePositions: [SnakePosition] = []
    var boardArr: [BoardCell] = []
    var gameArea: SKShapeNode!
    
    var numRows: Int = 65
    var numCols: Int = 45
    var cellSize: CGFloat = 25.0
    
    
    
    override func didMove(to view: SKView) {
        
        game = GameSceneManager(game: self)
        initializeGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        game.updateBoard(timePassed: currentTime)
    }
    
    func createCell(size: CGFloat, xPos: CGFloat, yPos: CGFloat, x: CGFloat, y: CGFloat){
        let cell = SKShapeNode(rectOf: CGSize(width: size, height: size))
        cell.strokeColor = SKColor.white
        cell.fillColor = SKColor.darkGray
        cell.zPosition = 1.0
        cell.position = CGPoint(x: x, y: y)
        boardArr.append( BoardCell(node: cell, x: xPos, y: yPos) )
        gameArea.addChild(cell)
    }
    
    func initializeGame(){
        
        let width = frame.size.width
        let height = frame.size.height
        
        let gameShape = CGRect(x: -width/2, y:-height/2, width: width, height: height)
        
        gameArea = SKShapeNode(rect: gameShape, cornerRadius: 0.5)
        gameArea.fillColor = SKColor.black
        gameArea.zPosition = 1
        gameArea.isHidden = false
        self.addChild(gameArea)
        createGridLines(width: width, height: height - 180)
        
        self.game.initGame()
    }
    
    func createGridLines(width: CGFloat, height: CGFloat){
        
        let w = cellSize
        let r = numRows
        let c = numCols
        
        var x = CGFloat(width / -2) + (w / 2)
        var y = CGFloat(height / 2) - (w / 2)
        
        for i in 0...r - 1{
            for j in 0...c - 1{
                createCell(size: w, xPos: CGFloat(i), yPos: CGFloat(j), x: x, y: y)
                x += w
            }
            x = CGFloat(width / -2) + (w / 2)
            y -= w
        }
        
    }
    
}
