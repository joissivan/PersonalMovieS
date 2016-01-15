//
//  Review.swift
//  PersonalMovieS
//
//  Created by sivan on 16/1/15.
//  Copyright © 2016年 sivan. All rights reserved.
//

import Foundation

struct Review {
    
    let summary: String
    
    init(summary: String) {
        self.summary = summary
    }
    
    static func reviewWithJSON(results: NSArray) -> Review {
        
        var review = Review(summary: "没有简介")
        
        if results.count>0 {
            
            for result in results {


                // summary
                let summary = result["summary"] as? String ?? ""
        
        
                // Review
                review = Review(summary: summary)
    
        
                
                return review
                
            }
            
            
        }
        
        return review
    }


}