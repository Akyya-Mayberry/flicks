//
//  DetailsViewController.swift
//  Flicks
//
//  Created by hollywoodno on 3/31/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var descriptionScrollView: UIScrollView!
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    public var movie: FlickTableViewCell!
    public var posterUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie.titleLabel.text
        posterView.setImageWith(posterUrl)
        descriptionLabel.text = movie.overviewLabel.text
        descriptionLabel.sizeToFit()
        
        // Scroll
        // Content width same as scroll view frame,
        detailsScrollView.contentSize = CGSize(width: detailsScrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: TODO'S
    /* Make overview/description view scrollable */

}
