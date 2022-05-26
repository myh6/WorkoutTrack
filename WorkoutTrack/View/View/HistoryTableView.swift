//
//  HistoryTableView.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/5.
//

import UIKit

private let identifier = "historyCell"
private let nodataID = "noDataCell"
class HistoryTableView: UITableView {
    
    //MARK: - Properties
    private let historyHeaderView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "History"
        label.font = .init(name: "Futura", size: 20)
        label.textColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        view.addSubview(label)
        label.anchor(left: view.leftAnchor, paddingLeft: 30)
        label.centerY(inView: view)
        view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        return view
    }()
    
    private var data: [HistoryModel]?
    private let dateFormmater = DateFormatter()
    var averageWeight: Float = 0
    var averageReps: Int = 0
    private var historyLabelGroup: [HistoryLabel]? = []
    private var hasHistory = false
    //MARK: - Lifcycle
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Actions
    @objc func handleExerciseChange() {
        CoredataService.shared.getHistoryDataOfSpecificExercise(NewExercise.actionName ?? "") { actions, error in
            guard error == nil else {return}
            guard let safeActions = actions else {return}
            self.data = safeActions
            self.data = self.data?.sorted(by: {$0.time > $1.time})
            if self.data?.count != 0 {
                self.hasHistory = true
            } else {
                self.hasHistory = false
            }
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    //MARK: - Helpers
    fileprivate func configureUI() {
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        separatorStyle = .none
        allowsSelection = false
        register(HistoryCell.self, forCellReuseIdentifier: identifier)
        register(NoHistoryCell.self, forCellReuseIdentifier: nodataID)
        delegate = self
        dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleExerciseChange), name: .changeExercise, object: nil)
    }
}

//MARK: - Extension: TableViewDelegate & TableViewDataSource
extension HistoryTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return historyHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasHistory {
            return data?.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.historyLabelGroup?.removeAll()
        if hasHistory {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HistoryCell
            dateFormmater.dateFormat = "yyyy/MM/dd"
            cell.dateLabel.text = data?[indexPath.row].time
            cell.setLabel.text = "Set x \(data?[indexPath.row].detail.count ?? 1)"
            
            for i in 0 ..< (data?[indexPath.row].detail.count ?? 0) {
                let label = HistoryLabel()
                label.text = "\(data?[indexPath.row].detail[i].weight ?? 0) x \(data?[indexPath.row].detail[i].reps ?? 0)"
                self.historyLabelGroup?.append(label)
            }
            let stack = UIStackView(arrangedSubviews: historyLabelGroup ?? [])
            cell.historyFrame.addSubview(stack)
            stack.distribution = .fillEqually
            stack.spacing = 1
            stack.centerY(inView: cell.historyFrame)
            stack.anchor(left: cell.historyFrame.leftAnchor,
                         right: cell.historyFrame.rightAnchor,
                         paddingLeft: 2, paddingRight: 2)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: nodataID, for: indexPath) as! NoHistoryCell
            return cell
        }
    }
    
    
}
