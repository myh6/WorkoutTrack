//
//  Chart1Cell.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/16.
//

import UIKit

class Chart1Cell: UITableViewCell {
    
    //MARK: - Properties
    var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Futura", size: 15)
        label.text = "You've done 0 set(s) of exercise in this week so far"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let customBackgrund: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
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
        backgroundColor = .clear
        addSubview(customBackgrund)
        customBackgrund.anchor(top: topAnchor, left: leftAnchor,
                          bottom: bottomAnchor,
                          right: rightAnchor,
                               paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10)
        customBackgrund.dropShadow()
        customBackgrund.addSubview(contentLabel)
        contentLabel.centerInSuperview()
        contentLabel.anchor(left: customBackgrund.leftAnchor,
                            right: customBackgrund.rightAnchor, paddingLeft: 20, paddingRight: 20)
    }
}
