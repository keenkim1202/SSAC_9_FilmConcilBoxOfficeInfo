//
//  BoxOfficeViewController.swift
//  FilmConcilBoxOfficeInfo
//
//  Created by KEEN on 2021/10/31.
//

import UIKit
import Alamofire
import SwiftyJSON

// TODO: APIKEY.plist에 APIKEY를 입력해주세요.

class BoxOfficeViewController: UIViewController {
  
  // MARK: Properties
  var boxOfficeData: [Movie] = [] {
    didSet {
      if !boxOfficeData.isEmpty {
        emptyLabel.textColor = .clear
      } else {
        emptyLabel.textColor = .systemYellow
      }
      rankTableView.reloadData()
    }
  }
  
  let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.locale = Locale(identifier: "ko-KR")
    df.dateFormat = "YYYYMMdd"
    
    return df
  }()
  
  // MARK: UI
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var rankTableView: UITableView!
  @IBOutlet weak var emptyLabel: UILabel!
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  // MARK: Configure
  func configure() {
    rankTableView.delegate = self
    rankTableView.dataSource = self
    dateFormatter.locale = Locale(identifier: "ko-KR")
    
    searchTextField.setPlaceholderColor(.lightGray)
    searchTextField.layer.addBorder([.bottom], color: .white, width: 2)
  }
  
  // MARK: Alert
  fileprivate func showAlert(_ message: String) {
    UIAlertController.show(self, contentType: .error, message: message)
  }
  
  func isTextValidationSuccess(_ text: String) -> Bool {
    if text.isEmpty { // 검색어 유무
      showAlert("검색날짜가 비어있어요!\n작성 후 시도해주세요")
      return false
    }
    
    if text.count != 8 { // 8자리 인지
      showAlert("8자리 숫자로만 검색헤주세요!\n(ex. 20020101)")
      return false
    }
    
    for t in text { // 숫자로만 이루어져 있는지
      if !t.isNumber {
        showAlert("숫자가 아닌 문자가 포함되어 있습니다.\n확인후 다시 시도해주세요")
        return false
      }
    }
    
    let today = dateFormatter.string(from: Date())
    if text > today { // 오늘 혹은 오늘보다 이전 날짜 인지
      showAlert("검색 가능한 가장 최신 날짜는 오늘입니다.\n오늘 혹은 보다 이전의 날짜를 입력해주세요.")
      return false
    }
    return true
  }
  
  // MARK: Action
  @IBAction func onSearch(_ sender: UIButton) {
    boxOfficeData = []
    guard let text = searchTextField.text else { return }
    
    if isTextValidationSuccess(text) {
      let calendar = Calendar.current
      let yesterday = calendar.date(byAdding: .day, value: -1, to: dateFormatter.toDate(date: text))
      let targetDate = dateFormatter.toString(date: yesterday!)
    
      APIService.shared.fetchMovieInfo(targetDate) { code, json in
        
        let dailyBoxOfficeList = json["boxOfficeResult"]["dailyBoxOfficeList"]
        
        dailyBoxOfficeList.map {
          let rank = $0.1["rank"].intValue
          let movieName = $0.1["movieNm"].stringValue
          let openDate = $0.1["openDt"].stringValue
          self.boxOfficeData.append(Movie(rank: rank, name: movieName, openDate: openDate))
        }
      }
      boxOfficeData.sort{ $0.rank < $1.rank }
    }
  }
}

// MARK: Extension - TableView Delegate & DataSource
extension BoxOfficeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}

extension BoxOfficeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return boxOfficeData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: BoxOfficeTableViewCell.identifier) as? BoxOfficeTableViewCell else { return UITableViewCell() }
    let data = boxOfficeData[indexPath.row]
    cell.rankLabel.text = "\(data.rank)"
    cell.movieTitleLabel.text = data.name
    cell.releaseDateLabel.text = data.openDate
    return cell
  }
}
