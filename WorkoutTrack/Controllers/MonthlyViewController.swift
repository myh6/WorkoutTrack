//
//  MonthlyViewController.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/9.
//

import UIKit
import FSCalendar
import GoogleMobileAds

class MonthlyViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var fsCalendarView: FSCalendar!
    private let todayLabel: UILabel = {
        let label = UILabel()
        label.text = "History"
        label.textColor = #colorLiteral(red: 0.5647058824, green: 0.5843137255, blue: 0.5647058824, alpha: 1)
        label.font = .init(name: "Futura-Bold", size: 20)
        return label
    }()
    private let dateFormmatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd"
        return format
    }()
    private let noDataView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "No Data"
        label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1).withAlphaComponent(0.6)
        label.font = .init(name: "Futura", size: 20)
        view.addSubview(label)
        label.centerInSuperview()
        return view
    }()
    private var haveDataDate: [String]?
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(ExpandCell.self, forCellReuseIdentifier: "expandCell")
        tv.register(SectionsCell.self, forCellReuseIdentifier: "sectionCell")
        tv.separatorStyle = .none
        tv.separatorInset = .zero
        return tv
    }()
    private var action = [AddActionModel]()
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = AdmobID.testID
        banner.backgroundColor = .secondarySystemBackground
        banner.load(GADRequest())
        return banner
    }()
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        self.haveDataDate = CoredataService.shared.allDateHaveData()
        self.fsCalendarView.reloadData()
        checkDateHaveDataStatus(dateFormmatter.string(from: Date()))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    fileprivate func configureUI() {
        self.haveDataDate = CoredataService.shared.allDateHaveData()
        view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        fsCalendarView.appearance.headerTitleFont = .init(name: "Futura", size: 20)
        fsCalendarView.appearance.titleFont = .init(name: "Futura", size: 15)
        fsCalendarView.appearance.weekdayFont = .init(name: "Futura", size: 15)
        fsCalendarView.appearance.eventDefaultColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        fsCalendarView.appearance.eventSelectionColor = #colorLiteral(red: 0.9139711261, green: 0.6553987265, blue: 0.6171647906, alpha: 0.8470588235)
        view.addSubview(todayLabel)
        todayLabel.anchor(top: fsCalendarView.bottomAnchor,
                          left: view.leftAnchor, paddingTop: 10, paddingLeft: 20)
        
        view.addSubview(banner)
        banner.rootViewController = self
        banner.anchor(left: view.leftAnchor,
                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                      right: view.rightAnchor, width: view.frame.size.width, height: 0)
        
        view.addSubview(noDataView)
        noDataView.anchor(top: todayLabel.bottomAnchor,
                          left: view.leftAnchor,
                          bottom: banner.topAnchor,
                          right: view.rightAnchor, paddingTop: 10)
        
        view.addSubview(tableView)
        tableView.anchor(top: todayLabel.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: banner.topAnchor,
                         right: view.rightAnchor, paddingTop: 10)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        checkDateHaveDataStatus(dateFormmatter.string(from: Date()))
    }
    
    fileprivate func checkDateHaveDataStatus(_ date: String) {
        guard haveDataDate != nil else {return}
        if self.haveDataDate!.contains(date) {
            noDataView.isHidden = true
            tableView.isHidden = false
            CoredataService.shared.getDoneDataInSpecificDateFromCoredata(date: date) { actions, error in
                guard error == nil else {return}
                guard let safeActions = actions else {return}
                self.action = safeActions
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            noDataView.isHidden = false
            tableView.isHidden = true
        }
    }
}

//MARK: - Extension FSCalendarDelegate & FSCalendarDelegate
extension MonthlyViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = dateFormmatter.string(from: date)
        Log.info("DEBUG: Calendar dataString \(dateString)")
        guard haveDataDate != nil else { return 0 }
        return self.haveDataDate!.contains(dateString) ? 1 : 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        Log.info("DEBUG: Select \(dateFormmatter.string(from: date)) from calenda")
        self.todayLabel.text = dateFormmatter.string(from: date)
        checkDateHaveDataStatus(dateFormmatter.string(from: date))
    }
}
//MARK: - Extension UITableViewDelegate & UITableViewDataSource
extension MonthlyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 60 : 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return action.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return action[section].isOpen ? action[section].detail.count + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath) as! SectionsCell
            cell.configureForMonthlyView(with: action[indexPath.section])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "expandCell", for: indexPath) as! ExpandCell
            cell.configureForMontlyView(with: action[indexPath.section].detail[indexPath.row - 1])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            action[indexPath.section].isOpen = !action[indexPath.section].isOpen
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    
    
}
