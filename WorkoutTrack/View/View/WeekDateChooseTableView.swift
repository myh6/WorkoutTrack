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

private let identifier = "weekdatechoosecell"
class WeekDateChooseTableView: UITableView {
    
    //MARK: - Properties
    private let calendar = NSCalendar.current
    private let dateFormatter = DateFormatter()
    private let date = Date()
    weak var chooseDelegate: WeekDateChoseTableViewDelegate?
    //MARK: - Lifecycle
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        separatorStyle = .none
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        allowsMultipleSelection = false
        register(ChooseCell.self, forCellReuseIdentifier: identifier)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChooseCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        switch indexPath.row {
        case 0:
            cell.title.text = getThisWeekDateToButton(i: 0)
            cell.leftImage.image = UIImage(systemName: "s.circle")?.withRenderingMode(.alwaysTemplate)
        case 1:
            cell.title.text = getThisWeekDateToButton(i: 1)
            cell.leftImage.image = UIImage(systemName: "m.circle")?.withRenderingMode(.alwaysTemplate)
        case 2:
            cell.title.text = getThisWeekDateToButton(i: 2)
            cell.leftImage.image = UIImage(systemName: "t.circle")?.withRenderingMode(.alwaysTemplate)
        case 3:
            cell.title.text = getThisWeekDateToButton(i: 3)
            cell.leftImage.image = UIImage(systemName: "w.circle")?.withRenderingMode(.alwaysTemplate)
        case 4:
            cell.title.text = getThisWeekDateToButton(i: 4)
            cell.leftImage.image = UIImage(systemName: "t.circle")?.withRenderingMode(.alwaysTemplate)
        case 5:
            cell.title.text = getThisWeekDateToButton(i: 5)
            cell.leftImage.image = UIImage(systemName: "f.circle")?.withRenderingMode(.alwaysTemplate)
        case 6:
            cell.title.text = getThisWeekDateToButton(i: 6)
            cell.leftImage.image = UIImage(systemName: "s.circle")?.withRenderingMode(.alwaysTemplate)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NewExercise.time = dateFormatter.date(from: getThisWeekDateToButton(i: indexPath.row)) ?? date
//        print("DEBUG: Choose date \(NewExercise.time?.description(with: .current))")
        chooseDelegate?.chooseDate()
    }
    
    
    
}

