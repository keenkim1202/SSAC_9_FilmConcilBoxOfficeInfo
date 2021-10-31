//
//  TextField++Extension.swift
//  FilmConcilBoxOfficeInfo
//
//  Created by KEEN on 2021/10/31.
//

import UIKit

public extension UITextField {
  func setPlaceholderColor(_ placeholderColor: UIColor) {
    attributedPlaceholder = NSAttributedString(
      string: placeholder ?? "",
      attributes: [
        .foregroundColor: placeholderColor,
        .font: font
      ].compactMapValues { $0 }
    )
  }
}
