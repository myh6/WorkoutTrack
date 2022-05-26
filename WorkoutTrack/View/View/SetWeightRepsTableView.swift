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

private let identifier = "setWeightRepsCell"
private let identifier2 = "addNewCell"

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
        print("DEBUG: setWeightRepsTableView got deinit")
    }
    //MARK: - Actions
    @objc func handleSaveTextField() {
        self.resignFirstResponder()
        self.endEditing(true)
        print("DEBUG: Press save and got tempStoreModel: \(tempStoredModel)")
        guard !tempStoredModel.isEmpty else {
            NotificationCenter.default.post(name: .noDataForSet, object: nil)
            return
        }
        for i in 0 ..< tempStoredModel.count {
            print("DEBUG: Before saving new data: \(i):\(tempStoredModel[i])")
            guard tempStoredModel[i].reps != 0  else {
                outputData.removeAll()
                tempStoredModel.removeAll()
                NotificationCenter.default.post(name: .noReps, object: nil)
                return
            }
            outputData.append(tempStoredModel[i])
            print("DEBUG: Saving tempStoredModel to outputData \(outputData)")
        }
        setDelegate?.sendSaveDataToVC(outputData)
    }
    //MARK: - Helpers
    fileprivate func configureUI() {
        backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        outputData = []
        NotificationCenter.default.addObserver(self, selector: #selector(handleSaveTextField), name: .saveData, object: nil)
        tempStoredModel.append(Detailed(setName: "", weight: 0, isDone: false, reps: 0, id: ""))
        print("DEBUG: viewDidLoad tempStoredModel \(tempStoredModel)")
        register(SetWeightRepsCell.self, forCellReuseIdentifier: identifier)
        register(AddCell.self, forCellReuseIdentifier: identifier2)
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
        if tempStoredModel.count == 10 {
            return tempStoredModel.count
        } else {
            return tempStoredModel.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tempStoredModel.count && tempStoredModel.count != 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier2, for: indexPath) as! AddCell
            cell.contentView.isUserInteractionEnabled = true
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SetWeightRepsCell
            cell.contentView.isUserInteractionEnabled = true
            cell.delegate = self
            cell.setTextField.tag = indexPath.row
            cell.weightTextField.tag = indexPath.row
            cell.repsTextField.tag = indexPath.row
            cell.setTextField.delegate = self
            cell.weightTextField.delegate = self
            cell.repsTextField.delegate = self
            cell.numberLabel.text = "\(indexPath.row + 1)"
            cell.deleteButton.tag = indexPath.row
            if tempStoredModel[indexPath.row].setName == "" {
                cell.setTextField.text = .none 
            } else {
                cell.setTextField.text = tempStoredModel[indexPath.row].setName
            }
            
            if tempStoredModel[indexPath.row].weight == 0.0 {
                cell.weightTextField.text = .none
            } else {
                cell.weightTextField.text = String(tempStoredModel[indexPath.row].weight)
            }
            
            if tempStoredModel[indexPath.row].reps == 0 {
                cell.repsTextField.text = .none
            } else {
                cell.repsTextField.text = String(tempStoredModel[indexPath.row].reps)
            }
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
                tempStoredModel.append(Detailed(setName: "", weight: 0, isDone: false, reps: 0, id: ""))
                return
            }
            if textField == cell.setTextField {
                tempStoredModel[textField.tag].setName = textField.text ?? ""
                print("DEBUG: tag:\(textField.tag): \(tempStoredModel[textField.tag].setName)")
            } else if textField == cell.weightTextField {
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
        self.tempStoredModel.append(Detailed(setName: "", weight: 0, isDone: false, reps: 0, id: ""))
        print("DEBUG: add one cell \(tempStoredModel)")
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}

extension SetWeightRepsTableView: SetWeightRepsCellDelegate {
    func deleteCell(tag: Int) {
        self.resignFirstResponder()
        print("DEBUG: want to delete the \(tag) cell")
        self.tempStoredModel.remove(at: tag)
        print("DEBUG: delete one cell \(tempStoredModel)")
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}

