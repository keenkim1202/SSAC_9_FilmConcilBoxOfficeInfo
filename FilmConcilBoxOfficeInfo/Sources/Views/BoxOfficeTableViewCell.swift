//
//  BoxOfficeTableViewCell.swift
//  FilmConcilBoxOfficeInfo
//
//  Created by KEEN on 2021/10/31.
//

import UIKit

class BoxOfficeTableViewCell: UITableViewCell {
  
  static let identifier = "boxOfficeCell"
  
  @IBOutlet weak var rankLabel: UILabel!
  @IBOutlet weak var movieTitleLabel: UILabel!
  @IBOutlet weak var releaseDateLabel: UILabel!
  
}
