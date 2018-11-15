//
//  ScoreSingleton.swift
//  snakeProject
//
//  Created by Tyler Fehr on 11/13/18.
//  Copyright © 2018 James Ahrens. All rights reserved.
//

import Foundation

class ScoreSingleton : NSObject {
    
    var names : [String : String]
    var scores : [String : Int]
    let fileUrl : URL
    let scoreUrl : URL
    static let sharedInstance = ScoreSingleton()
    
    private override init() {
        scores = [String : Int]()
        names = [String : String]()
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dirUrl = URL(fileURLWithPath: dirPath)
        fileUrl = dirUrl.appendingPathComponent("high_scores.txt")
        
        let dirPath2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dirUrl2 = URL(fileURLWithPath: dirPath2)
        scoreUrl = dirUrl2.appendingPathComponent("names.txt")
        
        names["0"] = "Dev"
        scores["0"] = 1
        //scores["Dev"] = 999
        //scores.append(["Dev" : 999])
        
         /*do {
         // Convert words into JSON data
         let data = try JSONSerialization.data(withJSONObject: scores, options: .prettyPrinted)
         print(data)
         // Write JSON data to file
         try data.write(to: scoreUrl)
         } catch {
         print("error in deinit")
         }
        do {
            let nameData = try JSONSerialization.data(withJSONObject: names, options: .prettyPrinted)
            try nameData.write(to: fileUrl)
        } catch {
            print("error writing")
        }*/
        
        
        super.init()
        print("attempting to read file now")
        
        do {
            let data = try Data(contentsOf: fileUrl)
            print(data)
            names = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : String]
            print(names)
        } catch {
            print("file load error...")
        }
        
        do {
            let data = try Data(contentsOf: scoreUrl)
            print(data)
            scores = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : Int]
            print(scores)
        } catch {
            print("file load error...")
        }
    }
    
    func addScore(name : String, score : Int) {
        scores[String(scores.count)] = score
        names[String(scores.count)] = name
        do {
            // Convert words into JSON data
            let data = try JSONSerialization.data(withJSONObject: scores, options: .prettyPrinted)
            // Write JSON data to file
            try data.write(to: scoreUrl)
        } catch {
            print("error adding score")
        }
        
        do {
            // Convert words into JSON data
            let data = try JSONSerialization.data(withJSONObject: names, options: .prettyPrinted)
            // Write JSON data to file
            try data.write(to: fileUrl)
        } catch {
            print("error adding score")
        }
    }
    
    deinit {
        do {
            // Convert words into JSON data
            let data = try JSONSerialization.data(withJSONObject: scores, options: .prettyPrinted)
            // Write JSON data to file
            try data.write(to: scoreUrl)
        } catch {
            print("error in deinit")
        }
        
        do {
            // Convert words into JSON data
            let data = try JSONSerialization.data(withJSONObject: names, options: .prettyPrinted)
            // Write JSON data to file
            try data.write(to: fileUrl)
        } catch {
            print("error adding score")
        }
    }
    
}

