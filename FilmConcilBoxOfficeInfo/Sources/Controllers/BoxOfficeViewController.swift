//
//  BoxOfficeViewController.swift
//  FilmConcilBoxOfficeInfo
//
//  Created by KEEN on 2021/10/31.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD
import RealmSwift

// TODO: APIKEY.plist에 APIKEY를 입력해주세요.

// TODO: 20031120 이전은 검색이 안됨. 데이터가 없나? -> 없으면 에러처리할 것.

class BoxOfficeViewController: UIViewController {
  
  // MARK: - Properties
  let localRealm = try! Realm()
  let movieList = List<Movie>()
  
  var tasks: Results<MovieList>!
  var boxOfficeData: MovieList? {
    didSet {
      rankTableView.reloadData()
    }
  }
  
  let progress = JGProgressHUD()
  let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.locale = Locale(identifier: "ko-KR")
    df.dateFormat = "YYYYMMdd"
    return df
  }()
  
  // MARK: - UI
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var rankTableView: UITableView!
  @IBOutlet weak var emptyLabel: UILabel!
  
  // MARK: - View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    
    self.tasks = localRealm.objects(MovieList.self)
//    print("Realm Location: ", localRealm.configuration.fileURL)
//    print("tasks: \(tasks)")
  }
  
  // MARK: - Configure
  func configure() {
    rankTableView.delegate = self
    rankTableView.dataSource = self
    dateFormatter.locale = Locale(identifier: "ko-KR")
    
    searchTextField.setPlaceholderColor(.lightGray)
    searchTextField.layer.addBorder([.bottom], color: .white, width: 2)
  }
  
  func getTargetDate() -> String {
    guard let text = searchTextField.text else { return "" }
    
    let calendar = Calendar.current
    let yesterday = calendar.date(byAdding: .day, value: -1, to: dateFormatter.toDate(date: text)!)
    return dateFormatter.toString(date: yesterday!)
  }
  
  // MARK: - Alert
  fileprivate func showAlert(_ message: String) {
    UIAlertController.show(self, contentType: .error, message: message)
  }
  
  // MARK: - Validation
  func isTextValidationSuccess(_ text: String) -> Bool {
    if text.isEmpty { // 검색어 유무
      showAlert("검색날짜가 비어있어요!\n작성 후 시도해주세요")
      return false
    }
    
    for t in text { // 숫자로만 이루어져 있는지
      if !t.isNumber {
        showAlert("숫자가 아닌 문자가 포함되어 있습니다.\n확인후 다시 시도해주세요")
        return false
      }
    }
    
    if text.count != 8 { // 8자리 인지
      showAlert("8자리 숫자로만 검색헤주세요!\n(ex. 20020101)")
      return false
    }
    
    // 존재하지 않는 월, 일을 입력했을 경우
    let date = dateFormatter.toDate(date: text)
    if date == nil {
      showAlert("존재하지 않는 날짜입니다. 확인 후 다시 시도해주세요.")
      return false
    }
    
    // 오늘 혹은 오늘보다 이전 날짜 인지
    let today = dateFormatter.string(from: Date())
    if text > today {
      showAlert("검색 가능한 가장 최신 날짜는 오늘입니다.\n오늘 혹은 보다 이전의 날짜를 입력해주세요.")
      return false
    }
    return true
  }
  
  
  // MARK: - Fetch Data
  func isFetcehdBefore(searchDate: String) -> Bool {
    self.boxOfficeData = localRealm.object(ofType: MovieList.self, forPrimaryKey: searchDate)
    return self.boxOfficeData == nil ? false : true
  }
  
  func fetchMovieInfo() {
    let targetDate = getTargetDate()
    
    if isFetcehdBefore(searchDate: targetDate) { // fetch된 적이 있을 때
      let specificMovieList = localRealm.object(ofType: MovieList.self, forPrimaryKey: targetDate)
      self.boxOfficeData = specificMovieList
    } else { // fetch된 적이 없을 때
      APIService.shared.fetchMovieInfo(targetDate) { code, json in
        
        let dailyBoxOfficeList = json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue
        
        dailyBoxOfficeList.forEach {
          let rank = $0["rank"].intValue
          let movieName = $0["movieNm"].stringValue
          let openDate = $0["openDt"].stringValue
          
          let task = Movie(rank: rank, name: movieName, openDate: openDate)
          self.movieList.append(task)
        }
        self.boxOfficeData = MovieList(movies: self.movieList, searchDate: targetDate)
        
        try! self.localRealm.write {
          self.localRealm.add(self.boxOfficeData!)
        }
      }
    }
    emptyLabel.textColor = .clear
  }
  
  
  // MARK: - Action
  @IBAction func onSearch(_ sender: UIButton) {
    guard let text = searchTextField.text else { return }
    self.boxOfficeData = nil
    self.movieList.removeAll()
    
    if isTextValidationSuccess(text) {
      self.view.endEditing(true)
      progress.show(in: view, animated: true)
      
      fetchMovieInfo()
      self.progress.dismiss(animated: true)
      
      if let data = boxOfficeData {
        if data.movies.count == 0 {
          emptyLabel.textColor = .systemYellow
        } else {
          emptyLabel.textColor = .clear
        }
      }
    } else {
      searchTextField.text = ""
      emptyLabel.textColor = .systemYellow
      emptyLabel.text = "입력 날짜에 대한 검색 결과가 없어요 ㅠ.ㅠ"
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
    if let data = boxOfficeData {
      return data.movies.count
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print(#function)
    guard let cell = tableView.dequeueReusableCell(withIdentifier: BoxOfficeTableViewCell.identifier) as? BoxOfficeTableViewCell else { return UITableViewCell() }
    if let datas = boxOfficeData {
      let data = datas.movies[indexPath.row]
      
      cell.rankLabel.text = "\(data.rank)"
      cell.movieTitleLabel.text = data.name
      cell.releaseDateLabel.text = data.openDate
      cell.selectionStyle = .none
    }
    return cell
  }
  
}
