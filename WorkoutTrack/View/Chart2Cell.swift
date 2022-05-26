//
//  Chart2Cell.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/16.
//

import UIKit

class Chart2Cell: UITableViewCell {
    
    //MARK: - Properties
    private let customBackgrund: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    private let maxWeightLabel: UILabel = {
        let label = UILabel()
        label.text = "Max Weight"
        label.font = UIFont.init(name: "Futura-Bold", size: 10)
        return label
    }()
    private let maxRepsLabel: UILabel = {
        let label = UILabel()
        label.text = "Max Reps"
        label.font = UIFont.init(name: "Futura-Bold", size: 10)
        return label
    }()
    var maxWeightNumber: UILabel = {
        let label = UILabel()
        label.text = "85kg"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont.init(name: "Futura-Bold", size: 40)
        return label
    }()
    var maxRepsNumber: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.init(name: "Futura-Bold", size: 40)
        return label
    }()
    var weigthHistoryLabel: UILabel = {
        let label = UILabel()
        label.text = "History 2022/05/16\n 85kgx3"
        label.textAlignment = .center
        label.font = UIFont.init(name: "Futura", size: 10)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.6317751408, green: 0.6491668224, blue: 0.6322310567, alpha: 1)
        return label
    }()
    var repsHistoryLabel: UILabel = {
        let label = UILabel()
        label.text = "History 2022/05/16\n 50kgx20"
        label.textAlignment = .center
        label.font = UIFont.init(name: "Futura", size: 10)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.6317751408, green: 0.6491668224, blue: 0.6322310567, alpha: 1)
        return label
    }()
    private let separatorLineImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "Line 15")
        return iv
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
        customBackgrund.addSubview(separatorLineImageView)
        separatorLineImageView.centerXToSuperview()
        separatorLineImageView.setDimensions(height: 110, width: 10)
        separatorLineImageView.anchor(top: customBackgrund.topAnchor,
                                      bottom: customBackgrund.bottomAnchor,
                                      paddingTop: 10, paddingBottom: 10)
        customBackgrund.addSubview(maxWeightLabel)
        maxWeightLabel.anchor(top: customBackgrund.topAnchor,
                              left: customBackgrund.leftAnchor,
                              right: separatorLineImageView.leftAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        customBackgrund.addSubview(maxWeightNumber)
        maxWeightNumber.anchor(top: maxWeightLabel.bottomAnchor,
                               left: customBackgrund.leftAnchor,
                               right: separatorLineImageView.leftAnchor,
                               paddingTop: 20, paddingLeft: 15, paddingRight: 15)
        customBackgrund.addSubview(weigthHistoryLabel)
        weigthHistoryLabel.anchor(top: maxWeightNumber.bottomAnchor,
                                  left: customBackgrund.leftAnchor,
                                  bottom: customBackgrund.bottomAnchor,
                                  right: separatorLineImageView.leftAnchor,
                                  paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20)
        
        customBackgrund.addSubview(maxRepsLabel)
        maxRepsLabel.anchor(top: customBackgrund.topAnchor,
                            left: separatorLineImageView.rightAnchor,
                            right: customBackgrund.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        customBackgrund.addSubview(maxRepsNumber)
        maxRepsNumber.anchor(top: maxRepsLabel.bottomAnchor,
                             left: separatorLineImageView.rightAnchor,
                             right: customBackgrund.rightAnchor,
                             paddingTop: 20, paddingLeft: 15, paddingRight: 15)
        customBackgrund.addSubview(repsHistoryLabel)
        repsHistoryLabel.anchor(top: maxRepsNumber.bottomAnchor,
                                left: separatorLineImageView.rightAnchor,
                                bottom: customBackgrund.bottomAnchor,
                                right: customBackgrund.rightAnchor,
                                paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20)
        
    }
}
