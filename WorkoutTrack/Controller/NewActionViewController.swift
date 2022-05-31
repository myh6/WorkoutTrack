//
//  NewActionViewController.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/2.
//

import UIKit

class NewActionViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "goBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Workout"
        label.font = .init(name: "Futura-Bold", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()

    private let pageControl: UIPageControl = {
        let pg = UIPageControl()
        pg.numberOfPages = 4
        pg.currentPageIndicatorTintColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        pg.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        return pg
    }()
    private let chooseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose date"
        label.font = .init(name: "Futura", size: 20)
        label.textColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        return label
    }()
    private let chooseBodyLabel: UILabel = {
        let label = UILabel()
        label.text = "Body"
        label.font = .init(name: "Futura", size: 20)
        label.textColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        return label
    }()
    private let chooseExerciseLabel: UILabel = {
        let label = UILabel()
        label.text = "Exercise"
        label.font = .init(name: "Futura", size: 20)
        label.textColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        return label
    }()
    private let chooseCustomLabel: UILabel = {
        let label = UILabel()
        label.text = "Custom Exercise"
        label.font = .init(name: "Futura", size: 20)
        label.textColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        return label
    }()
    private lazy var addCustomButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var text = AttributedString(" Custom Action")
        text.font = UIFont(name: "Futura", size: 10)
        text.foregroundColor = #colorLiteral(red: 0.9139711261, green: 0.6553987265, blue: 0.6171647906, alpha: 1)
        config.attributedTitle = text
        config.image = UIImage(systemName: "plus.circle")?.withTintColor( #colorLiteral(red: 0.9139711261, green: 0.6553987265, blue: 0.6171647906, alpha: 1), renderingMode: .alwaysOriginal)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular)
        button.configuration = config
        button.addTarget(self, action: #selector(handleAddCustomAction), for: .touchUpInside)
        return button
    }()
    private let chooseSetLabel: UILabel = {
        let label = UILabel()
        label.text = "Set & Weight & Reps"
        label.font = .init(name: "Futura", size: 20)
        label.textColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        return label
    }()
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "save")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()

    private let scrollView = UIScrollView()
    private let dateTableView = WeekDateChooseTableView()
    private let bodyTableView = ChooseBodyTableView()
    private let exerciseTableView = ChooseExerciseTableView()
    private let customExerciseTableView = ChooseCustomExerciseTableView()
    private var setWeightRepsTableView = SetWeightRepsTableView()
    private let histroyTableView = HistoryTableView()
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        print("DEBUG: NewActionVC viewWillAppear")
        self.bodyTableView.reloadData()
        Moves.shared.getDBMenu { moves in
            guard moves != nil else {return}
            ChooseExerciseTableView.data = moves!.Chest
            for i in 0 ..< ChooseExerciseTableView.data.count {
                ChooseExerciseTableView.data[i] = ChooseExerciseTableView.data[i].localizeString(string: userDefault.value(forKey: "Language") as! String)
            }
        }
        CoredataService.shared.getCustomActionFromCoredata(ofType: NewExercise.ofType ?? "Chest") { custom, error in
            guard error == nil else {
                self.showAlert(title: "Error getting custom exercise \(error!)")
                return
            }
            guard custom != nil else {return}
            ChooseCustomExerciseTableView.data = custom ?? []
        }
        DispatchQueue.main.async {
            self.customExerciseTableView.reloadData()
            self.exerciseTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageControl.frame = CGRect(x: 0, y: containerView.frame.size.height - 40,
                                   width: containerView.frame.size.width, height: 40)
        scrollView.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width,
                                  height: containerView.frame.size.height - pageControl.frame.size.height)
        configureScrollView()
    }
    deinit {
        print("DEBUG: NewActionViewController got deinit")
    }
    //MARK: - Actions
    @objc func handleBack() {
        NewExercise.clearData()
        self.dismiss(animated: true)
    }
    
    @objc func handleNoType() {
        self.showAlert(title: "Please choose a body part.")
        
    }
    
    @objc func handleNoAction() {
        self.showAlert(title: "Please choose an exercise.")
        
    }
    
    @objc func handleNoDate() {
        self.showAlert(title: "Please choose a date")
        
    }
    
    @objc func handleNoReps() {
        self.showAlert(title: "Please set your reps to a nonzero value")
        
    }
    
    @objc func handleNoSetData() {
        self.showAlert(title: "You need at least one set to save.")
        
    }
    
    @objc func handleAddCustomAction() {
        guard NewExercise.ofType != nil else {
            self.showAlert(title: "Please choose a body type first.")
            return
        }
        print("DEBUG: NewActionVC show add custom action alert")
        let customActionAlert = UIAlertController(title: "Add Custom Exercise".localizeString(string: userDefault.value(forKey: "Language") as! String), message: "Can't find your exercise? Create your custom one.".localizeString(string: userDefault.value(forKey: "Language") as! String), preferredStyle: .alert)
        customActionAlert.addTextField { actiontf in
            actiontf.placeholder = "Add Custom Exercise"
            actiontf.font = .init(name: "Futura", size: 20)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            guard customActionAlert.textFields![0].hasText else {return}
            CoredataService.shared.addCustomAction(todatabase: customActionAlert.textFields![0].text!,
                                                   completion: { error in
                guard error != nil else {return}
                self.showAlert(title: "Error adding custom action \(error!)")
            })
            CoredataService.shared.getCustomActionFromCoredata(ofType: NewExercise.ofType!) { customs, error in
                guard error == nil else {
                    self.showAlert(title: "Error getting custom exercise \(error!)")
                    return
                }
                guard customs != nil else {return}
                ChooseCustomExerciseTableView.data = customs ?? []
            }
            DispatchQueue.main.async {
                self.customExerciseTableView.reloadData()
            }
        }
        customActionAlert.addAction(cancel)
        customActionAlert.addAction(add)
        self.present(customActionAlert, animated: true)
    }
    
    @objc func handleSave() {
        if NewExercise.time == nil {
            handleNoDate()
            return
        }
        if NewExercise.actionName == nil || NewExercise.actionName == "" {
            handleNoAction()
            return
        }
        if NewExercise.ofType == nil || NewExercise.ofType == "" {
            handleNoType()
            return
        }
        NotificationCenter.default.post(name: .saveData, object: nil)
        
        if !NewExercise.statusCheck {
            handleNoReps()
            return
        }
        
        self.dismiss(animated: true)

    }

    //MARK: - Helpers
    fileprivate func configureUI() {
        view.backgroundColor = .white
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 60, paddingLeft: 20)
        backButton.setDimensions(height: 50, width: 50)
        view.addSubview(titleLabel)
        titleLabel.anchor(top: backButton.topAnchor, left: backButton.rightAnchor, bottom: backButton.bottomAnchor, right: view.rightAnchor, paddingRight: 20)
        view.addSubview(containerView)
        containerView.anchor(top: backButton.bottomAnchor,
                             left: view.leftAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             right: view.rightAnchor,
                             paddingTop: 20, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        containerView.addSubview(pageControl)
        pageControl.anchor(left: containerView.leftAnchor,
                           bottom: containerView.bottomAnchor,
                           right: containerView.rightAnchor)
        containerView.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.anchor(top: containerView.topAnchor,
                          left: containerView.leftAnchor,
                          bottom: pageControl.topAnchor,
                          right: containerView.rightAnchor)
        pageControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNoType), name: .noType, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNoAction), name: .noAction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNoDate), name: .noDate, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(handleNoReps), name: .noReps, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNoSetData), name: .noDataForSet, object: nil)
    }
    
    private func configureScrollView() {
        scrollView.contentSize = CGSize(width: containerView.frame.size.width*4,
                                        height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        for x in 0..<4 {
            let page = UIView(frame: CGRect(x: CGFloat(x) * containerView.frame.size.width, y: 0,
                                            width: containerView.frame.size.width, height: scrollView.frame.size.height))
            switch x {
            case 0:
                configureFirstPage(page)
            case 1:
                configureSecondPage(page)
            case 2:
                configureThirdPage(page)
            case 3:
                configureFourthPage(page)
            default:
                break
            }
            scrollView.addSubview(page)
        }
    }
    
    /**First Page in ScrollView Choose Date**/
    fileprivate func configureFirstPage(_ page: UIView) {
        page.addSubview(chooseDateLabel)
        chooseDateLabel.anchor(top: page.topAnchor,
                               left: page.leftAnchor, paddingTop: 20, paddingLeft: 30)
        chooseDateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        page.addSubview(dateTableView)
        dateTableView.anchor(top: chooseDateLabel.bottomAnchor,
                             left: page.leftAnchor,
                             bottom: page.bottomAnchor,
                             right: page.rightAnchor,
                             paddingTop: 20)
        dateTableView.chooseDelegate = self
    }
    
    /**Second Page in ScrollView Choose Body**/
    fileprivate func configureSecondPage(_ page: UIView) {
        page.addSubview(chooseBodyLabel)
        chooseBodyLabel.anchor(top: page.topAnchor,
                               left: page.leftAnchor, paddingTop: 20, paddingLeft: 30)
        chooseBodyLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        page.addSubview(bodyTableView)
        bodyTableView.anchor(top: chooseBodyLabel.bottomAnchor,
                             left: page.leftAnchor,
                             bottom: page.bottomAnchor,
                             right: page.rightAnchor,
                             paddingTop: 20)
        bodyTableView.chooseDelegate = self
    }
    
    /**Third Page in ScrollView Choose Exercise**/
    fileprivate func configureThirdPage(_ page: UIView) {
        page.addSubview(chooseExerciseLabel)
        chooseExerciseLabel.anchor(top: page.topAnchor,
                                   left: page.leftAnchor, paddingTop: 20, paddingLeft: 30)
        chooseExerciseLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        page.addSubview(exerciseTableView)
        exerciseTableView.anchor(top: chooseExerciseLabel.bottomAnchor,
                                 left: page.leftAnchor,
                                 right: page.rightAnchor,
                                 paddingTop: 20, height: page.frame.size.height / 2)
        exerciseTableView.chooseDelegate = self
        page.addSubview(chooseCustomLabel)
        chooseCustomLabel.anchor(top: exerciseTableView.bottomAnchor,
                                 left: page.leftAnchor,
                                 paddingTop: 20, paddingLeft: 30)
        page.addSubview(addCustomButton)
        addCustomButton.anchor(top: chooseCustomLabel.topAnchor,
                               bottom: chooseCustomLabel.bottomAnchor,
                               right: page.rightAnchor, paddingRight: 5)
        page.addSubview(customExerciseTableView)
        customExerciseTableView.anchor(top: chooseCustomLabel.bottomAnchor,
                                       left: page.leftAnchor,
                                       bottom: page.bottomAnchor,
                                       right: page.rightAnchor)
        customExerciseTableView.chooseCustomDelegate = self
    }
    
    /**Fourth Page in ScrollView Choose Set & Weight & Reps**/
    fileprivate func configureFourthPage(_ page: UIView) {
        //Set&Weight&Reps
        page.addSubview(chooseSetLabel)
        chooseSetLabel.anchor(top: page.topAnchor,
                              left: page.leftAnchor, paddingTop: 20, paddingLeft: 30)
        chooseSetLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        page.addSubview(setWeightRepsTableView)
        setWeightRepsTableView.anchor(top: chooseSetLabel.bottomAnchor,
                                      left: page.leftAnchor,
                                      right: page.rightAnchor)
        setWeightRepsTableView.heightAnchor.constraint(equalToConstant: page.frame.size.height/2 - chooseSetLabel.frame.size.height).isActive = true
        setWeightRepsTableView.setDelegate = self
        
        //Save
        page.addSubview(saveButton)
        saveButton.anchor(bottom: page.bottomAnchor)
        saveButton.centerX(inView: page)
        saveButton.setDimensions(height: 58, width: 289)
        
        //History
        page.addSubview(histroyTableView)
        histroyTableView.anchor(top: setWeightRepsTableView.bottomAnchor,
                                left: page.leftAnchor,
                                bottom: saveButton.topAnchor,
                                right: page.rightAnchor, paddingBottom: 5)
        
    }
    
}

//MARK: - Extension: UIScrollView delegate
extension NewActionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x)/Float(scrollView.frame.size.width)))
    }
}

//MARK: - Extension: Notification Center
extension Notification.Name {
    static let saveData = NSNotification.Name("saveData")
    static let noType = NSNotification.Name("noType")
    static let noAction = NSNotification.Name("noAction")
    static let noDate = NSNotification.Name("noDate")
    static let noReps = NSNotification.Name("noReps")
    static let noDataForSet = NSNotification.Name("noData")
}

//MARK: - Extension: WeekDateChooseTableViewDelgate
extension NewActionViewController: WeekDateChoseTableViewDelegate {
    func chooseDate() {
        self.scrollView.setContentOffset(CGPoint(x: self.containerView.frame.size.width, y: 0), animated: true)
    }
}

//MARK: - Extension: ChooseBodyTableViewDelegate
extension NewActionViewController: ChooseBodyTableViewDelegate {
    func chooseBody(_ body: String) {
        guard NewExercise.ofType != nil else {
            self.showAlert(title: "Please choose a body type first.")
            return
        }
        print("DEBUG: Choose body \(body)")
        Moves.shared.getDBMenu { moves in
            guard moves != nil else {return}
            switch translation(body) {
            case "Chest":       ChooseExerciseTableView.data = moves!.Chest
            case "Back":        ChooseExerciseTableView.data = moves!.Back
            case "Shoulder":    ChooseExerciseTableView.data = moves!.Shoulder
            case "Arms":        ChooseExerciseTableView.data = moves!.Arms
            case "Abs":         ChooseExerciseTableView.data = moves!.Abs
            case "Legs":        ChooseExerciseTableView.data = moves!.Legs
            case "Glutes":      ChooseExerciseTableView.data = moves!.Glutes
            default:
                break
            }
            for i in 0 ..< ChooseExerciseTableView.data.count {
                ChooseExerciseTableView.data[i] = ChooseExerciseTableView.data[i].localizeString(string: userDefault.value(forKey: "Language") as! String)
            }
            DispatchQueue.main.async {
                self.exerciseTableView.reloadData()
            }
        }
        CoredataService.shared.getCustomActionFromCoredata(ofType: NewExercise.ofType!) { output, error in
            guard error == nil else {
                self.showAlert(title: "Error getting custom action from coredata \(error!)")
                return
            }
            ChooseCustomExerciseTableView.data = output ?? []
            DispatchQueue.main.async {
                self.customExerciseTableView.reloadData()
            }
        }

        DispatchQueue.main.async {
            self.chooseExerciseLabel.text = body
            self.scrollView.setContentOffset(CGPoint(x: 2 * self.containerView.frame.size.width,
                                                     y: 0), animated: true)
        }
    }
}

//MARK: - Extension: ChooseCustomExerciseTableViewDelegate
extension NewActionViewController: ChooseCustomExerciseTableViewDelegate {
    func showDeleteCustomAlert(exercise: String) {
        let deleteAlert = UIAlertController(title: "Delete Custom Exercise".localizeString(string: userDefault.value(forKey: "Language") as! String), message: "If you delete \(exercise), all the associated data would be deleted as well. Are you sure to proceed?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { _ in
            CoredataService.shared.deleteCustomExercise(exercise: exercise, completion: { error in
                guard error == nil else {
                    self.showAlert(title: "Error in operation \(error!)")
                    return
                }
            })
            CoredataService.shared.getCustomActionFromCoredata(ofType: NewExercise.ofType ?? "") { customs, error in
                guard error == nil else {
                    self.showAlert(title: "Error getting custom exercises \(error!)")
                    return
                }
                ChooseCustomExerciseTableView.data = customs ?? []
                DispatchQueue.main.async {
                    self.customExerciseTableView.reloadData()
                }
            }
        }
        deleteAlert.addAction(cancel)
        deleteAlert.addAction(confirm)
        self.present(deleteAlert, animated: true)
    }
    
    func chooseCustomExercise(exercise: String) {
        print("DEBUG: exercise choose \(exercise)")
        self.chooseSetLabel.text = exercise
        self.scrollView.setContentOffset(CGPoint(x: 3 * self.containerView.frame.size.width,
                                                 y: 0), animated: true)
    }
}

//MARK: - Extension: ChooseExerciseTableViewDelegate
extension NewActionViewController: ChooseExerciseTableViewDelegate {
    func chooseExercise(_ exercise: String) {
        print("DEBUG: exercise choose \(exercise)")
        self.chooseSetLabel.text = exercise
        self.scrollView.setContentOffset(CGPoint(x: 3 * self.containerView.frame.size.width,
                                                 y: 0), animated: true)
    }
}

//MARK: - Extension: SetWeightRepsTableViewDelegate
extension NewActionViewController: SetWeightRepsTableViewDelegate {
    func sendSaveDataToVC(_ output: [Detailed]) {
        print("DEBUG: got data back from setWeightRepsTableView \(output)")
        for i in 0 ..< (output.count) {
            print("DEBUG: NewActionViewController handleSave: Adding \(output[i]) to Coredata (\(i) time")
            CoredataService.shared.addDataToCoreData(output[i], completion: { error in
                guard error == nil else {
                    self.showAlert(title: "error \(error?.localizedDescription ?? "")")
                    return
                }
            })
        }
    }
}
