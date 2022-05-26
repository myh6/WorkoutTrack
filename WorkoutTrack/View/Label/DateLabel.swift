//
//  DateLabel.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/4/24.
//

import UIKit

class DateLabel: UILabel {

  init(_ date: String) {
    super.init(frame: .zero)
    text = date
    textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    textAlignment = .center
    font = .init(name: "Futura", size: 10)

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
