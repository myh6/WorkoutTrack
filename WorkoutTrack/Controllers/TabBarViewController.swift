//
//  TabBarViewController.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/9.
//

import UIKit

public let userDefault = UserDefaults.standard
class TabBarViewController: UITabBarController {
    
    //MARK: - Properties
    private let weekVC = WeeklyViewController()
    private let monthVC = UIStoryboard(name: MonthlyViewController.identifier, bundle: nil).instantiateViewController(withIdentifier: MonthlyViewController.identifier) as! MonthlyViewController
//    private let chartVC = UIStoryboard(name: ChartViewController.identifier, bundle: nil).instantiateViewController(withIdentifier: ChartViewController.identifier) as! ChartViewController
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //CoredataService.shared.addDummyDataToCoreData()
        //userDefault.set("zh-Hant", forKey: "Language")
        //userDefault.set("en", forKey: "Language")
        configureUI()
    }
    
    //MARK: - Helpers
    fileprivate func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0.9782040715, green: 0.9782040715, blue: 0.9782039523, alpha: 1)
        viewControllers = [weekVC, monthVC]
        
        guard let items = self.tabBar.items else { return }
        let images = ["house", "calendar.circle"]
        let selectedImages = ["house.fill", "calendar.circle.fill"]
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        for i in 0 ... 1 {
            items[i].image = UIImage(systemName: images[i])?.applyingSymbolConfiguration(config)
            items[i].selectedImage = UIImage(systemName: selectedImages[i])
        }
        self.tabBar.tintColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        self.tabBar.layer.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    }
}
