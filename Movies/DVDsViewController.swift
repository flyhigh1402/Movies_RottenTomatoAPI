//
//  DVDsViewController.swift
//  Movies
//
//  Created by huy ngo on 11/12/15.
//  Copyright © 2015 huy ngo. All rights reserved.
//
import UIKit
import SystemConfiguration
class DVDsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var dvdstableView: UITableView!
    @IBOutlet var noNetworkView: UIView!
    
    var url = NSURL(string: "https://coderschool-movies.herokuapp.com/dvds?api_key=xja087zcvxljadsflh214")!
    var movies = [NSDictionary]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        dvdstableView.delegate = self
        dvdstableView.dataSource = self
        self.noNetworkView.hidden = true
        
        title = "DVDs"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        
        CozyLoadingActivity.show("Loading...", disableUI: true)
        
        //refresh
        refreshControl.addTarget(self, action: Selector("fetchMovie"), forControlEvents: UIControlEvents.ValueChanged)
        dvdstableView.addSubview(refreshControl)
        
        
        if isConnectedToNetwork() == true {
            fetchMovie()
        }else{
            CozyLoadingActivity.hide(success: false, animated: true)
            self.noNetworkView.hidden=false
            print("falled")
        }
        /*  let URLCache = NSURLCache(memoryCapacity: 4*1024*1024, diskCapacity: 20*1024*1024, diskPath: nil)
        let URLRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 600)
        URLCache.cachedResponseForRequest(URLRequest)
        */
    }
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return movies.count
    }
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("dvdCell", forIndexPath: indexPath) as! DVDsCell
        
        let movie = movies[indexPath.row]
        
        let urlImage = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        cell.titleLabel.text = (movie["title"]) as? String
        cell.posterImageView.setImageWithURL(urlImage)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dvdstableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dvdsegue"{
            let cell = sender as! UITableViewCell
            let indexPath = dvdstableView.indexPathForCell(cell)!
            let movie = movies[indexPath.row]
            let movieDetailsViewController = segue.destinationViewController as! MovieDetailViewController
            movieDetailsViewController.movie = movie
        }
    }
    func fetchMovie(){
        if isConnectedToNetwork() == true {
            let request = NSURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                guard error == nil else  {
                    print("error loading from URL", error!)
                    return
                }
                
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                //print(json)
                self.movies = json["movies"] as! [NSDictionary]
                // print("movies", self.movies)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.dvdstableView.reloadData()
                    CozyLoadingActivity.hide()
                    self.refreshControl.endRefreshing()
                })        // Do any additional setup after loading the view.
            }
            task.resume()
        }else{
            refreshControl.endRefreshing()
            print("falled")
        }
    }
    
    //check network connection
    
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
    
}
