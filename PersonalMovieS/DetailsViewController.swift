//
//  DetailsViewController.swift
//  PersonalMovieS
//
//  Created by sivan on 16/1/14.
//  Copyright © 2016年 sivan. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, APIControllerProtocol {
    
    @IBOutlet weak var movieCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryText: UITextView!
    @IBOutlet weak var editableTitleText: UITextView!

    
    lazy var api : APIController = APIController(delegate: self)
    
    var movie: Movie?
    var review: Review?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        titleLabel.text = self.movie?.title
        
        // movie cover
        movieCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.movie!.largeImageURL)!)!)
        
        // movie summary
        api.lookupSummary(self.movie!.id)
        
        // editable movie title
        //editableTitleText.editable = true
        
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.review = Review.reviewWithJSON(results)
            self.summaryText.text = self.review?.summary
            self.summaryText.editable = false
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
}
