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

class FlickViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorsView: UIView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var displayCellStyleControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flicksCollectionFlowLayout: UICollectionViewFlowLayout!
    
    var movies: [NSDictionary] = []
    var refreshControl = UIRefreshControl()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow table/collection views to be fed data and controlled by this view controller
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // MARK: DIPLAY0 WHICH VIEW TO DISPLAY TABLE OR COLLECTION
        if displayCellStyleControl.selectedSegmentIndex == 0 {
            tableView.isHidden = false
            collectionView.isHidden = true
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
        }
        
        // Custom styles
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.backgroundColor = UIColor(red: 49.0/255, green: 48.0/255, blue: 107.0/255, alpha: 1.0)
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor.white,
            ]
        }
        
        // Navagation Items
        displayCellStyleControl.sizeToFit()
        displayCellStyleControl.tintColor = UIColor(red: 49.0/255, green: 48.0/255, blue: 107.0/255, alpha: 0.4)
        displayCellStyleControl.backgroundColor = UIColor(red: 49.0/255, green: 48.0/255, blue: 107.0/255, alpha: 0.4)
        displayCellStyleControl.setTitleTextAttributes([
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
            NSForegroundColorAttributeName : UIColor.white,
            ], for: UIControlState.normal
        )
        
        tableView.backgroundColor = UIColor(red: 49.0/255, green: 48.0/255, blue: 107.0/255, alpha: 0.4)
        collectionView.backgroundColor = UIColor.black

        
        // Making and instance of UICollectionViewFlowLayout
        // vs creating an outlet from storyboard
//        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top:1,left:5,bottom:5,right:5)
//        layout.minimumInteritemSpacing = 1
//        layout.minimumLineSpacing = 5
//        collectionView.collectionViewLayout = layout
        flicksCollectionFlowLayout.minimumInteritemSpacing = 20
        flicksCollectionFlowLayout.minimumLineSpacing = 8
        flicksCollectionFlowLayout.sectionInset = UIEdgeInsets(top:1,left:5,bottom:5,right:5)
        
        
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
                        // MARK: DISPLAY1 RELOAD DATA
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
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
        // MARK: DISPLAY2 SUBVIEW
        tableView.addSubview(refreshControl)
        collectionView.addSubview(refreshControl)
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
                        
                        // MARK: DISPLAY3 REFRESH DATA
                        // update table view with return network data
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
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

            cell.posterImageView.alpha = 0.0
            UIView.animate(withDuration: 3.0, animations: {
                cell.posterImageView.alpha = 1.0
            })
            cell.posterImageView.setImageWith(posterUrl!)
        }
        cell.titleLabel.text = movie_title
        cell.overviewLabel.text = overviewLabel
        cell.selectedBackgroundView = cell.cellBackgroundView
        cell.backgroundColor = UIColor(red: 49.0/255, green: 48.0/255, blue: 107.0/255, alpha: 0.4)
        cell.separatorInset.top = 10
        return cell
    }
    
    
    // MARK: Collection view protocol requirements
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickCollectionCell", for: indexPath) as! FlickCollectionViewCell

        let movie = movies[indexPath.row]
        
        // Special check for poster image spec as one may not exist
        if let posterImgPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = URL(string: posterBaseUrl + posterImgPath)

            cell.posterImageView.alpha = 0.0
            UIView.animate(withDuration: 3.0, animations: {
                cell.posterImageView.alpha = 1.0
            })
            
            cell.posterImageView.setImageWith(posterUrl!)
        }
        
        let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
        cell.layer.borderColor = bcolor.cgColor
        cell.layer.borderWidth = 0.1
        cell.layer.cornerRadius = 3
        cell.backgroundColor = UIColor.black
        
        return cell
    }
    
    // Required to override cell size settings
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        
        let totalSpace = flicksCollectionFlowLayout.sectionInset.left
            + flicksCollectionFlowLayout.sectionInset.right
            + (flicksCollectionFlowLayout.minimumInteritemSpacing * CGFloat(3 - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(3))
        
        return CGSize(width: size, height: size)
//        return CGSize(width: 150  , height: 130)
        
    }
    
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return []
    }

    // Toggles movies display from list view to thumbnail view
    @IBAction func changeDisplayCellType(_ sender: Any) {
        if displayCellStyleControl.selectedSegmentIndex == 0 {
            tableView.isHidden = false
            collectionView.isHidden = true
            self.tableView.reloadData()
            
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
            self.collectionView.reloadData()
            
        }
    }


    // MARK: Segue to details view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Reference to details view
        let detailsVC = segue.destination as! DetailsViewController
        
        // Prep data to be sent to details view
        // MARK: DISPLAY4 IDENTIFY SEGUE
        
        if displayCellStyleControl.selectedSegmentIndex == 0 {
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let movie = movies[indexPath.row]
            
            // Special check for poster image spec as one may not exist
            if let posterImgPath = movie["poster_path"] as? String {
                let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
                detailsVC.posterUrl = URL(string: posterBaseUrl + posterImgPath)
            } else {
                detailsVC.posterUrl = nil
            }
            
            detailsVC.movie = movie
        } else {
            let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)! // index path is [Col, Row]
            let movie = movies[indexPath.row]
            
            // Special check for poster image spec as one may not exist
            if let posterImgPath = movie["poster_path"] as? String {
                let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
                detailsVC.posterUrl = URL(string: posterBaseUrl + posterImgPath)
            } else {
                detailsVC.posterUrl = nil
            }

            detailsVC.movie = movie
        }
    }

    // MARK: TODO'S
}
