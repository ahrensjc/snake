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
    var isFood: Bool
    
    init(){
        self.isFood = false
    }
}

class GameScene: SKScene {
    
    var game: GameSceneManager!
    var snakePositions: [SnakePosition] = []
    var boardArr: [[BoardCell]] = [[BoardCell]]()
    var gameArea: SKShapeNode!
    
    var numRows: Int = 65
    var numCols: Int = 45
    var cellSize: CGFloat = 25.0
    
    var foodExists: Bool = false
    
    override func didMove(to view: SKView) {
        
        fillBoard()
        
        game = GameSceneManager(game: self)
        initializeGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        game.updateBoard(timePassed: currentTime)
        
        if !foodExists {
            game.generateFood()
        }
    }
    
    func fillBoard(){
        for _ in 0 ..< numRows {
            var row = [BoardCell]()
            for _ in 0 ..< numCols{
                row.append( BoardCell() )
            }
            boardArr.append(row)
        }
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
        
        for i in 0..<r - 1{
            
            for j in 0..<c - 1{
                let cell = SKShapeNode(rectOf: CGSize(width: w, height: w))
                cell.strokeColor = SKColor.white
                cell.fillColor = SKColor.darkGray
                cell.zPosition = 1.0
                cell.position = CGPoint(x: x, y: y)
                print("\(i) - \(j)")
                
                boardArr[i][j].node = cell
                boardArr[i][j].x = x
                boardArr[i][j].y = y
                
                gameArea.addChild(cell)
                
                x += w
            }
            x = CGFloat(width / -2) + (w / 2)
            y -= w
        }
        
    }
    
}
