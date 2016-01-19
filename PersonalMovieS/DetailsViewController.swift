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
        ratingTextField.textColor = UIColor.brownColor()

        // editable movie year
        yearTextField.text = self.movie?.year
        yearTextField.textColor = UIColor.brownColor()
        
        // movie summary
        api.lookupSummary(self.movie!.id)
        
        // download button
        downloadButton.setImage(UIImage(named: "download"), forState: .Normal)
        downloadButton.addTarget(self, action:Selector("tapped"), forControlEvents:.TouchUpInside)
        
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
            
            // load ip address & set up request
            let userDefault = NSUserDefaults.standardUserDefaults()
            var ipAddress = "10.48.72.48"
            if let key = userDefault.objectForKey("IPAddress") as? String {
                ipAddress = key
            }
            
            let url = NSURL(string: "http://" + ipAddress + ":8080/index.php?op=insert&keyword=" + downloadName)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                if (error != nil) {
                    let ac = UIAlertController(title: "输入 IP Address", message: "当前地址 " + ipAddress, preferredStyle: .Alert)
                    ac.addTextFieldWithConfigurationHandler(nil)
                    
                    let submitAction = UIAlertAction(title: "更新", style: .Default) { (action: UIAlertAction!) in
                        ipAddress = ac.textFields![0].text!
                        userDefault.setObject(ipAddress, forKey: "IPAddress")
                    }
                    ac.addAction(submitAction)

                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(ac, animated: true, completion: nil)
                    })

                } else {
                    
                    let alert = UIAlertController(title: "开始搜索“" + movieTitle + "”的下载资源", message: "祝你好运", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                    
                }
            })
            task.resume()
            
        }
    }
    
}
