//
//  ChooseExerciseTableView.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/3.
//

import UIKit


protocol ChooseExerciseTableViewDelegate: AnyObject {
    func chooseExercise(_ exercise: String)
}

class ChooseExerciseTableView: UITableView {
    
    //MARK: - Properties
    static var data: Array<String> = []
    weak var chooseDelegate: ChooseExerciseTableViewDelegate?
    //MARK: - Lifecycle
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        configureUI()
        backgroundColor = #colorLiteral(red: 0.9782040715, green: 0.9782040715, blue: 0.9782039523, alpha: 1)
        separatorStyle = .none
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    fileprivate func configureUI() {
        Moves.shared.getDBMenu { moves in
            guard moves != nil else {return}
            ChooseExerciseTableView.data = moves!.Chest
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension ChooseExerciseTableView: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChooseExerciseTableView.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        var config = cell.defaultContentConfiguration()
        config.attributedText = NSMutableAttributedString(string: (ChooseExerciseTableView.data[indexPath.row]).localizeString(string: userDefault.value(forKey: "Language") as! String), attributes: [.font: UIFont(name: "Futura", size: 20)!])
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NewExercise.actionName = translation(ChooseExerciseTableView.data[indexPath.row])!
        NotificationCenter.default.post(name: .changeExercise, object: nil)
        chooseDelegate?.chooseExercise(ChooseExerciseTableView.data[indexPath.row])
    }
    
}

extension Notification.Name {
    static let changeExercise = NSNotification.Name("changeExercise")
}
