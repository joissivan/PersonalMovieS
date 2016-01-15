//
//  ViewController.swift
//  PersonalMovieS
//
//  Created by sivan on 16/1/8.
//  Copyright © 2016年 sivan. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol, UISearchBarDelegate {

    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = [String:UIImage]()
    var api : APIController!
    var movies = [Movie]()
    
    @IBOutlet weak var appsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api = APIController(delegate: self)
        searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath)
        let movie = self.movies[indexPath.row]
        
        // Douban API
        cell.detailTextLabel?.text = movie.rating
        cell.textLabel?.text = movie.title
        
        cell.imageView?.image = UIImage(named: "Blank")
        let thumbnailURLString = movie.thumbnailImageURL
        let thumbnailURL = NSURL(string: thumbnailURLString)!
        
        // If this image is already cached, don't re-download
        if let img = imageCache[thumbnailURLString] {
            cell.imageView?.image = img
        }
        else {
            let session = NSURLSession.sharedSession()
            let request = NSURLRequest(URL: thumbnailURL)
            let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data!)
                    // Store the image in to our cache
                    self.imageCache[thumbnailURLString] = image
                    // Update the cell
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView?.image = image
                        }
                    })
                } else {
                    print("Error: \(error)")
                }
            }
            dataTask.resume()
        }
                
        return cell
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.movies = Movie.moviesWithJSON(results)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        let movie = self.movies[indexPath.row]
        
        let alert = UIAlertController(title: movie.title, message: movie.rating, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }*/

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailsViewController: DetailsViewController = segue.destinationViewController as? DetailsViewController {
            let movieIndex = appsTableView!.indexPathForSelectedRow!.row
            let selectedMovie = self.movies[movieIndex]
            detailsViewController.movie = selectedMovie
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let searchText: String = searchBar.text ?? ""
        api.searchDoubanFor(searchText)
    }
    
}

