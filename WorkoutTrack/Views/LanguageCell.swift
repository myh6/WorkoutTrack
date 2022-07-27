//
//  LanguageCell.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/21.
//

import UIKit

class LanguageCell: UITableViewCell {
    
    //MARK: - Properites
    var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Futura", size: 20)
        return label
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    fileprivate func configureUI() {
        addSubview(title)
        title.centerInSuperview()
    }
}
