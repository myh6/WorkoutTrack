//
//  DateCollapsibleView.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/1.
//

import UIKit

/**Not Using For Now**/
class CollapsibleView: UIView {
    
    //MARK: - Properites
    private var firstView = UIView()
    private var secondView = UIView()
    
    private var lineGraph: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "Line 5")
        return iv
    }()
    private var whiteLineGraph: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "collapsible")
        return iv
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Futura-Bold", size: 60)
        label.text = "DATE"
        label.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.6)
        return label
    }()
    private lazy var showButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "SHOW"
        button.titleLabel?.textColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        button.addTarget(self, action: #selector(handleShow), for: .touchUpInside)
        return button
    }()
    private var titleInSection: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Futura-Bold", size: 20)
        label.text = "DATE"
        label.textColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        return label
    }()
    private lazy var firstHeightConstraint = firstView.heightAnchor.constraint(equalToConstant: (superview?.frame.height ?? 500)*0.15)
    private lazy var secondHeightConstraint = secondView.heightAnchor.constraint(equalToConstant: 0)

    private var shouldCollapse = false
    var superViewCompletion: (() -> Void)?
    //MARK: - Lifecycle
    init(title: String) {
        super.init(frame: .zero)
        titleInSection.text = title
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func handleShow() {
        if shouldCollapse {
            animateView(isCollapse: false,
                        heightConstraint: (superview?.frame.height ?? 500)*0.15,
                        heightForSection: 0)
        } else {
            animateView(isCollapse: true,
                        heightConstraint: 0,
                        heightForSection: (superview?.frame.height ?? 500)*0.15)
        }
    }
    
    //MARK: - Helpers
    fileprivate func configureUI() {
        addSubview(firstView)
        firstView.backgroundColor = .white
        firstView.anchor(top: topAnchor, left: leftAnchor,right: rightAnchor)
        let firstViewConstraint = firstView.bottomAnchor.constraint(equalTo: bottomAnchor)
        firstViewConstraint.priority = UILayoutPriority(750)
        firstViewConstraint.isActive = true
        firstHeightConstraint.isActive = true
        
        firstView.addSubview(lineGraph)
        lineGraph.anchor(top: firstView.topAnchor,
                         left: firstView.leftAnchor,
                         bottom: firstView.bottomAnchor, paddingTop: 40, paddingLeft: 50)
        firstView.addSubview(showButton)
        showButton.anchor(right: firstView.rightAnchor)
        showButton.centerY(inView: firstView)
        showButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        firstView.addSubview(titleInSection)
        titleInSection.anchor(top: firstView.topAnchor, bottom: firstView.bottomAnchor, right: showButton.leftAnchor, paddingTop: 20, paddingBottom: 20, paddingRight: 10)
        firstView.dropShadow()
        
        addSubview(secondView)
        secondView.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        secondView.anchor(top: firstView.bottomAnchor, left: leftAnchor, right: rightAnchor)
        let constraint = secondView.bottomAnchor.constraint(equalTo: bottomAnchor)
        constraint.priority = UILayoutPriority(750)
        constraint.isActive = true
        secondHeightConstraint.isActive = true
        secondView.addSubview(whiteLineGraph)
        whiteLineGraph.anchor(top: secondView.topAnchor,
                              left: secondView.leftAnchor,
                              bottom: secondView.bottomAnchor, paddingLeft: 50)
        whiteLineGraph.widthAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    private func animateView(isCollapse: Bool,
                             heightConstraint: Double,
                             heightForSection: Double) {

        UIView.animate(withDuration: 0.3) {
            self.shouldCollapse = isCollapse
            self.firstHeightConstraint.constant = heightForSection
            self.secondHeightConstraint.constant = heightConstraint
            self.layoutIfNeeded()
            self.superViewCompletion?()
        }
    }
    
}
