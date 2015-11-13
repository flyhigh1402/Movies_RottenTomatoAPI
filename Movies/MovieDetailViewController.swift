//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by huy ngo on 11/10/15.
//  Copyright © 2015 huy ngo. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, UIScrollViewDelegate {
    var idArray : NSArray = []
    
    @IBOutlet var posterDetailImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var runTimeLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    @IBOutlet var scrollDetailView: UIScrollView!
    
    @IBOutlet var summaryTextView: UITextView!
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = movie["title"] as? String
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
       
        scrollDetailView.userInteractionEnabled = true
        scrollDetailView.scrollEnabled = false
        scrollDetailView.contentSize = CGSizeMake(320, 480)

        titleLabel.text = movie["title"] as? String
        //summaryLabelDetail.text = movie["synopsis"] as? String
        summaryTextView.text = movie["synopsis"] as? String
        let length = String((movie["runtime"])as! intmax_t)
        runTimeLabel.text = "Length: \(length) mins"
        let rate = (movie.valueForKeyPath("ratings.critics_score")) as! intmax_t
        ratingLabel.text = "Rating: \(rate)"
        
        let urlImage = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        posterDetailImageView.setImageWithURL(urlImage)
        let urlHighResImage = NSURL(string: movie.valueForKeyPath("posters.detailed") as! String)!
        posterDetailImageView.setImageWithURL(urlHighResImage)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
