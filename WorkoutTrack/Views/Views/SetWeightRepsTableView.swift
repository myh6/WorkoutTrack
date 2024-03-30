//
//  SetWeightRepsTableView.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/4.
//

import UIKit

protocol SetWeightRepsTableViewDelegate: AnyObject {
    func sendSaveDataToVC(_ output: [Detailed])
}

class SetWeightRepsTableView: UITableView {
    
    //MARK: - Properties
    private var tempStoredModel = [Detailed]()
    private var outputData = [Detailed]()
    private let setheaderView = SetWeightRepsTableHeaderView()
    weak var setDelegate: SetWeightRepsTableViewDelegate?
    //MARK: - Lifecycle
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.info("DEBUG: setWeightRepsTableView got deinit")
    }
    //MARK: - Actions
    @objc func handleSaveTextField() {
        self.resignFirstResponder()
        self.endEditing(true)
        Log.info("DEBUG: Press save and got tempStoreModel: \(tempStoredModel)")
        guard !tempStoredModel.isEmpty else {
            NotificationCenter.default.post(name: .noDataForSet, object: nil)
            return
        }
        for i in 0 ..< tempStoredModel.count {
            Log.info("DEBUG: Before saving new data: \(i):\(tempStoredModel[i])")
            guard tempStoredModel[i].reps != 0  else {
                outputData.removeAll()
                //NotificationCenter.default.post(name: .noReps, object: nil)
                NewExercise.statusCheck = false
                return
            }
            outputData.append(tempStoredModel[i])
            Log.info("DEBUG: Saving tempStoredModel to outputData \(outputData)")
        }
        NewExercise.statusCheck = true
        setDelegate?.sendSaveDataToVC(outputData)
    }
    //MARK: - Helpers
    fileprivate func configureUI() {
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        outputData = []
        NotificationCenter.default.addObserver(self, selector: #selector(handleSaveTextField), name: .saveData, object: nil)
        #warning("Time property haven't been processed")
        tempStoredModel.append(Detailed(setName: "", weight: 0, isDone: false, reps: 0, id: "", time: Date()))
        Log.info("DEBUG: viewDidLoad tempStoredModel \(tempStoredModel)")
        register(SetWeightRepsCell.self, forCellReuseIdentifier: SetWeightRepsCell.identifier)
        register(AddCell.self, forCellReuseIdentifier: AddCell.identifier)
        separatorStyle = .none
        allowsSelection = false
        delegate = self
        dataSource = self
    }
}

//MARK: - Extension: UITableViewDelegate & UITableViewDataSource
extension SetWeightRepsTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setheaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempStoredModel.count == 10 ? tempStoredModel.count : tempStoredModel.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tempStoredModel.count && tempStoredModel.count != 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddCell.identifier, for: indexPath) as! AddCell
            cell.contentView.isUserInteractionEnabled = true
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SetWeightRepsCell.identifier, for: indexPath) as! SetWeightRepsCell
            cell.delegate = self
            cell.weightTextField.delegate = self
            cell.repsTextField.delegate = self
            cell.configure(index: indexPath.row, weight: tempStoredModel[indexPath.row].weight, reps: tempStoredModel[indexPath.row].reps)
            return cell
        }
    }
    
}

//MARK: - Extension: UITextFieldDelegate
extension SetWeightRepsTableView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if NewExercise.actionName == nil {
            NotificationCenter.default.post(name: .noAction, object: nil)
        }
        if NewExercise.ofType == nil {
            NotificationCenter.default.post(name: .noType, object: nil)
        }
        if NewExercise.time == nil {
            NotificationCenter.default.post(name: .noDate, object: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let index = NSIndexPath(row: textField.tag, section: 0)
        if let cell = self.cellForRow(at: index as IndexPath) as? SetWeightRepsCell {
            guard !tempStoredModel.isEmpty else {
                #warning("Time property haven't been processed")
                tempStoredModel.append(Detailed(setName: "", weight: 0, isDone: false, reps: 0, id: "", time: Date()))
                return
            }
            if textField == cell.weightTextField {
                tempStoredModel[textField.tag].weight = Float(textField.text ?? "0") ?? 0
            } else if textField == cell.repsTextField {
                tempStoredModel[textField.tag].reps = Int(textField.text ?? "0") ?? 0
            }
            tempStoredModel[textField.tag].isDone = false
        }
    }
}

//MARK: - Extension: AddCell Delegate & SetWeightRepsCellDelegate
extension SetWeightRepsTableView: AddCellDelegate {
    func addOneCellToTable() {
        #warning("Time property haven't been processed")
        self.tempStoredModel.append(Detailed(setName: "", weight: 0, isDone: false, reps: 0, id: "", time: Date()))
        Log.info("DEBUG: add one cell \(tempStoredModel)")
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}

extension SetWeightRepsTableView: SetWeightRepsCellDelegate {
    func deleteCell(tag: Int) {
        self.resignFirstResponder()
        Log.info("DEBUG: want to delete the \(tag) cell")
        self.tempStoredModel.remove(at: tag)
        Log.info("DEBUG: delete one cell \(tempStoredModel)")
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
