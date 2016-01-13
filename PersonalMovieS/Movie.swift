//
//  Movie.swift
//  PersonalMovieS
//
//  Created by sivan on 16/1/13.
//  Copyright © 2016年 sivan. All rights reserved.
//

import Foundation

struct Movie {
    let title: String
    let rating: String
    let thumbnailImageURL: String
    let largeImageURL: String
    let itemURL: String
    
    init(title: String, rating: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String) {
        self.title = title
        self.rating = rating
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
    }
    
    static func moviesWithJSON(results: NSArray) -> [Movie] {
        // Create an empty array of Movie to append to from this list
        var movies = [Movie]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            for result in results {
                
                // title
                var title = result["title"] as? String
                
                // rating
                if var ratingDictionary = result["rating"] as? NSDictionary,
                    average = ratingDictionary["average"] as? Float {
                        let rating = "\(String(average))分" ?? ""
                }
                
                // images
                if var images = result["images"] as? NSDictionary {
                    if var smallImageURL = images["small"] as? String {
                        let thumbnailImageURL = smallImageURL ?? ""
                    }
                    if var mediumImageURL = images["medium"] as? String {
                        let largeImageURL = mediumImageURL ?? ""
                    }
                }
                
                // itmeURL
                if var id = result["id"] as? String {
                    var itemURL = "http://api.douban.com/v2/movie/subject/\(id)"
                }
                
                var newMovie = Movie(title: title!, rating: rating, thumbnailImageURL: thumbnailImageURL, largeImageURL: largeImageURL, itemURL: itemURL!)
                movies.append(newMovie)
            }
        }
        return movies
    }
}