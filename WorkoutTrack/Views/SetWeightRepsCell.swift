//
//  SetWeightRepsCell.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/4.
//

import UIKit

protocol SetWeightRepsCellDelegate: AnyObject {
    func deleteCell(tag: Int)
}

class SetWeightRepsCell: UITableViewCell {
    
    //MARK: - Properties
    var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .init(name: "Futura", size: 15)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    var setTextField: UITextField = {
        let tf = UITextField()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        tf.leftView = view
        tf.leftViewMode = .always
        tf.placeholder = "Name Your Set(Optional)"
        tf.font = .init(name: "Futura", size: 15)
        tf.borderStyle = .roundedRect
        tf.adjustsFontSizeToFitWidth = true
        tf.minimumFontSize = 10
        tf.textAlignment = .left
        tf.autocorrectionType = .no
        return tf
    }()
    var weightTextField: UITextField = {
        let tf = UITextField()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        tf.leftView = view
        tf.leftViewMode = .always
        tf.placeholder = "Weight"
        tf.font = .init(name: "Futura", size: 15)
        tf.borderStyle = .roundedRect
        tf.adjustsFontSizeToFitWidth = true
        tf.minimumFontSize = 10
        tf.textAlignment = .right
        tf.keyboardType = .decimalPad
        return tf
    }()
    var repsTextField: UITextField = {
        let tf = UITextField()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        tf.rightView = view
        tf.rightViewMode = .always
        tf.placeholder = "Reps"
        tf.font = .init(name: "Futura", size: 15)
        tf.borderStyle = .roundedRect
        tf.adjustsFontSizeToFitWidth = true
        tf.minimumFontSize = 10
        tf.textAlignment = .right
        tf.keyboardType = .numberPad
        return tf
    }()
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "trash.circle")?.withTintColor( #colorLiteral(red: 0.9139711261, green: 0.6553987265, blue: 0.6171647906, alpha: 1), renderingMode: .alwaysOriginal)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        button.configuration = config
        button.addTarget(self, action: #selector(handleDeleteCell), for: .touchUpInside)
        return button
    }()
    weak var delegate: SetWeightRepsCellDelegate?
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func handleDeleteCell() {
        delegate?.deleteCell(tag: deleteButton.tag)
    }
    
    //MARK: - Helpers
    fileprivate func configureUI() {
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        addSubview(numberLabel)
        numberLabel.anchor(left: leftAnchor, paddingLeft: 10)
        numberLabel.centerY(inView: self)
        numberLabel.widthAnchor.constraint(equalToConstant: 15).isActive = true
        contentView.addSubview(deleteButton)
        deleteButton.anchor(right: rightAnchor, paddingRight: 10)
        deleteButton.centerY(inView: self)
        deleteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        let stack = UIStackView(arrangedSubviews: [weightTextField, repsTextField])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5
        contentView.addSubview(stack)
        stack.anchor(left: numberLabel.rightAnchor,
                     right: deleteButton.leftAnchor,
                     paddingLeft: 10, paddingRight: 10)
        stack.centerY(inView: self)
    }
    
    func configure(index: Int, weight: Float, reps: Int) {
        contentView.isUserInteractionEnabled = true
        setTextField.tag = index
        weightTextField.tag = index
        repsTextField.tag = index
        numberLabel.text = "\(index + 1)"
        deleteButton.tag = index
        weightTextField.text = weight == 0.0 ? .none : String(weight)
        repsTextField.text = reps == 0 ? .none : String(reps)
    }
}
