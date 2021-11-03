//
//  Movie.swift
//  FilmConcilBoxOfficeInfo
//
//  Created by KEEN on 2021/10/31.
//

import Foundation
import RealmSwift

class Movie: Object {
  @Persisted var rank: Int
  @Persisted var name: String
  @Persisted var openDate: String

  convenience init(rank: Int, name: String, openDate: String) {
    self.init()
    
    self.rank = rank
    self.name = name
    self.openDate = openDate
  }
}

class MovieList: Object {
  @Persisted var movies: List<Movie>
  
  @Persisted(primaryKey: true) var searchDate: String
  
  convenience init(movies: List<Movie>, searchDate: String) {
    self.init()
    
    self.movies = movies
    self.searchDate = searchDate
  }
}
