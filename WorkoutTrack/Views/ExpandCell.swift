//
//  ExpandCell.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/4/25.
//

import UIKit

public let checkMark = "checkmark.square.fill"
public let uncheck = "square"

class ExpandCell: UITableViewCell {
    
    //MARK: - Properties
    var title = UILabel()
    var textField = UITextField(backgroundColor: .clear)
    lazy var checkButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: uncheck)?.withRenderingMode(.alwaysTemplate)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        button.configuration = config
        button.tintColor = .white
        return button
    }()
    var repsLable = UILabel()
    private let blankView = UIView()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.5996486545, green: 0.8329768777, blue: 0.8146272302, alpha: 1).withAlphaComponent(0.6)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    //MARK: - Helpers
    fileprivate func configureUI() {
        
        addSubview(repsLable)
        repsLable.anchor(right: rightAnchor, paddingRight: 10)
        repsLable.centerYToSuperview()
        repsLable.textColor = .white
        repsLable.font = .init(name: "Futura", size: 20)
        
        addSubview(textField)
        textField.anchor(right: repsLable.leftAnchor, paddingRight: 10)
        textField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textField.leftView = blankView
        blankView.setDimensions(height: 30, width: 10)
        textField.leftViewMode = .always
        textField.textColor = .white
        textField.font = .init(name: "Futura", size: 20)
        textField.centerYToSuperview()
        
        addSubview(title)
        title.anchor(right: textField.leftAnchor, paddingRight: 10)
        title.centerYToSuperview()
        title.textColor = .white
        title.font = .init(name: "Futura", size: 20)
        
        addSubview(checkButton)
        checkButton.anchor(left: leftAnchor, paddingLeft: 10)
        checkButton.centerYToSuperview()
        //    checkButton.addTarget(self, action: #selector(handleCheckButton), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.checkButton.configuration?.image = UIImage(systemName: uncheck)?.withRenderingMode(.alwaysTemplate)
    }
    
    func configure(model: Detailed) {
        title.text = model.setName
        checkButton.configuration?.image = model.isDone ? UIImage(systemName: checkMark)?.withRenderingMode(.alwaysTemplate) : UIImage(systemName: uncheck)?.withRenderingMode(.alwaysTemplate)
        textField.text = String(model.weight) + " kg"
        repsLable.text = "x" + String(model.reps)
    }
    
    func configureForMontlyView(with model: Detailed) {
        backgroundColor = #colorLiteral(red: 0.9139711261, green: 0.6553987265, blue: 0.6171647906, alpha: 0.8470588235)
        title.text = model.setName
        checkButton.isHidden = true
        textField.text = String(model.weight) + " kg"
        repsLable.text = "x" + String(model.reps)
    }
}
