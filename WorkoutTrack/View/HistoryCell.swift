//
//  HistoryCell.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/3.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    //MARK: - Properties
    private let backgroundFrame: UIView = {
        let bgview = UIView()
        bgview.layer.cornerRadius = 10
        bgview.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1).withAlphaComponent(0.6)
        return bgview
    }()
    private let calendarIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "calendar.circle")!.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .black
        return iv
    }()
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Futura", size: 15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    var setLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Futura", size: 15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    var historyFrame: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1).withAlphaComponent(0)
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
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        addSubview(backgroundFrame)
        backgroundFrame.anchor(top: topAnchor,
                               left: leftAnchor,
                               right: rightAnchor,
                               paddingTop: 5, paddingLeft: 10, paddingRight: 10)
        backgroundFrame.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addSubview(historyFrame)
        historyFrame.anchor(top: backgroundFrame.bottomAnchor,
                            left: leftAnchor,
                            bottom: bottomAnchor,
                            right: rightAnchor,
                            paddingLeft: 10, paddingBottom: 5, paddingRight: 10)
        
        backgroundFrame.addSubview(calendarIcon)
        calendarIcon.anchor(left: backgroundFrame.leftAnchor,
                            paddingLeft: 10)
        calendarIcon.centerY(inView: backgroundFrame)
        calendarIcon.setDimensions(height: 30, width: 30)
        
        backgroundFrame.addSubview(dateLabel)
        dateLabel.anchor(left: calendarIcon.rightAnchor,
                         paddingLeft: 10)
        dateLabel.centerY(inView: backgroundFrame)
        
        backgroundFrame.addSubview(setLabel)
        setLabel.centerY(inView: backgroundFrame)
        setLabel.anchor(right: backgroundFrame.rightAnchor,
                        paddingRight: 10)
    }
}
