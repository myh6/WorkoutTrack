//
//  NoHistoryCell.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/8.
//

import UIKit

class NoHistoryCell: UITableViewCell {
    
    //MARK: - Properties
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Futura", size: 15)
        label.text = "No History Data Yet."
        label.adjustsFontSizeToFitWidth = true
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
        backgroundColor = #colorLiteral(red: 0.9782040715, green: 0.9782040715, blue: 0.9782039523, alpha: 1)
        addSubview(noDataLabel)
        noDataLabel.anchor(left: leftAnchor, paddingLeft: 30)
        noDataLabel.centerY(inView: self)
    }
}
