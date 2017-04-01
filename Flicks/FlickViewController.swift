//
//  FlickViewController.swift
//  Flicks
//
//  Created by hollywoodno on 3/31/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class FlickViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary] = []
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var errorsView: UIView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // allow table view to be fed data and controlled by this view controller
        tableView.dataSource = self
        tableView.delegate = self

        // MARK: Network Request
        
        // Original API data
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                // Handle any inital errors
                self.errorsView.isHidden = true
                
                if let errorMessage = error?.localizedDescription {
                    self.errorDescriptionLabel.text = errorMessage
                    self.errorsView.isHidden = false
                    return
                }
                
                // Process JSON response
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                    
                        // The data of interest is stored in the 'results' key.
                        // It will be the movies.
                        let responseFieldDictionary = responseDictionary["results"] as! [NSDictionary]
                    
                        self.movies = responseFieldDictionary
                    
                        // update table view with return network data
                        self.tableView.reloadData()
                    }
                } else {
                    // No data returned from response
                    self.errorDescriptionLabel.text = error?.localizedDescription
                    self.errorsView.isHidden = false
                    return
                }
        });
        task.resume()
        
        // Refresh API data
        refreshControl.addTarget(self, action: #selector(FlickViewController.refreshMovieData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    // Retrieve updated movie data and refresh table
    func refreshMovieData() {
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // The data of interest is stored in the 'results' key.
                        // It will be the movies.
                        let responseFieldDictionary = responseDictionary["results"] as! [NSDictionary]
                        
                        self.movies = responseFieldDictionary
                        
                        // update table view with return network data
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }
        });
        task.resume()
    }
    
    // MARK: Construct table view and rows
    
    // 1 of 2 required method by UITableViewDataSource Protocol
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
        
    }
    
    // 2 of 2 required method by UITableViewDataSource Protocol
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Flick cell is a resuable custom cell that will display individual movie specs
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlickCell") as! FlickTableViewCell
        let movie = movies[indexPath.row]
        
        // Prep cell/movie specs
        let movie_title = movie["original_title"] as! String
        let overviewLabel = movie["overview"] as! String
        
        // Special check for poster image spec as one may not exist
        if let posterImgPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = URL(string: posterBaseUrl + posterImgPath)
            cell.posterImageView.setImageWith(posterUrl!)
        }
        else {
            // Absent poster image
            cell.posterImageView.image = nil
        }
        
        // Set remaining cell specs
        cell.titleLabel.text = movie_title
        cell.overviewLabel.text = overviewLabel
        
        return cell
    }
    
    // MARK: Segue to details view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Reference to details view
        let detailsVC = segue.destination as! DetailsViewController

        // Prep data to be sent to details view
        let sender = sender as! FlickTableViewCell
        let indexPath = tableView.indexPath(for: sender)! // index path is [Col, Row]
        let movie = movies[indexPath.row]
        
        // Special check for poster image spec as one may not exist
        if let posterImgPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            detailsVC.posterUrl = URL(string: posterBaseUrl + posterImgPath)
        } else {
            detailsVC.posterUrl = nil
        }
        
        // Set remaining details view properties
        detailsVC.movieCell = sender
        detailsVC.movie = movie
    }

    // MARK: TODO'S
    /* Safety checks for API calls */
//    in the network request, if you don't get a response dictionary back, you can assume there was an error. You can also check the error parameter. Hide or show the network error view depending on what happened.
}
