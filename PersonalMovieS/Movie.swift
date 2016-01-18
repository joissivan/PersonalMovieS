//
//  Movie.swift
//  PersonalMovieS
//
//  Created by sivan on 16/1/13.
//  Copyright © 2016年 sivan. All rights reserved.
//

import Foundation

struct Movie {
    let id: String
    let title: String
    let rating: String
    let thumbnailImageURL: String
    let largeImageURL: String
    let year: String
    
    init(id: String, title: String, rating: String, thumbnailImageURL: String, largeImageURL: String, year: String) {
        self.id = id
        self.title = title
        self.rating = rating
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.year = year
    }
    
    static func moviesWithJSON(results: NSArray) -> [Movie] {
        // Create an empty array of Movie to append to from this list
        var movies = [Movie]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            for result in results {
                
                // id
                let id = result["id"] as? String ?? ""
                
                // title
                let title = result["title"] as? String ?? ""
                
                // rating
                var rating: String = ""
                if let ratingDictionary = result["rating"] as? NSDictionary,
                    let average = ratingDictionary["average"] as? Float {
                        rating = "\(String(average))分"
                }
                
                // images
                var thumbnailImageURL: String = ""
                var largeImageURL: String = ""
                if let images = result["images"] as? NSDictionary {
                    thumbnailImageURL = images["small"] as! String
                    largeImageURL = images["large"] as! String
                }
                
                // year
                let year = result["year"] as? String ?? ""

                let newMovie = Movie(id: id, title: title, rating: rating, thumbnailImageURL: thumbnailImageURL, largeImageURL: largeImageURL, year: year)
                
                movies.append(newMovie)
            }
        }
        return movies
    }
}