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
    let artistURL: String
    
    init(name: String, rating: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String, artistURL: String) {
        self.title = name
        self.rating = rating
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
    }
    
    static func moviesWithJSON(results: NSArray) -> [Movie] {
        // Create an empty array of Movie to append to from this list
        var movies = [Movie]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            for result in results {
                
                var name = result["title"] as? String
                
                if let ratingDictionary = result["rating"] as? NSDictionary,
                    average = ratingDictionary["average"] as? Float {
                        var rating = "$\(String(average))分"
                }
                
                let thumbnailURL = result["artworkUrl60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String
                }
                
                var newMovie = Movie(name: name!, rating: price!, thumbnailImageURL: thumbnailURL, largeImageURL: imageURL, itemURL: itemURL!, artistURL: artistURL)
                movies.append(newMovie)
            }
        }
        return movies
    }
}