//
//  WeekdayButton.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/4/24.
//

import UIKit

protocol WeekdayButtonDelegate: AnyObject {
    
    func WeekDayButtonTapped(_ sender: WeekdayButton)
}

class WeekdayButton: UIButton {
    
    //MARK: - Properties
    var haveData = false
    weak var delegate: WeekdayButtonDelegate?
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1).withAlphaComponent(0.6)
        label.font = .init(name: "Futura-Bold", size: 10)
        label.textAlignment = .center
        return label
    }()
    
    private let dateSystem = Date()
    private let calendar = NSCalendar.current
    private var dateFormatter = DateFormatter()
    private var dateFormatter2 = DateFormatter()
    //private let group = DispatchGroup()
    //MARK: - Lifecycle
    init(date: String) {
        super.init(frame: .zero)
        dateLabel.text = date
        configureUI(date)
        checkHaveData(date)
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    @objc private func handleTap() {
        delegate?.WeekDayButtonTapped(self)
    }
    
    //MARK: - Helpers
    fileprivate func configureUI(_ date: String) {
        setImage(UIImage(named: "Rectangle 124")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addSubview(dateLabel)
        dateLabel.centerXToSuperview()
        dateLabel.anchor(top: topAnchor, paddingTop: 10)
    }
    
    fileprivate func checkHaveData(_ date: String) {
        
        dateFormatter.dateFormat = "MM/dd"
        //let thisWeek = calendar.startOfWeek(for: dateSystem)
        //dateFormatter2.dateFormat = "yyyy/"
        //let inputDate = dateFormatter2.string(from: thisWeek!) + date
        //self.haveData = CoredataService.shared.checkDateHaveData(inputDate) ?? false
        if dateFormatter.string(from: dateSystem) == date {
            setImage(UIImage(named: "Rectangle 126")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            if haveData {
                setImage(UIImage(named: "rectangle+dot")?.withRenderingMode(.alwaysOriginal), for: .normal)
                dateLabel.isHidden = true
            } else {
                setImage(UIImage(named: "Rectangle 124")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
        }
    }

}
