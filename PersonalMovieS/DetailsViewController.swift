//
//  DetailsViewController.swift
//  PersonalMovieS
//
//  Created by sivan on 16/1/14.
//  Copyright © 2016年 sivan. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var movieCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var movie: Movie?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = self.movie?.title
        movieCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.movie!.largeImageURL)!)!)
    }
}
