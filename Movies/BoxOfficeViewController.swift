//
//  BoxOfficeViewController.swift
//  Movies
//
//  Created by huy ngo on 11/10/15.
//  Copyright © 2015 huy ngo. All rights reserved.
//

import UIKit
import SystemConfiguration
class BoxOfficeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var buttonImage: UIButton!
    @IBOutlet var moviestableView: UITableView!
    @IBOutlet var noNetworkView: UIView!
    @IBOutlet var moviescollectionView: UICollectionView!
    var searchActive : Bool = false
    var pressed = false

    var dataMovies :[NSDictionary]=[]
    var filterMovies :[NSDictionary]=[]
    
    
    @IBAction func changeVIew(sender: AnyObject) {
        if !pressed{
            self.moviestableView.hidden = true
            self.moviescollectionView.hidden = false
            self.searchBar.hidden = true
            buttonImage.setImage(UIImage(named: "list.png"), forState:.Normal)
            pressed = true
        }else{
            self.moviestableView.hidden = false
            self.moviescollectionView.hidden = true
            self.searchBar.hidden = false
            buttonImage.setImage(UIImage(named: "grid1.png"), forState:.Normal)
            pressed = false
        }
    }
    var url = NSURL(string: "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214")!
    
    var movies = [NSDictionary]()
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        moviestableView.delegate = self
        moviestableView.dataSource = self
        moviescollectionView.delegate = self
        moviescollectionView.dataSource = self
        
        searchBar.delegate = self
        searchBar.placeholder = "search here"
        searchBar.barStyle = UIBarStyle.BlackTranslucent
        
        self.noNetworkView.hidden = true
        self.moviestableView.hidden = false
        self.moviescollectionView.hidden = true
        
        self.buttonImage.setImage(UIImage(named: "grid1.png"), forState:.Normal)
        //NavigationBar
        
        title = "Movies"

        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        
        fetchMovie()
        
        
        //refresh
        refreshControl.addTarget(self, action: Selector("fetchMovie"), forControlEvents: UIControlEvents.ValueChanged)
        moviestableView.addSubview(refreshControl)
        
     
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(searchActive) {
            print("return filterMovies \(filterMovies.count)")
            return filterMovies.count
        }
        print("return movies \(movies.count)")
        return movies.count;
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! movieTableViewCell
        var movie : NSDictionary = NSDictionary()
        if(searchActive && filterMovies.count > 0) {
            movie = filterMovies[indexPath.row]
            
        } else {
            movie = movies[indexPath.row]
        }
        
        let urlImage = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        let request = NSURLRequest(URL: urlImage)
        let cachedImage = UIImageView.sharedImageCache().cachedImageForRequest(request)
        if (cachedImage != nil) {
            cell.posterImageView.image = cachedImage
        } else {
            cell.posterImageView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) in
                cell.posterImageView.alpha = 0.0
                cell.posterImageView.image = image
                UIView.animateWithDuration(1.5, animations: {
                    cell.posterImageView.alpha = 1.0
                })
                }, failure: nil)
        }
        
        cell.titleLabel.text = (movie["title"]) as? String
        cell.yearLabel.text = String((movie["year"])as! intmax_t)
        
        //rating
        var intRank = (movie.valueForKeyPath("ratings.audience_score")) as! intmax_t
        if (intRank>=95) {
            cell.star3Image.image = UIImage(named: "yellow.png")
            cell.star4image.image = UIImage(named: "yellow.png")
            cell.star5image.image = UIImage(named: "yellow.png")
        }
        else if (intRank<95 && intRank>85) {
            cell.star3Image.image = UIImage(named: "yellow.png")
            cell.star4image.image = UIImage(named: "yellow.png")
            cell.star5image.image = UIImage(named: "halfyellow.png")
        }
        else if (intRank<85 && intRank>88) {
            cell.star5image.image = UIImage(named: "grey.png")
        }
        else if (intRank<86 && intRank>75) {
            cell.star3Image.image = UIImage(named: "yellow.png")
            cell.star4image.image = UIImage(named: "yellow.png")
            cell.star5image.image = UIImage(named: "grey.png")
        }
        else if (intRank<76 && intRank>70) {
            cell.star3Image.image = UIImage(named: "yellow.png")
            cell.star4image.image = UIImage(named: "grey.png")
            cell.star5image.image = UIImage(named: "grey.png")
        }
        else if (intRank<71 && intRank>60) {
            cell.star3Image.image = UIImage(named: "halfyellow.png")
            cell.star4image.image = UIImage(named: "grey.png")
            cell.star5image.image = UIImage(named: "grey.png")
        }
        else if (intRank<61) {
            cell.star3Image.image = UIImage(named: "grey.png")
            cell.star4image.image = UIImage(named: "grey.png")
            cell.star5image.image = UIImage(named: "grey.png")
        }

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 131
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        moviestableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        view.endEditing(true)
//        searchActive = false
//    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tableCell"{
        let cell = sender as! UITableViewCell
        let indexPath = moviestableView.indexPathForCell(cell)!
        var movie : NSDictionary = NSDictionary()
            if(searchActive){
                movie = filterMovies[indexPath.row]
            } else {
                movie = movies[indexPath.row]
            }
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailViewController
        movieDetailsViewController.movie = movie
        }else if segue.identifier == "collectionCell" {
            let cell = sender as! UICollectionViewCell
            let indexPath = moviescollectionView.indexPathForCell(cell)!
            let movie = movies[indexPath.row]
            let movieDetailsViewController = segue.destinationViewController as! MovieDetailViewController
            movieDetailsViewController.movie = movie

        }
            
    }
    
    func fetchMovie(){
        print("fetch movie search false")
        searchActive = false
        view.endEditing(true)
        //if isConnectedToNetwork() == true {
        self.searchBar.hidden = false
        self.noNetworkView.hidden = true
        CozyLoadingActivity.show("Loading...", disableUI: true)
        
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard error == nil else  {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.noNetworkView.hidden = false
                    self.searchBar.hidden = true
                    self.moviestableView.reloadData()
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.noNetworkView.frame = CGRect(x:0,y:65, width:self.noNetworkView.frame.width, height:  self.noNetworkView.frame.height)
                    })
                    CozyLoadingActivity.hide(success: false, animated: true)
                    self.refreshControl.endRefreshing()
                    self.moviestableView.reloadData()
                })
                print("error loading from URL", error!)
                return
            }
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            //print(json)
            self.movies = json["movies"] as! [NSDictionary]
          /*  for var index = 0; index < self.movies.count; ++index {
                let movietitle = self.movies[index]
                self.datasearch += [(movietitle["title"]) as! String]
                print(self.datasearch)
            } */
            // print("movies", self.movies)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.moviestableView.reloadData()
                self.moviescollectionView.reloadData()
                self.buttonImage.setImage(UIImage(named: "grid1.png"), forState:.Normal)
                CozyLoadingActivity.hide()
                self.refreshControl.endRefreshing()
               
            })        // Do any additional setup after loading the view.
        }
        
        task.resume()
        
    }
    
    //check network connection
    /*
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .Reachable
        let needsConnection = flags == .ConnectionRequired
        
        return isReachable && !needsConnection
        
    }
        */
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("moviesCollectionView", forIndexPath: indexPath) as! moviesCollectionViewCell
         let movie = movies[indexPath.row]
         let urlImage = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        cell.postersCollectionImageView.setImageWithURL(urlImage)
        cell.titleCollectionLabel.text = (movie["title"]) as? String
        cell.yearCollectionLabel.text = String((movie["year"])as! intmax_t)
        return cell
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
      //  print("searchBarTextDidBeginEditing true")
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
     //   print("searchBarTextDidEndEditing false")
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
      //  print("searchBarCancelButtonClicked")
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
     //   print("textDidChange")
        filterMovies = movies.filter({ (movie) -> Bool in
            let tmp: NSDictionary = movie
            let range = tmp["title"]!.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filterMovies.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.moviestableView.reloadData()
    }

    
}
