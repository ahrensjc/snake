//GameScene.swift
//  snake
//
//  Created by James Ahrens on 11/13/18.
//  Copyright © 2018 James Ahrens. All rights reserved.
//

import SpriteKit
import GameplayKit



class GameScene: SKScene {
    
    var game: GameSceneManager!
    var snakePositions: [SnakePosition] = []
    var boardArr: [[BoardCell]] = [[BoardCell]]()
    var gameArea: SKShapeNode!
    
    var gameScore: Int = 0
    
    var numRows: Int = 21
    var numCols: Int = 31
    var cellSize: CGFloat = 25.0
    
    var foodExists: Bool = false
    
    var dead: Bool = false
    var sentData: Bool = false
    
    var singleton: ScoreSingleton?
    
    override func didMove(to view: SKView) {
        
        singleton = ScoreSingleton.sharedInstance
        
        fillBoard()
        
        game = GameSceneManager(game: self)
        initializeGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        game.updateBoard(timePassed: currentTime)
        
        game.died()
        
        if dead {
            for seg in snakePositions{
                boardArr[seg.x][seg.y].node.fillColor = SKColor.darkGray
            }
            
            if !sentData {
                singleton?.addScore(name: "Billy", score: gameScore)
                sentData = true
            }
            
        }
        
        if !foodExists {
            game.generateFood()
        }
        
    }
    
    func fillBoard(){
        for _ in 0 ..< (numRows) {
            var row = [BoardCell]()
            for _ in 0 ..< (numCols) {
                row.append( BoardCell() )
            }
            boardArr.append( row )
        }
    }
    
    func initializeGame(){
        
        let width = frame.size.width
        let height = frame.size.height
        
        let gameShape = CGRect(x: 0, y: 0, width: width, height: height)
        
        gameArea = SKShapeNode(rect: gameShape, cornerRadius: 0.5)
        gameArea.fillColor = SKColor.black
        gameArea.zPosition = 1
        gameArea.isHidden = false
        self.addChild(gameArea)
        createGridLines(width: width, height: height)
        
        self.game.initGame()
        
    }
    
    func createGridLines(width: CGFloat, height: CGFloat){
        
        let w = cellSize
        let r = numRows
        let c = numCols
        
        var x = CGFloat(width / -2) + (w / 2)
        var y = CGFloat(-230)
        
        for i in 0..<(r){
            
            for j in 0..<(c){
                
                let cell = SKShapeNode(rectOf: CGSize(width: w, height: w))
                cell.strokeColor = SKColor.white
                cell.fillColor = SKColor.darkGray
                cell.zPosition = 1.0
                cell.position = CGPoint(x: x, y: y)
                
                boardArr[i][j].node = cell
                boardArr[i][j].x = x
                boardArr[i][j].y = y
                
                gameArea.addChild(cell)
                
                x += w
            }
            x = CGFloat((width / -2) + (w / 2))
            y += w
        }
        
    }
    
}

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
