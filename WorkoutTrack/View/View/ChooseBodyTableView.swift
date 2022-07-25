//
//  ChooseBodyTableView.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/3.
//

import UIKit

protocol ChooseBodyTableViewDelegate: AnyObject {
    func chooseBody(_ body: String)
}
public var bodys = ["Chest".localizeString(string: userDefault.value(forKey: "Language") as! String),
                    "Back".localizeString(string: userDefault.value(forKey: "Language") as! String),
                    "Shoulder".localizeString(string: userDefault.value(forKey: "Language") as! String),
                    "Arms".localizeString(string: userDefault.value(forKey: "Language") as! String),
                    "Abs".localizeString(string: userDefault.value(forKey: "Language") as! String),
                    "Legs".localizeString(string: userDefault.value(forKey: "Language") as! String),
                    "Glutes".localizeString(string: userDefault.value(forKey: "Language") as! String)]
private let bodysImage = ["Chest", "Back", "Shoulder", "Arms", "Abs", "Legs", "Glutes"]

class ChooseBodyTableView: UITableView {
    
    //MARK: - Properties
    weak var chooseDelegate: ChooseBodyTableViewDelegate?
    //MARK: - Lifecycle
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = #colorLiteral(red: 0.9782040715, green: 0.9782040715, blue: 0.9782039523, alpha: 1)
        register(ChooseCell.self, forCellReuseIdentifier: ChooseCell.identifier)
        delegate = self
        dataSource = self
        separatorStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Extension
extension ChooseBodyTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bodys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChooseCell.identifier, for: indexPath) as! ChooseCell
        cell.leftImage.image = UIImage(named: "\(bodysImage[indexPath.row])") ?? #imageLiteral(resourceName: "dumbbell").withRenderingMode(.alwaysTemplate)
        cell.leftImage.contentMode = .scaleAspectFit
        cell.leftImage.layer.cornerRadius = 10
        cell.title.text = bodys[indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NewExercise.ofType = translation(bodys[indexPath.row])!
        chooseDelegate?.chooseBody(bodys[indexPath.row])
    }
    
    
}

extension ChooseCell {
    func configureToBodyCell(indexPath: Int) {
        leftImage.contentMode = .scaleAspectFit
        leftImage.layer.cornerRadius = 10
        
    }
}
