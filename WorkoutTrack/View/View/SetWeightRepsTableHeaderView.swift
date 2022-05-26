//
//  SetWeightRepsTableHeaderView.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/4.
//

import UIKit

class SetWeightRepsTableHeaderView: UIView {
    
    //MARK: - Properties
    private let setLable: UILabel = {
        let label = UILabel()
        label.text = "Set           "
        label.font = .init(name: "Futura", size: 15)
        label.textAlignment = .left
        
        return label
    }()
    private let weightLable: UILabel = {
        let label = UILabel()
        label.text = "Weight"
        label.font = .init(name: "Futura", size: 15)
        label.textAlignment = .left
        return label
    }()
    private let repsLable: UILabel = {
        let label = UILabel()
        label.text = "Reps"
        label.font = .init(name: "Futura", size: 15)
        label.textAlignment = .left
        return label
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    fileprivate func configureUI() {
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        let view1 = UIView()
        let view2 = UIView()
        let setStack = UIStackView(arrangedSubviews: [setLable, view1, view2])
        setStack.axis = .horizontal
        setStack.distribution = .fill
        let stack = UIStackView(arrangedSubviews: [weightLable, repsLable])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        addSubview(stack)
        stack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 35, paddingRight: 35)
        stack.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stack.centerY(inView: self)
    }
}
