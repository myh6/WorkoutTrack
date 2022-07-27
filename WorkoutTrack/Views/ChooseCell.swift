//
//  WeekDateChooseCell.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/3.
//

import UIKit

class ChooseCell: UITableViewCell {
    
    //MARK: - Properties
    private let calendar = NSCalendar.current
    private let date = Date()
    private let dateFormatter = DateFormatter()
    let dayImage = ["s.circle", "m.circle", "t.circle", "w.circle", "t.circle", "f.circle", "s.circle"]

    var leftImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "calendar.circle.fill")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .black
        return iv
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Futura", size: 20)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    //MARK: - Lifecylce
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    fileprivate func configureUI() {
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        addSubview(leftImage)
        leftImage.anchor(left: leftAnchor, paddingLeft: 20)
        leftImage.centerY(inView: self)
        leftImage.setDimensions(height: 30, width: 30)
        
        addSubview(titleLabel)
        titleLabel.anchor(left: leftImage.rightAnchor, paddingLeft: 20)
        titleLabel.centerY(inView: self)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        selectedBackgroundView = backgroundView
    }
    
    func getThisWeekDateToButton(i: Int) -> String {
        let thisWeek = calendar.daysWithSameWeekOfYear(as: date)
        dateFormatter.dateFormat = "yyyy/MM/dd"
        var thisWeekDate: [String] = []
        for i in 0...thisWeek.count - 1 {
            thisWeekDate.append(dateFormatter.string(from: thisWeek[i]))
        }
        return thisWeekDate[i]
    }
    
    func configure(day: Int) {
        titleLabel.text = getThisWeekDateToButton(i: day)
        leftImage.image = UIImage(systemName: dayImage[day])?.withRenderingMode(.alwaysTemplate)
    }
    
    func configureToBodyCell(with title: String, and imageName: String) {
        leftImage.image = UIImage(named: imageName) ?? #imageLiteral(resourceName: "dumbbell").withRenderingMode(.alwaysTemplate)
        leftImage.contentMode = .scaleAspectFit
        leftImage.layer.cornerRadius = 10
        titleLabel.text = title
    }
}
