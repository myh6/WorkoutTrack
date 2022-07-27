//
//  WeekProgressView.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/4/24.
//

import UIKit

protocol WeekProgressViewDelegate: AnyObject {
    func sendDataToViewController(date: String, actions: [AddActionModel]?)
}

class WeekProgressView: UIView {
    
    //MARK: - Properites
    weak var delegate: WeekProgressViewDelegate?
    private let date = Date()
    private let calendar = NSCalendar.current
    private let dateFormatter = DateFormatter()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "THIS WEEK"
        label.textColor = #colorLiteral(red: 0.5647058824, green: 0.5843137255, blue: 0.5647058824, alpha: 1)
        label.font = .init(name: "Futura-Bold", size: 20)
        return label
    }()
    
    lazy var sunday = WeekdayButton(date: getThisWeekDateToButton(i: 0))
    lazy var monday = WeekdayButton(date: getThisWeekDateToButton(i: 1))
    lazy var tuesday = WeekdayButton(date: getThisWeekDateToButton(i: 2))
    lazy var wednesday = WeekdayButton(date: getThisWeekDateToButton(i: 3))
    lazy var thursday = WeekdayButton(date: getThisWeekDateToButton(i: 4))
    lazy var friday = WeekdayButton(date: getThisWeekDateToButton(i: 5))
    lazy var saturday = WeekdayButton(date: getThisWeekDateToButton(i: 6))
    
    private let sundayLable = DateLabel("S")
    private let mondayLable = DateLabel("M")
    private let tuesdayLable = DateLabel("T")
    private let wednesdayLable = DateLabel("W")
    private let thursdayLable = DateLabel("T")
    private let fridayLable = DateLabel("F")
    private let saturdayLable = DateLabel("S")
    
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
        
        addSubview(label)
        label.anchor(top: topAnchor, left: leftAnchor, paddingLeft: 20)
        let sundayStack = UIStackView(arrangedSubviews: [sundayLable, sunday])
        sunday.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sundayStack.axis = .vertical
        sundayStack.distribution = .fill
        sunday.delegate = self
        let mondayStack = UIStackView(arrangedSubviews: [mondayLable, monday])
        monday.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mondayStack.axis = .vertical
        mondayStack.distribution = .fill
        monday.delegate = self
        let tuesdayStack = UIStackView(arrangedSubviews: [tuesdayLable, tuesday])
        tuesday.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tuesdayStack.axis = .vertical
        tuesdayStack.distribution = .fill
        tuesday.delegate = self
        let wednesdayStack = UIStackView(arrangedSubviews: [wednesdayLable, wednesday])
        wednesday.heightAnchor.constraint(equalToConstant: 50).isActive = true
        wednesdayStack.axis = .vertical
        wednesdayStack.distribution = .fill
        wednesday.delegate = self
        let thursdayStack = UIStackView(arrangedSubviews: [thursdayLable, thursday])
        thursday.heightAnchor.constraint(equalToConstant: 50).isActive = true
        thursdayStack.axis = .vertical
        thursdayStack.distribution = .fill
        thursday.delegate = self
        let fridayStack = UIStackView(arrangedSubviews: [fridayLable, friday])
        friday.heightAnchor.constraint(equalToConstant: 50).isActive = true
        fridayStack.axis = .vertical
        fridayStack.distribution = .fill
        friday.delegate = self
        let saturdayStack = UIStackView(arrangedSubviews: [saturdayLable, saturday])
        saturday.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saturdayStack.axis = .vertical
        saturdayStack.distribution = .fill
        saturday.delegate = self
        let stack = UIStackView(arrangedSubviews: [sundayStack, mondayStack, tuesdayStack, wednesdayStack, thursdayStack, fridayStack, saturdayStack])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.anchor(top: label.bottomAnchor,
                     left: leftAnchor,
                     bottom: bottomAnchor,
                     right: rightAnchor, paddingLeft: 5, paddingRight: 5)
        
        
    }
    
    private func getThisWeekDateToButton(i: Int) -> String {
        let thisWeek = calendar.daysWithSameWeekOfYear(as: date)
        dateFormatter.dateFormat = "MM/dd"
        var thisWeekDate: [String] = []
        for i in 0...thisWeek.count - 1 {
            thisWeekDate.append(dateFormatter.string(from: thisWeek[i]))
        }
        return thisWeekDate[i]
    }
    
    
}

//MARK: - Extension: WeekDayButton
extension WeekProgressView: WeekdayButtonDelegate {
    func WeekDayButtonTapped(_ sender: WeekdayButton) {
        let thisWeek = calendar.startOfWeek(for: date)
        dateFormatter.dateFormat = "yyyy/"
        Log.info("DEBUG: WeekDayButtonTapped: \(dateFormatter.string(from: thisWeek!) + sender.dateLabel.text!)")
        CoredataService.shared.getDataInSpecificDateFromCoredata(date: dateFormatter.string(from: thisWeek!) + sender.dateLabel.text!) { actions, error in
            guard error == nil else { return }
            self.delegate?.sendDataToViewController(date: self.dateFormatter.string(from: thisWeek!) + sender.dateLabel.text!, actions: actions)
        }
    }
}
