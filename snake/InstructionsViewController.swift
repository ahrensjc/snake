//
//  InstructionsViewController.swift
//  snake
//
//  Created by James Ahrens on 12/16/18.
//  Copyright © 2018 James Ahrens. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = myImageView.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        let queue = OperationQueue()
        let urlString = "https://cdn.pixabay.com/photo/2013/07/12/12/15/snake-145410_1280.png"
        let op = myOp(myUrl: urlString)
        op.completionBlock = {
            OperationQueue.main.addOperation({
                if let downloadedImage = op.image {
                    //self.images.append(downloadedImage)
                    //self.images[i] = downloadedImage
                    self.myImageView.image = downloadedImage
                }
                self.activityIndicator.stopAnimating()
            })
            
        }
        queue.addOperation(op)
        let orientation = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(orientation, forKey: "orientation")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
