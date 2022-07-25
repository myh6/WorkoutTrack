//
//  ViewController.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/4/23.
//

import UIKit
import GoogleMobileAds

class WeeklyViewController: UIViewController {
    
    //MARK: - Properties
    private let date = Date()
    private var dateFormatter: DateFormatter = {
        let form = DateFormatter()
        form.dateFormat = "yyyy/MM/dd"
        return form
    }()
    private let headerView = UIImageView(image: UIImage(named: "blueMaskCurved")?.withRenderingMode(.alwaysOriginal))
    private lazy var addWorkoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Add-1")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleAddWokrout), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "setting")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSetting), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let first = NSMutableAttributedString(string: "GYM", attributes: [.foregroundColor: UIColor.black])
        let second = NSMutableAttributedString(string: "HACK", attributes: [.foregroundColor: #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)])
        first.append(second)
        label.attributedText = first
        label.adjustsFontSizeToFitWidth = true
        label.font = .init(name: "Futura-Bold", size: 40)
        return label
    }()
    
    private let startLabel: UILabel = {
        let label = UILabel()
        label.text = "ADD WORKOUT"
        label.textColor = .white
        label.font = .init(name: "Futura-Bold", size: 25)
        return label
    }()
    private var weekButton = WeekProgressView()
    
    private let todayLabel: UILabel = {
        let label = UILabel()
        label.text = "TODAY"
        label.textColor = #colorLiteral(red: 0.5647058824, green: 0.5843137255, blue: 0.5647058824, alpha: 1)
        label.font = .init(name: "Futura-Bold", size: 20)
        return label
    }()
    private let blankView = UIView()
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "NO DATA YET"
        label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1).withAlphaComponent(0.6)
        label.font = .init(name: "Futura", size: 20)
        return label
    }()
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(ExpandCell.self, forCellReuseIdentifier: ExpandCell.identifier)
        tv.register(SectionsCell.self, forCellReuseIdentifier: SectionsCell.identifier)
        tv.separatorStyle = .singleLine
        //tv.separatorInset = .zero
        return tv
    }()
    private var action = [AddActionModel]()
    private var todayDetails = [AddActionModel]()
    private var deleteDate: String?
    
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = AdmobID.testID
        banner.backgroundColor = .secondarySystemBackground
        banner.load(GADRequest())
        return banner
    }()
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        CoredataService.shared.getTodayActionFromCoredata { action, error in
            guard error == nil else { return }
            guard let safeActions = action else { return }
            self.action = safeActions
            //print("DEBUG: Today data from Coredata \(self.action)")
            DispatchQueue.main.async {
                self.todayLabel.text = "TODAY"
                self.tableView.reloadData()
                self.checkActionStatus()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
                
        CoredataService.shared.getTodayActionFromCoredata { action, error in
            guard error == nil else { return }
            guard let safeActions = action else { return }
            self.action = safeActions
            //print("DEBUG: Today data from Coredata \(self.action)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        configureUI()
    }
    
    //MARK: - Actions
    @objc func handleAddWokrout() {
        NewExercise.clearData()
        let vc = NewActionViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    @objc func handleSetting() {
        let vc = LanguageOverlayView()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true)
    }
    
    @objc func updateLanguage() {
        if (userDefault.value(forKey: "Language") as! String) == "en" {
            var tempDate = self.todayLabel.text
            if self.titleLabel.text == "TODAY" {
                tempDate = dateFormatter.string(from: Date())
            }
            CoredataService.shared.getDataInSpecificDateFromCoredata(date: tempDate ?? dateFormatter.string(from: Date())) { actions, error in
                guard error == nil else {return}
                guard actions != nil else {return}
                self.action = actions!
            }
        } else {
            for i in 0 ..< self.action.count {
                action[i].moveName = action[i].moveName.localizeString(string: userDefault.value(forKey: "Language") as! String)
            }
        }
        bodys = ["Chest".localizeString(string: userDefault.value(forKey: "Language") as! String),
                 "Back".localizeString(string: userDefault.value(forKey: "Language") as! String),
                 "Shoulder".localizeString(string: userDefault.value(forKey: "Language") as! String),
                 "Arms".localizeString(string: userDefault.value(forKey: "Language") as! String),
                 "Abs".localizeString(string: userDefault.value(forKey: "Language") as! String),
                 "Legs".localizeString(string: userDefault.value(forKey: "Language") as! String),
                 "Glutes".localizeString(string: userDefault.value(forKey: "Language") as! String)]
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.checkActionStatus()
        }

    }
    //MARK: - Helpers
    fileprivate func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          paddingTop: 20, paddingLeft: 15)
        view.addSubview(settingButton)
        settingButton.anchor(top: titleLabel.topAnchor,
                             right: view.rightAnchor,
                             paddingRight: 20, width: 50, height: 50)
        view.addSubview(addWorkoutButton)
        addWorkoutButton.anchor(top: titleLabel.topAnchor, left: titleLabel.rightAnchor,
                                right: settingButton.leftAnchor, paddingRight: 5, width: 50, height: 50)
        
        view.addSubview(weekButton)
        weekButton.anchor(top: titleLabel.bottomAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor, paddingTop: 20)
        weekButton.delegate = self
        
        view.addSubview(todayLabel)
        todayLabel.anchor(top: weekButton.bottomAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor, paddingTop: 10, paddingLeft: 20)
        
        view.addSubview(banner)
        banner.rootViewController = self
        banner.anchor(left: view.leftAnchor,
                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                      right: view.rightAnchor, width: view.frame.size.width, height: 0)
        
        view.addSubview(blankView)
        blankView.anchor(top: todayLabel.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: banner.topAnchor,
                         right: view.rightAnchor)
        blankView.addSubview(noDataLabel)
        noDataLabel.centerInSuperview()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.anchor(top: todayLabel.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: banner.topAnchor,
                         right: view.rightAnchor)
        tableView.isHidden = action.isEmpty ? true : false
        blankView.isHidden = action.isEmpty ? false : true
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .updateLang, object: nil)
    }
    
    fileprivate func checkActionStatus() {
        if self.action.isEmpty {
            self.blankView.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.blankView.isHidden = true
            self.tableView.isHidden = false
        }
    }
    
}

//MARK: - Extension: UITableViewDelegate, UITableViewDataSource
extension WeeklyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.row == 0 {
            print("DEBUG: You want to delete an action \(action[indexPath.section].moveName)")
            let delete = UIContextualAction(style: .destructive, title: "Delete") { _, view, completionHandler in
                //Delete Data in action and CoreData here.
                if self.todayLabel.text == "TODAY" {
                    self.deleteDate = self.dateFormatter.string(from: Date())
                } else {
                    self.deleteDate = self.todayLabel.text
                }
                CoredataService.shared.deleteSpecificActionFromCoredata(action: self.action[indexPath.section].moveName,
                                                                        time: self.deleteDate!)
                DispatchQueue.main.async {
                    self.action.remove(at: indexPath.section)
                    self.tableView.deleteSections([indexPath.section], with: .none)
                    if self.todayLabel.text == "TODAY" {
                        CoredataService.shared.getTodayActionFromCoredata { actions, error in
                            guard error == nil else {return}
                            guard let safeActions = actions else {return}
                            self.action = safeActions
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.checkActionStatus()
                            }
                        }
                    } else {
                        CoredataService.shared.getDataInSpecificDateFromCoredata(date: self.todayLabel.text!) { actions, error in
                            guard error == nil else {return}
                            guard let safeActions = actions else {return}
                            self.action = safeActions
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.checkActionStatus()
                            }
                        }
                    }
                }
                completionHandler(true)
            }
            delete.backgroundColor = #colorLiteral(red: 0.9139711261, green: 0.6553987265, blue: 0.6171647906, alpha: 0.8470588235)
            delete.image = UIImage(systemName: "trash.fill")?.withTintColor(.white)
            let swipe = UISwipeActionsConfiguration(actions: [delete])
            swipe.performsFirstActionWithFullSwipe = false
            return swipe
        } else {
            let edit = UIContextualAction(style: .normal, title: "Edit") { _, view, completionHandler in
                //Update Data
                let editAlert = UIAlertController(title: "Edit your Set".localizeString(string: userDefault.value(forKey: "Language") as! String), message: "", preferredStyle: .alert)
                //Add TextField To alertController
                editAlert.addTextField { wtf in
                    wtf.placeholder = "Weight"
                    wtf.text = String(self.action[indexPath.section].detail[indexPath.row - 1].weight)
                    wtf.font = .init(name: "Futura", size: 20)
                    wtf.keyboardType = .decimalPad
                }
                editAlert.addTextField { rtf in
                    rtf.placeholder = "Reps"
                    rtf.text = String(self.action[indexPath.section].detail[indexPath.row - 1].reps)
                    rtf.font = .init(name: "Futura", size: 20)
                    rtf.keyboardType = .numberPad
                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                let update = UIAlertAction(title: "Update", style: .default) { _ in
                    print("Update weight reps for set")
                    //Update Data
                    guard editAlert.textFields![0].hasText else {return}
                    guard editAlert.textFields![1].hasText else {return}
                    CoredataService.shared.updateSetData(id: self.action[indexPath.section].detail[indexPath.row - 1].id,
                                                         weight: editAlert.textFields![0].text!,
                                                         Reps: editAlert.textFields![1].text!)
                    var nowDate = self.todayLabel.text
                    if self.todayLabel.text == "TODAY" {
                        nowDate = self.dateFormatter.string(from: self.date)
                    }
                    CoredataService.shared.getDataInSpecificDateFromCoredata(date: nowDate!) { actions, error in
                        guard error == nil else {return}
                        guard let safeActions = actions else {return}
                        self.action = safeActions
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                editAlert.addAction(cancel)
                editAlert.addAction(update)
                self.present(editAlert, animated: true)
                completionHandler(true)
            }
            let delete = UIContextualAction(style: .destructive, title: "Delete") { _, view, completionHandler in
                //Delete Data in action and CoreData here.
                CoredataService.shared.deleteSpecificSetFromCoredata(id: self.action[indexPath.section].detail[indexPath.row - 1].id)
                DispatchQueue.main.async {
                    self.action[indexPath.section].detail.remove(at: indexPath.row - 1)
                    self.tableView.deleteRows(at: [indexPath], with: .none)
                    if self.todayLabel.text == "TODAY" {
                        CoredataService.shared.getTodayActionFromCoredata { actions, error in
                            guard error == nil else {return}
                            guard let safeActions = actions else {return}
                            self.action = safeActions
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.checkActionStatus()
                            }
                        }
                    } else {
                        CoredataService.shared.getDataInSpecificDateFromCoredata(date: self.todayLabel.text!) { actions, error in
                            guard error == nil else {return}
                            guard let safeActions = actions else {return}
                            self.action = safeActions
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.checkActionStatus()
                            }
                        }
                    }
                }
                completionHandler(true)
            }
            delete.backgroundColor = #colorLiteral(red: 0.9139711261, green: 0.6553987265, blue: 0.6171647906, alpha: 0.8470588235)
            delete.image = UIImage(systemName: "trash.fill")?.withTintColor(.white)
            edit.backgroundColor = #colorLiteral(red: 0.9139711261, green: 0.6553987265, blue: 0.6171647906, alpha: 0.8470588235)
            edit.image = UIImage(systemName: "pencil")?.withTintColor(.white)
            let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
            swipe.performsFirstActionWithFullSwipe = false
            return swipe
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else {
            return 50
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return action.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = action[section]
        if section.isOpen {
            return section.detail.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var isFinished = 0
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionsCell.identifier, for: indexPath) as! SectionsCell
            cell.isOpen = action[indexPath.section].isOpen
            cell.title.text = action[indexPath.section].moveName.localizeString(string: userDefault.value(forKey: "Language") as! String)
            cell.backgroundColor = .white
            cell.sectinoImage.image = UIImage(named: "\(action[indexPath.section].ofType)") ?? #imageLiteral(resourceName: "dumbbell").withRenderingMode(.alwaysTemplate)
            cell.totalLabel.text = String(action[indexPath.section].detail.count)
            for i in 0 ..< action[indexPath.section].detail.count {
                if action[indexPath.section].detail[i].isDone == true {
                    isFinished += 1
                }
            }
            cell.finishLabel.text = String(isFinished)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpandCell.identifier, for: indexPath) as! ExpandCell
            cell.title.text = action[indexPath.section].detail[indexPath.row - 1].setName
            cell.checkButton.configuration?.image = action[indexPath.section].detail[indexPath.row - 1].isDone ? UIImage(systemName: checkMark)?.withRenderingMode(.alwaysTemplate) : UIImage(systemName: uncheck)?.withRenderingMode(.alwaysTemplate)
            cell.textField.text = String(action[indexPath.section].detail[indexPath.row - 1].weight) + " kg"
            cell.repsLable.text = "x" + String(action[indexPath.section].detail[indexPath.row - 1].reps)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            action[indexPath.section].isOpen = !action[indexPath.section].isOpen
            tableView.reloadSections([indexPath.section], with: .none)
            /**Update CoreData**/
            CoredataService.shared.updateisOpen(type: action[indexPath.section].ofType, actionName: action[indexPath.section].moveName, date: &(self.todayLabel.text)!)
        } else {
            print("DEBUG: Expand Cell got tapped")
            let cell = tableView.cellForRow(at: indexPath) as! ExpandCell
            action[indexPath.section].detail[indexPath.row - 1].isDone = !action[indexPath.section].detail[indexPath.row - 1].isDone
            cell.checkButton.configuration?.image = action[indexPath.section].detail[indexPath.row - 1].isDone ? UIImage(systemName: checkMark)?.withRenderingMode(.alwaysTemplate) : UIImage(systemName: uncheck)?.withRenderingMode(.alwaysTemplate)
            //Update CoreData
            CoredataService.shared.updateCheckPropertytoCoreData(id: action[indexPath.section].detail[indexPath.row - 1].id)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
}

//MARK: - Extension: WeekProgressVie Delegate
extension WeeklyViewController: WeekProgressViewDelegate {
    func sendDataToViewController(date: String, actions: [AddActionModel]?) {
        if date == dateFormatter.string(from: self.date) {
            CoredataService.shared.getTodayActionFromCoredata { actions, error in
                guard error == nil else {return}
                guard let safeActions = actions else {return}
                self.action = safeActions
                DispatchQueue.main.async {
                    self.todayLabel.text = "TODAY"
                    self.tableView.reloadData()
                    self.checkActionStatus()
                    return
                }
            }
        } else {
            guard let safeActions = actions else {return}
            self.action = safeActions
            self.todayLabel.text = date
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.checkActionStatus()
            }
        }

    }
}

//MARK: - Extension: ViewControllerTransitioningDelegate
extension WeeklyViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
