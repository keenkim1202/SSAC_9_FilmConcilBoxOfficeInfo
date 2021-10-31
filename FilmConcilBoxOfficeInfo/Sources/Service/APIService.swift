//
//  APIService.swift
//  FilmConcilBoxOfficeInfo
//
//  Created by KEEN on 2021/10/31.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIService {
  
  static let shared = APIService()
  typealias CompletionHandler = (Int, JSON) -> ()
  
  static let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
  static let apikey = Bundle.main.apiKey
  
  func fetchMovieInfo(_ targetDate: String, result: @escaping CompletionHandler) {
    
    let params = [
      "key": Bundle.main.apiKey,
      "targetDt": targetDate
    ]
    AF.request(
      APIService.url,
      method: .get,
      parameters: params).validate(statusCode: 200...500).responseJSON { response in
      switch response.result {
      case .success(let value):
        let json = JSON(value)
        let code = response.response?.statusCode ?? 500
        result(code, json)
        
      case .failure(let error):
        print("ERROR: \(error)")
      }
    }
  }
}
