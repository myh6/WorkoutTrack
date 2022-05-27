//
//  LanguageOverlayView.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/21.
//

import UIKit

private let identifier = "langCell"
class LanguageOverlayView: UIViewController {
        
    //MARK: - Properties
    @IBOutlet weak var langPickerView: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    private let langList = ["English", "繁體中文"]

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
//        view.addGestureRecognizer(panGesture)
        tableView.register(LanguageCell.self, forCellReuseIdentifier: identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 5)
    }
    
    //MARK: - Helpers
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        // Not allowing the user to drag the view downward
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
}

//MARK: - Extension: UIPickerView
extension LanguageOverlayView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return langList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return langList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if langList[row] == "English" {
            userDefault.setValue("en", forKey: "Language")
        } else {
            userDefault.set("zh-Hant", forKey: "Language")
        }
        //Change Language
        NotificationCenter.default.post(name: .updateLang, object: nil)
    }
    
}

//MARK: - Extension: UITableView
extension LanguageOverlayView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.langList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! LanguageCell
        cell.title.text = langList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if langList[indexPath.row] == "English" {
            userDefault.setValue("en", forKey: "Language")
        } else {
            userDefault.set("zh-Hant", forKey: "Language")
        }
        //Change Language
        NotificationCenter.default.post(name: .updateLang, object: nil)
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
//MARK: - Extension: Notification.Name
extension Notification.Name {
    static let updateLang = NSNotification.Name("updateLang")
}

