//
//  CustomExerciseCell.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2022/5/31.
//

import UIKit

protocol CustomExerciseCellDelegate: AnyObject {
    func deleteCustomCell(tag: Int)
}

class CustomExerciseCell: UITableViewCell {
    
    //MARK: - Properties
    var title: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Futura", size: 20)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "trash.circle")?.withTintColor( #colorLiteral(red: 0.9139711261, green: 0.6553987265, blue: 0.6171647906, alpha: 1), renderingMode: .alwaysOriginal)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        button.configuration = config
        button.addTarget(self, action: #selector(handleDeleteCustom), for: .touchUpInside)
        return button
    }()
    weak var cellDelegate: CustomExerciseCellDelegate?
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Actions
    @objc func handleDeleteCustom() {
        cellDelegate?.deleteCustomCell(tag: deleteButton.tag)
    }
    //MARK: - Helpers
    fileprivate func configureUI() {
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        addSubview(title)
        title.anchor(left: leftAnchor, paddingLeft: 20)
        title.centerY(inView: self)
        contentView.addSubview(deleteButton)
        deleteButton.anchor(right: rightAnchor, paddingRight: 20)
        deleteButton.centerY(inView: self)
    }
    
    func configure(index: Int) {
        title.text = ChooseCustomExerciseTableView.data[index]
        title.font = UIFont.init(name: "Futura", size: 20)
        deleteButton.tag = index
    }
}
