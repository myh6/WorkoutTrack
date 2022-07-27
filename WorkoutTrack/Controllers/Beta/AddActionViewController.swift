//
//  AddActionViewController.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/1.
//

import UIKit

class AddActionViewController: UIViewController {
    
    //MARK: - Properties
    private let dateView = CollapsibleView(title: "DATE")
    private let bodyView = CollapsibleBodyView()
    private let exerciseView = CollapsibleExerciseView()
    private let setView = CollapsibleSetView()
    private lazy var stackView = UIStackView(arrangedSubviews: [dateView, bodyView, exerciseView, setView])

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    fileprivate func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
//        view.addSubview(stackView)
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.spacing = .zero
//        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
//                         left: view.leftAnchor,
//                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
//                         right: view.rightAnchor)
        view.addSubview(dateView)
        dateView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        left: view.leftAnchor,
                        right: view.rightAnchor)
        let constraint1 = dateView.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.height*0.15)
        constraint1.isActive = true
        constraint1.priority = UILayoutPriority(750)
        
        view.addSubview(bodyView)
        bodyView.anchor(top: dateView.bottomAnchor,
                        left: view.leftAnchor,
                        right: view.rightAnchor)
        let constraint2 = bodyView.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.height*0.15)
        constraint2.isActive = true
        constraint2.priority = UILayoutPriority(750)
        
        view.addSubview(exerciseView)
        exerciseView.anchor(top: bodyView.bottomAnchor,
                            left: view.leftAnchor,
                            right: view.rightAnchor)
        let constraint3 = exerciseView.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.height*0.15)
        constraint3.isActive = true
        constraint3.priority = UILayoutPriority(750)
        
        view.addSubview(setView)
        setView.anchor(top: exerciseView.bottomAnchor,
                       left: view.leftAnchor,
                       bottom: view.safeAreaLayoutGuide.bottomAnchor,
                       right: view.rightAnchor)
        let constraint4 = setView.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.height*0.55)
        constraint4.isActive = true
        constraint4.priority = UILayoutPriority(750)
        dateView.superViewCompletion = {
            UIView.animate(withDuration: 0.3) {
                self.dateView.layoutSubviews()
                Log.info("DEBUG: dateView")
            }
        }
        bodyView.superViewCompletion = {
            UIView.animate(withDuration: 0.3) {
                self.bodyView.layoutSubviews()
                Log.info("DEBUG: dateView")
            }
        }
        exerciseView.superViewCompletion = {
            UIView.animate(withDuration: 0.3) {
                self.exerciseView.layoutSubviews()
                Log.info("DEBUG: dateView")
            }
        }
        setView.superViewCompletion = {
            UIView.animate(withDuration: 0.3) {
                self.setView.layoutSubviews()
                Log.info("DEBUG: dateView")
            }
        }
        
    }
}
