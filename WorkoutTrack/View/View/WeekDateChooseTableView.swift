//
//  WeekDateChooseCell.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/3.
//

import UIKit

protocol WeekDateChoseTableViewDelegate: AnyObject {
    func chooseDate()
}

class WeekDateChooseTableView: UITableView {
    
    //MARK: - Properties
    private let calendar = NSCalendar.current
    private let date = Date()
    private let dateFormatter = DateFormatter()
    weak var chooseDelegate: WeekDateChoseTableViewDelegate?
    //MARK: - Lifecycle
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        separatorStyle = .none
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        allowsMultipleSelection = false
        register(ChooseCell.self, forCellReuseIdentifier: ChooseCell.identifier)
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func getThisWeekDateToButton(i: Int) -> String {
        let thisWeek = calendar.daysWithSameWeekOfYear(as: date)
        dateFormatter.dateFormat = "yyyy/MM/dd"
        var thisWeekDate: [String] = []
        for i in 0...thisWeek.count - 1 {
            thisWeekDate.append(dateFormatter.string(from: thisWeek[i]))
        }
        return thisWeekDate[i]
    }
    
}

//MARK: - Extension
extension WeekDateChooseTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChooseCell.identifier, for: indexPath) as! ChooseCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        cell.configure(day: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NewExercise.time = dateFormatter.date(from: getThisWeekDateToButton(i: indexPath.row)) ?? date
//        print("DEBUG: Choose date \(NewExercise.time?.description(with: .current))")
        chooseDelegate?.chooseDate()
    }
    
}

extension ChooseCell {
    func configure(day: Int) {
        title.text = getThisWeekDateToButton(i: day)
        leftImage.image = UIImage(systemName: dayImage[day])?.withRenderingMode(.alwaysTemplate)
    }
}

