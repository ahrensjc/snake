//
//  ScoreSingleton.swift
//  snakeProject
//
//  Created by Tyler Fehr on 11/13/18.
//  Copyright © 2018 James Ahrens. All rights reserved.
//

import Foundation

class ScoreSingleton : NSObject {
    
    var scores : [String : Int]
    let fileUrl : URL
    static let sharedInstance = ScoreSingleton()
    
    private override init() {
        scores = [String : Int]()
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dirUrl = URL(fileURLWithPath: dirPath)
        fileUrl = dirUrl.appendingPathComponent("high_scores.txt")
        
        //scores["Dev"] = 999
        //scores.append(["Dev" : 999])
        
        /*do {
         // Convert words into JSON data
         let data = try JSONSerialization.data(withJSONObject: scores, options: .prettyPrinted)
         print(data)
         // Write JSON data to file
         try data.write(to: fileUrl)
         } catch {
         print("error in deinit")
         }*/
        
        super.init()
        print("attempting to read file now")
        
        do {
            let data = try Data(contentsOf: fileUrl)
            print(data)
            scores = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : Int]
            print(scores)
        } catch {
            print("file load error...")
        }
    }
    
    func addScore(name : String, score : Int) {
        scores[name] = score
        do {
            // Convert words into JSON data
            let data = try JSONSerialization.data(withJSONObject: scores, options: .prettyPrinted)
            // Write JSON data to file
            try data.write(to: fileUrl)
        } catch {
            print("error in deinit")
        }
    }
    
    deinit {
        do {
            // Convert words into JSON data
            let data = try JSONSerialization.data(withJSONObject: scores, options: .prettyPrinted)
            // Write JSON data to file
            try data.write(to: fileUrl)
        } catch {
            print("error in deinit")
        }
    }
    
}

