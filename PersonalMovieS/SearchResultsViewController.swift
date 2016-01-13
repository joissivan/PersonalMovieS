//
//  ViewController.swift
//  PersonalMovieS
//
//  Created by sivan on 16/1/8.
//  Copyright © 2016年 sivan. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {

    var tableData = []
    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = [String:UIImage]()
    var api : APIController!
    
    @IBOutlet weak var appsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api = APIController(delegate: self)
        api.searchDoubanFor("007")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath)
        
        // Douban API
        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
            images = rowData["images"] as? NSDictionary,
            urlString = images["small"] as? String,
            imgURL = NSURL(string: urlString),

            rating = rowData["rating"] as? NSDictionary,
            formattedRating = rating["average"] as? Float,
        

            trackName = rowData["title"] as? String {
                
                cell.detailTextLabel?.text = String(formattedRating)
                cell.textLabel?.text = trackName
                
                //cell.imageView?.image = UIImage(data: imgData)
                cell.imageView?.image = UIImage(named: "Blank")
                
                // If this image is already cached, don't re-download
                if let img = imageCache[urlString] {
                    cell.imageView?.image = img
                }
                else {
                    let session = NSURLSession.sharedSession()
                    let request = NSURLRequest(URL: imgURL)
                    let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                        if error == nil {
                            // Convert the downloaded data in to a UIImage object
                            let image = UIImage(data: data!)
                            // Store the image in to our cache
                            self.imageCache[urlString] = image
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
                
        }
        return cell
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = results
            self.appsTableView!.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        if let rowData = self.tableData[indexPath.row] as? NSDictionary,
            
            name = rowData["title"] as? String,
            
            year = rowData["year"] as? String {
            
                let alert = UIAlertController(title: name, message: year + "年", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}

