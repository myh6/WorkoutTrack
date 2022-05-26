//
//  HistoryLabel.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/9.
//

import UIKit

class HistoryLabel: UILabel {
    
    //MARK: - Properties
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    fileprivate func configureUI() {
        textAlignment = .center
        font = .init(name: "Futura", size: 10)
        layer.cornerRadius = 3
        adjustsFontSizeToFitWidth = true
    }
}
