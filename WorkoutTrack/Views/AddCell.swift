//
//  AddCell.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/4.
//

import UIKit

protocol AddCellDelegate: AnyObject {
    
    func addOneCellToTable()
}

class AddCell: UITableViewCell {
    
    //MARK: - Properties
    private lazy var addButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var text = AttributedString(" Add Set")
        text.font = UIFont(name: "Futura", size: 20)
        text.foregroundColor = #colorLiteral(red: 0.9139711261, green: 0.6553987265, blue: 0.6171647906, alpha: 1)
        config.attributedTitle = text
        config.image = UIImage(systemName: "plus.circle")?.withTintColor( #colorLiteral(red: 0.9139711261, green: 0.6553987265, blue: 0.6171647906, alpha: 1), renderingMode: .alwaysOriginal)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        button.configuration = config
        button.addTarget(self, action: #selector(handleAddCell), for: .touchUpInside)
        return button
    }()
    weak var delegate: AddCellDelegate?
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func handleAddCell() {
        delegate?.addOneCellToTable()
    }
    //MARK: - Helpers
    fileprivate func configureUI() {
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        contentView.addSubview(addButton)
        addButton.anchor(right: rightAnchor, paddingRight: 10)
        addButton.centerY(inView: self)
    }
}
