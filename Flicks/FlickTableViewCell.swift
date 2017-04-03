//
//  FlickCellTableViewCell.swift
//  Flicks
//
//  Created by hollywoodno on 3/31/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class FlickTableViewCell: UITableViewCell {
    
    //Mark: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    let cellBackgroundView = UIView() // Will override the default background
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // The default backgroundView view sets selected cell to grey
    // Here it's customized using the custom cellBackgroundView view
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        super.setSelected(selected, animated: animated)
        
        // sets the background color of a selected cell
        cellBackgroundView.backgroundColor = UIColor(red: 49.0/255, green: 48.0/255, blue: 107.0/255, alpha: 0.4)
    }
    
}
