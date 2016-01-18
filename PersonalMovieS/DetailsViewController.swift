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
    @IBOutlet weak var editableTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var summaryText: UITextView!
    @IBOutlet weak var downloadButton: UIButton!

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
        titleLabel.textColor = UIColor.brownColor()
        
        // movie cover
        movieCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.movie!.largeImageURL)!)!)
        
        // editable movie title
        editableTextField.text = self.movie?.title
        
        // editable movie rating
        ratingTextField.text = self.movie?.rating

        // editable movie year
        yearTextField.text = self.movie?.year
        
        // movie summary
        api.lookupSummary(self.movie!.id)
        
        // download button
        downloadButton.addTarget(self,action:Selector("tapped"),forControlEvents:.TouchUpInside)
        
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.review = Review.reviewWithJSON(results)
            self.summaryText.text = self.review?.summary
            self.summaryText.editable = false
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    func tapped(){
        // Now escape anything else that isn't URL-friendly
        let movieTitle = editableTextField.text!
        if let downloadName = movieTitle.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) {
            
            let url = NSURL(string: "http://10.48.72.48:8080/index.php?op=insert&keyword=" + downloadName)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url as NSURL!)
            task.resume()
            
            let alert = UIAlertController(title: "开始搜索“" + movieTitle + "”的下载资源", message: "祝你好运", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}
