//
//  Movie.swift
//  BechdelTest
//
//  Created by Gabriel Ferreira on 03/09/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import Foundation

class Movie: Codable {
    var visible: Int? //Has this movie been approved (currently only approved movies are returned, so this value will always be 1).
    var date: String? //The date this movie was added to the list
    var submitterid: String? //The ID of the submitter. Since submitter information is currently not available through the API, is of no use.
    var rating: Int? //The actual score. Number from 0 to 3 (0 means no two women, 1 means no talking, 2 means talking about a man, 3 means it passes the test).
    var dubious: Int? //Whether the submitter considered the rating dubious.
    var imdbid: String? //The IMDb id.
    var id: Int? //The bechdeltest.com unique id.
    var title: String? //The title of the movie. Any weird characters are HTML encoded (so Brüno is returned as "Br&uuml;no").
    var year: Int? //The year this movie was released (according to IMDb).
    
    func getRating() -> String {
        var rating: String = "error"
        
        switch self.rating {
        case 0:
            rating = "no two women"
        case 1:
            rating = "two women, no talking"
        case 2:
            rating = "two women talking about a man"
        case 3:
            rating = "passes the test"
        default:
            rating = "error"
        }
        
        return rating
    }
}

class ListMovie: Codable {
    var list: [Movie]?
}
