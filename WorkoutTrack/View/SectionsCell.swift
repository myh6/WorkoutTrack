//
//  SectionsCell.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/4/25.
//

import UIKit

private let expand = "chevron.compact.down"
private let collapse = "chevron.compact.up"

class SectionsCell: UITableViewCell {
    
    //MARK: - Properties
    var isAllFinished: Bool = false
    var isOpen: Bool = false
    var sectinoImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "dumbbell").withRenderingMode(.alwaysTemplate)
        iv.tintColor = #colorLiteral(red: 0.5996486545, green: 0.8329768777, blue: 0.8146272302, alpha: 1)
        iv.layer.cornerRadius = 10
        return iv
    }()
    var title = UILabel()
    var finishLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Futura", size: 20)
        label.text = "0"
        label.textColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        return label
    }()
    var separatorLablel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Futura", size: 20)
        label.text = "/"
        label.textColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        return label
    }()
    lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Futura", size: 20)
        label.text = "0"
        label.textColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        return label
    }()
    lazy var expandButton = isOpen ? SFSymbolButton(systemName: collapse, pointSize: 10, tintColor: #colorLiteral(red: 0.5996486545, green: 0.8329768777, blue: 0.8146272302, alpha: 1)) : SFSymbolButton(systemName: expand, pointSize: 10, tintColor: #colorLiteral(red: 0.5996486545, green: 0.8329768777, blue: 0.8146272302, alpha: 1))
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    //MARK: - Helpers
    fileprivate func configureUI() {
        addSubview(sectinoImage)
        sectinoImage.anchor(left: leftAnchor, paddingLeft: 20, width: 40, height: 40)
        sectinoImage.centerYToSuperview()
        
        addSubview(title)
        title.anchor(left: sectinoImage.rightAnchor, paddingLeft: 10, width: 200)
        title.centerYToSuperview()
        title.textColor = .black
        title.font = .init(name: "Futura", size: 20)
        title.adjustsFontSizeToFitWidth = true
        
        addSubview(expandButton)
        expandButton.anchor(right: rightAnchor, paddingRight: 5, width: 30)
        expandButton.centerYToSuperview()
        
        addSubview(totalLabel)
        totalLabel.anchor(right: expandButton.leftAnchor, paddingRight: 5)
        totalLabel.centerYToSuperview()
        addSubview(separatorLablel)
        separatorLablel.anchor(right: totalLabel.leftAnchor, paddingRight: 2)
        separatorLablel.centerYToSuperview()
        addSubview(finishLabel)
        finishLabel.anchor(left: title.rightAnchor, right: separatorLablel.leftAnchor, paddingLeft: 15, paddingRight: 2)
        finishLabel.centerYToSuperview()
        
    }
    
}
