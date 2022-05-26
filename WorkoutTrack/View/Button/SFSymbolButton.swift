//
//  SFSymbolButton.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/4/23.
//

import UIKit

class SFSymbolButton: UIButton {

  //MARK: - Lifecycle
  init(systemName: String, pointSize: CGFloat, tintColor: UIColor) {
    super.init(frame: .zero)
    var config = UIButton.Configuration.plain()
    config.image = UIImage(systemName: systemName)?.withRenderingMode(.alwaysTemplate)
    config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .bold)
    configuration = config
    self.tintColor = tintColor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
