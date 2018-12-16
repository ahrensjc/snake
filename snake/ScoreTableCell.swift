//
//  ScoreTableCell.swift
//  snake
//
//  Created by James Ahrens on 11/14/18.
//  Copyright © 2018 James Ahrens. All rights reserved.
//

import UIKit

class ScoreTableCell: UITableViewCell {

    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var scoreLabel : UILabel!
    @IBOutlet weak var scoreImage : UIImageView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
