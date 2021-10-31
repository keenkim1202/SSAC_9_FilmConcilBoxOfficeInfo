//
//  BoxOfficeViewController.swift
//  FilmConcilBoxOfficeInfo
//
//  Created by KEEN on 2021/10/31.
//

import UIKit
import Alamofire
import SwiftyJSON

class BoxOfficeViewController: UIViewController {

  // MARK: Properties
  var rank = 1 // test
  var boxOfficeData: [String] = []
  let apiService = APIService()
  
  // MARK: UI
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var rankTableView: UITableView!
  @IBOutlet weak var emptyLabel: UILabel!
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    apiService.fetchMovieInfo("20211030")
  }
  
  // MARK: Configure
  func configure() {
    rankTableView.delegate = self
    rankTableView.dataSource = self
    searchTextField.setPlaceholderColor(.lightGray)
    searchTextField.layer.addBorder([.bottom], color: .white, width: 2)
  }

  // MARK: Action
  @IBAction func onSearch(_ sender: UIButton) {
    if !boxOfficeData.isEmpty {
      emptyLabel.textColor = .clear
    } else {
      emptyLabel.textColor = .systemYellow
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
    cell.rankLabel.text = "\(rank)"
    rank += 1 // test
    return cell
  }
}
