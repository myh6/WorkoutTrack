//
//  ChooseCustomExerciseTableView.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2022/5/28.
//

import UIKit

protocol ChooseCustomExerciseTableViewDelegate: AnyObject {
    func chooseCustomExercise(exercise: String)
    func showDeleteCustomAlert(exercise: String)
}
private let identifier = "tableView"
class ChooseCustomExerciseTableView: UITableView {
    
    //MARK: - Properties
    static var data: Array<String> = []
    weak var chooseCustomDelegate: ChooseCustomExerciseTableViewDelegate?
    //MARK: - Lifecycle
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(CustomExerciseCell.self, forCellReuseIdentifier: identifier)
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
        guard NewExercise.ofType != nil else {
            NotificationCenter.default.post(name: .noType, object: nil)
            return
        }
        CoredataService.shared.getCustomActionFromCoredata(ofType: NewExercise.ofType!) { output, error in
            ChooseCustomExerciseTableView.data = output ?? []
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
}
//MARK: - Extension: UITableViewDelegate, UITableViewDataSourcew
extension ChooseCustomExerciseTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChooseCustomExerciseTableView.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CustomExerciseCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        cell.title.text = ChooseCustomExerciseTableView.data[indexPath.row]
        cell.title.font = UIFont.init(name: "Futura", size: 20)
        cell.deleteButton.tag = indexPath.row
        cell.cellDelegate = self
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            NewExercise.actionName = ChooseCustomExerciseTableView.data[indexPath.row]
            NotificationCenter.default.post(name: .changeExercise, object: nil)
            chooseCustomDelegate?.chooseCustomExercise(exercise: ChooseCustomExerciseTableView.data[indexPath.row])
    }
    
}

extension ChooseCustomExerciseTableView: CustomExerciseCellDelegate {
    func deleteCustomCell(tag: Int) {
        chooseCustomDelegate?.showDeleteCustomAlert(exercise: ChooseCustomExerciseTableView.data[tag])
    }
    
}
