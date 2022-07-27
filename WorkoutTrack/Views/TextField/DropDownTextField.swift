//
//  DropDownTextField.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/15.
//

import UIKit
import DropDown

private let down = "chevron.down"
private let cell = "CustomDropCell"
protocol DropDownTextFieldDelegate: AnyObject {
    func dropDownTextDidChange(_ dropDownTextField: DropDownTextField, text: String)
}

class DropDownTextField: UITextField {
    
    //MARK: - Properties
    var arrayList = [String]()
    let dropDown = DropDown()
    let leftBuffer = UIView()
    let rightImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: down)?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        return iv
    }()
    weak var dropDownTextFieldDelegate: DropDownTextFieldDelegate?
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setDrop()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        setDrop()
    }
    //MARK: - Actions
    @objc func handleTap(sender: UITapGestureRecognizer) {
        Log.info("DEBUG: tap working")
        resignFirstResponder()
        dropDown.show()
        
    }
    
    //MARK: - Helpers
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: self.bounds.width - 15, y: self.bounds.height/2, width: 5 , height: 5)
    }
    
    fileprivate func configureUI() {
        adjustsFontSizeToFitWidth = true
        backgroundColor = .white
        leftBuffer.setDimensions(height: self.frame.size.height, width: 10)
        leftView = leftBuffer
        leftViewMode = .always
        rightView = rightImage
        rightViewMode = .always
        layer.cornerRadius = 10
        layer.borderColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        layer.borderWidth = 1
        borderStyle = .none
        font = .init(name: "Futura", size: 15)
        autocorrectionType = .no
    }
    
    func setArray(array: [String]?) {
        var tempArray = array
        if (userDefault.value(forKey: "Language") as! String) == "zh-Hant" {
            for i in 0 ..< tempArray!.count {
                tempArray![i] = tempArray![i].localizeString(string: userDefault.value(forKey: "Language") as! String)
            }
        }
        self.arrayList = tempArray ?? []
        self.dropDown.dataSource = tempArray ?? []
    }
    
    func setDrop() {
        dropDown.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1)
        dropDown.anchorView = self
        dropDown.dataSource = arrayList
        dropDown.textFont = UIFont.init(name: "Futura", size: 15) ?? UIFont.systemFont(ofSize: 15)
        dropDown.textColor = .white
        dropDown.cornerRadius = 10
        dropDown.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        dropDown.layer.borderWidth = 1
        dropDown.width = self.frame.size.width
        dropDown.bottomOffset = CGPoint(x: 0, y: self.bounds.height)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            superview!.endEditing(true)
            Log.info("DEBUG: Select \(item) at index \(index)")
            text = arrayList[index]
            dropDownTextFieldDelegate?.dropDownTextDidChange(self, text: text ?? "")
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
}
