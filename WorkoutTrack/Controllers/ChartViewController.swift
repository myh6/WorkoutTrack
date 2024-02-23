////
////  SettingViewController.swift
////  WorkoutTrack
////
////  Created by Min-Yang Huang on 2022/5/9.
////
//
//import UIKit
//import DropDown
//import Charts
//import GoogleMobileAds
//
//class ChartViewController: UIViewController {
//    
//    //MARK: - Properties
//    @IBOutlet weak var ddtStackView: UIStackView!
//    @IBOutlet weak var ddtBody: DropDownTextField!
//    @IBOutlet weak var ddtExercise: DropDownTextField!
//    @IBOutlet weak var ddtReps: DropDownTextField!
//    
//    private let tableView: UITableView = {
//        let tv = UITableView()
//        tv.register(Chart1Cell.self, forCellReuseIdentifier: Chart1Cell.identifier)
//        tv.register(Chart2Cell.self, forCellReuseIdentifier: Chart2Cell.identifier)
//        tv.register(Chart3Cell.self, forCellReuseIdentifier: Chart3Cell.identifier)
//        return tv
//    }()
//    private var tempType: String?
//    private var tempExercise: String?
//    private var tempReps: String?
//    private var setsInWeek = 0
//    private var maxWeightText = ["0kg", "History noData\n noData"]
//    private var maxRepsText = ["0", "History noData\n noData"]
//    private var lineChartData: [ChartDataEntry]?
//    private let dateFormatter: DateFormatter = {
//        let df = DateFormatter()
//        df.dateFormat = "yyyy/MM/dd"
//        return df
//    }()
//    private let banner: GADBannerView = {
//        let banner = GADBannerView()
//        banner.adUnitID = AdmobID.testID
//        banner.backgroundColor = .secondarySystemBackground
//        banner.load(GADRequest())
//        return banner
//    }()
//    //MARK: - Lifecycle
//    override func viewWillAppear(_ animated: Bool) {
//        self.ddtBody.setArray(array: bodys)
//        guard self.tempType != nil && self.tempExercise != nil && self.tempReps != nil else {return}
//        updateCharts()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureUI()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        ddtBody.text = ""
//        ddtExercise.text = ""
//        ddtReps.text = ""
//        self.tempReps = nil
//        self.tempExercise = nil
//        self.tempType = nil
//    }
//    
//    //MARK: - Helpers
//    fileprivate func configureUI() {
//        ddtBody.setArray(array: bodys)
//        ddtBody.tag = 0
//        ddtExercise.tag = 1
//        ddtReps.tag = 2
//        ddtBody.dropDownTextFieldDelegate = self
//        ddtExercise.dropDownTextFieldDelegate = self
//        ddtReps.dropDownTextFieldDelegate = self
//        ddtBody.placeholder = "body"
//        ddtExercise.placeholder = "exercise"
//        ddtReps.placeholder = "rep"
//        view.addSubview(banner)
//        banner.rootViewController = self
//        banner.anchor(left: view.leftAnchor,
//                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
//                      right: view.rightAnchor, width: view.frame.size.width, height: 0)
//        
//        view.addSubview(tableView)
//        tableView.anchor(top: ddtStackView.bottomAnchor,
//                         left: view.leftAnchor,
//                         bottom: banner.topAnchor,
//                         right: view.rightAnchor, paddingTop: 10)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.allowsSelection = false
//        tableView.separatorStyle = .none
//    }
//    
//    /**Update Charts**/
//    fileprivate func updateCharts() {
//        self.setsInWeek = CoredataService.shared.getNumberOfSetsInThisWeek(of_: translation(self.tempType!)!,
//                                                                           action: translation(self.tempExercise!)!) ?? 0
//        CoredataService.shared.getMaxWeight(of_: translation(self.tempType!)!,
//                                            action: translation(self.tempExercise!)!) { detail in
//            guard detail != nil else {
//                self.maxWeightText = ["0kg", "History noData\n noData"]
//                return
//            }
//            self.maxWeightText[0] = String(detail!.weight) + "kg"
//            self.maxWeightText[1] = "History \(detail!.time!)\n \(detail!.weight)kgx\(detail!.reps)"
//        }
//        CoredataService.shared.getMaxReps(of_: translation(self.tempType!)!,
//                                          action: translation(self.tempExercise!)!) { detail in
//            guard detail != nil else {
//                self.maxRepsText = ["0", "History noData\n noData"]
//                return
//            }
//            self.maxRepsText[0] = String(detail!.reps)
//            self.maxRepsText[1] = "History \(detail!.time!)\n \(detail!.weight)kgx\(detail!.reps)"
//        }
//        guard self.tempReps != nil else {return}
//        CoredataService.shared.getMaxWeightInHistory(of_: translation(self.tempType!)!,
//                                                     action: translation(self.tempExercise!)!,
//                                                     reps: Int16(self.tempReps!)!) { details in
//            self.lineChartData = []
//            guard details != nil else {return}
//            for i in 0 ..< details!.count {
//                let graphiableDateDouble = Double(self.dateFormatter.date(from: details![i].time!)!.timeIntervalSince1970)
//                let yValue = Double(details![i].weight)
//                self.lineChartData?.append(ChartDataEntry(x: graphiableDateDouble, y: yValue))
//            }
//        }
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
//}
//
////MARK: - Extension: DropDownTestFieldDelegate
//extension ChartViewController: DropDownTextFieldDelegate {
//    func dropDownTextDidChange(_ dropDownTextField: DropDownTextField, text: String) {
//        Log.info("DEBUG: ChartVC dropDownTextDidChange")
//        var outputArray = [String]()
//        switch dropDownTextField.tag {
//        case DDTid.body.rawValue:
//            self.tempType = text
//            ChartsSelectionModel.ofType = text
//            Moves.shared.getDBMenu { moves in
//                guard moves != nil else {return}
//                switch translation(text) {
//                case "Chest":
//                    outputArray = moves!.Chest
//                case "Back":
//                    outputArray = moves!.Back
//                case "Shoulder":
//                    outputArray = moves!.Shoulder
//                case "Arms":
//                    outputArray = moves!.Arms
//                case "Abs":
//                    outputArray = moves!.Abs
//                case "Legs":
//                    outputArray = moves!.Legs
//                case "Glutes":
//                    outputArray = moves!.Glutes
//                default:
//                    break
//                }
//            }
//            CoredataService.shared.getCustomActionFromCoredata(ofType: translation(text) ?? "") { custom, error in
//                guard error == nil else {
//                    self.showAlert(title: "Error retriving custom exercises")
//                    return
//                }
//                outputArray.append(contentsOf: custom ?? [])
//            }
//            self.ddtExercise.setArray(array: outputArray)
//        case DDTid.exercise.rawValue:
//            self.ddtReps.setArray(array: ["1","2","3","4","5","6",
//                                    "7", "8", "9", "10","11","12"])
//            self.tempExercise = text
//            ChartsSelectionModel.exercise = text
//            Log.info("DEBUG: selected exercise text \(text)")
//            guard self.tempType != nil else {return}
//            guard self.tempExercise != nil else {return}
//            self.setsInWeek = CoredataService.shared.getNumberOfSetsInThisWeek(of_: translation(self.tempType!)!, action: translation(self.tempExercise!)!) ?? 0
//            CoredataService.shared.getMaxWeight(of_: translation(self.tempType!)!, action: translation(self.tempExercise!)!) { detail in
//                guard detail != nil else {
//                    self.maxWeightText = ["0kg", "History noData\n noData"]
//                    return
//                }
//                self.maxWeightText[0] = String(detail!.weight) + "kg"
//                self.maxWeightText[1] = "History \(detail!.time!)\n \(detail!.weight)kgx\(detail!.reps)"
//            }
//            CoredataService.shared.getMaxReps(of_: translation(self.tempType!)!, action: translation(self.tempExercise!)!) { detail in
//                guard detail != nil else {
//                    self.maxRepsText = ["0", "History noData\n noData"]
//                    return
//                }
//                self.maxRepsText[0] = String(detail!.reps)
//                self.maxRepsText[1] = "History \(detail!.time!)\n \(detail!.weight)kgx\(detail!.reps)"
//            }
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        case DDTid.rep.rawValue:
//            self.tempReps = text
//            guard self.tempType != nil else {return}
//            guard self.tempExercise != nil else {return}
//            guard self.tempReps != nil else {return}
//            CoredataService.shared.getMaxWeightInHistory(of_: translation(self.tempType!)!, action: translation(self.tempExercise!)!, reps: Int16(self.tempReps!)!) { details in
//                self.lineChartData = []
//                Chart3Cell.dateLabel.text = "Date"
//                Chart3Cell.weightLabel.text = "Weight"
//                guard details != nil else {return}
//                if details!.isEmpty {
//                    self.lineChartData = nil
//                }
//                for i in 0 ..< details!.count {
//                    let graphiableDateDouble = Double(self.dateFormatter.date(from: details![i].time!)!.timeIntervalSince1970)
//                    Log.info("DEBUG: \(i) origin \(String(describing: details![i].time)) \(details![i].weight)kg graphiableDateDouble \(graphiableDateDouble)")
//                    let yValue = Double(details![i].weight)
////                    if !self.lineChartData!.contains(where: {$0.y == yValue}) {
////                        self.lineChartData?.append(ChartDataEntry(x: graphiableDateDouble, y: yValue))
////                    }
//                    self.lineChartData?.append(ChartDataEntry(x: graphiableDateDouble, y: yValue))
//                }
//                
//            }
//            DispatchQueue.main.async {
//                Chart3Cell.title.text = "Weight Records For \(self.tempReps ?? "") Rep(s)"
//                self.tableView.reloadData()
//            }
//        default:
//            break
//        }
//    }
//}
//
////MARK: - Extension: UITableViewDelegate & UITableViewDataSource
//extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: Chart1Cell.identifier, for: indexPath) as! Chart1Cell
//            cell.contentLabel.text = "You've done \(self.setsInWeek) set(s) of \( translation(self.tempExercise ?? "") ?? "exercise") in this week so far"
//            return cell
//        } else if indexPath.row == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: Chart2Cell.identifier, for: indexPath) as! Chart2Cell
//            cell.configure(with: self.maxWeightText, and: self.maxRepsText)
//            return cell
//        } else if indexPath.row == 2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: Chart3Cell.identifier, for: indexPath) as! Chart3Cell
//            cell.lineChart.delegate = self
//            cell.configure(with: self.lineChartData)
//            return cell
//        } else {
//            return UITableViewCell()
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 0: return 80
//        case 1: return 170
//        case 2: return self.tableView.frame.height - 270
//        default: return 0
//        }
//    }
//    
//}
//
////MARK: - Extension: ChartsDelegate
//extension ChartViewController: ChartViewDelegate {
//    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        Log.info("DEBUG: chartValueSelected entry:\(entry) highlight:\(highlight)")
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        Chart3Cell.dateLabel.text = formatter.string(from: Date(timeIntervalSince1970: entry.x))
//        Chart3Cell.weightLabel.text = "\(entry.y)kg"
//    }
//}
//
