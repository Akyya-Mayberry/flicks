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
    public var movieCell: FlickTableViewCell!
    public var movie: NSDictionary = [:]
    public var posterUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie["original_title"] as? String
        descriptionLabel.text = movie["overview"] as? String
        descriptionLabel.sizeToFit()
        
        // Special check for poster image spec as one may not exist
        if let posterUrl = posterUrl {
            posterView.setImageWith(posterUrl)
        } else {
            posterView.image = nil
        }
        
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
}
