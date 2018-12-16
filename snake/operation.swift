//
//  operation.swift
//  snake
//
//  Created by James Ahrens on 12/16/18.
//  Copyright © 2018 James Ahrens. All rights reserved.
//

import Foundation
import UIKit

class myOp: Operation {
    
    var url : String!
    var image : UIImage? = nil
    
    init(myUrl : String) {
        url = myUrl
    }
    
    override func main() {
        let newUrl = URL(string: url)
        let data = try? Data(contentsOf: newUrl!)
        if data != nil {
            image = UIImage(data: data!)
        }
    }
}
