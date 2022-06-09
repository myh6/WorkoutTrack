//
//  Extension.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/4/23.
//


import UIKit

public struct AnchoredConstraints {
    public var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

public func translation(_ zh: String) -> String? {
    
    if !((userDefault.value(forKey: "Language") as! String) == "zh-Hant") {
        return zh
    } else {
        switch zh {
        case "腿部": return "Legs"
        case "保加利亞分腿蹲": return "Bulgarian Split Squat"
        case "高背槓深蹲": return "Back Squat"
        case "槓鈴早安": return "Barbell Good Morning"
        case "小腿提踵": return "Calf Raise"
        case "啞鈴登階": return "Dumbell Step Up"
        case "啞鈴早安": return "Dumbell Good Morning"
        case "前蹲": return "Front Squat"
        case "坐式蹬腿": return "Leg Press"
        case "雙腿屈伸": return "Leg Extension"
        case "單腿深蹲": return "Pistol Squat"
        case "後跨步": return "Reverse Lunge"
        case "相撲硬舉": return "Sumo Deadlift"
        case "相撲深蹲": return "Sumo Squat"
        case "側躺抬腿": return "Side Leg Raise"
        case "傳統硬舉": return "Traditional Deadlift"
        case "弓步蹲": return "Walking Lunge"
            
        case "胸部": return "Chest"
        case "槓鈴臥推": return "Barbell Bench Press"
        case "槓鈴上斜臥推": return "Barbell Incline Bench Press"
        case "槓鈴下斜臥推": return "Barbell Decline Bench Press"
        case "滑輪胸前交叉夾胸": return "Cable Crossover"
        case "滑輪推胸": return "Cable Chest Press"
        case "啞鈴臥推": return "Dumbbell Bench Press"
        case "雙槓撐體": return "Dip"
        case "啞鈴上斜臥推": return "Dumbbell Incline Bench Press"
        case "啞鈴下斜臥推": return "Dumbbell Decline Bench Press"
        case "啞鈴上斜飛鳥": return "Dumbbell Incline Fly"
        case "啞鈴下斜飛鳥": return "Dumbbell Decline Fly"
        case "啞鈴仰臥屈臂上拉": return "Dumbbell Pullover"
        case "下胸繩索飛鳥夾胸": return "Low-Cable Crossover"
        case "機械式胸部推舉": return "Machine Chest Press"
        case "蝴蝶機夾胸": return "Pec Deck"
        case "伏地挺身": return "Push-Up"
        case "單臂啞鈴臥推": return "Single Arm Dumbbell Press"
            
        case "背部": return "Back"
        case "槓鈴划船": return "Barbell Row"
        case "背部屈伸": return "Back Extension"
        case "槓鈴聳肩": return "Barbell Shrug"
        case "滑輪直臂下拉": return "Cable Rope Pullover"
        case "單手滑輪下拉": return "Cable One Arm Lat Pull"
        case "窄握下拉": return "Close Grip Pull"
        case "反握引體向上": return "Chin-up"
        case "啞鈴划船": return "Dumbbell Row"
        case "啞鈴聳肩": return "Dumbbell Shrug"
        case "滑輪下拉": return "Lat Pulldown"
        case "機械式划船": return "Machine Row"
        case "正握引體向上": return "Pull-up"
        case "反握滑輪下拉": return "Reverse Grip Pull"
        case "單臂啞鈴划船": return "Single-Arm Row"
        case "坐姿滑輪划船": return "Seated Cable Row"
        case "T槓地雷管划船": return "T-Bar Row"
        case "寬握下拉": return "Wide Grip Pull"
            
        case "手部": return "Arms"
        case "槓鈴彎舉": return "Barbell Curl"
        case "槓鈴頭顱壓碎者": return "Barbell Skull Crusher"
        case "板凳撐體": return "Bench Dip"
        case "單臀啞鈴彎舉": return "Concentration Curl"
        case "反握滑輪彎舉": return "Cable Curl"
        case "滑輪三頭肌下壓": return "Cable Rop Pushdown"
        case "滑輪過頭三頭屈伸": return "Cable Overhead Extension"
        case "啞鈴錘式彎舉": return "Dumbbell Hammer Curl"
        case "啞鈴俯身臂屈伸": return "Dumbbell Kickback"
        case "啞鈴過頭三頭屈伸": return "Dumbbell Overhead Extension"
        case "啞鈴斜托彎舉": return "Dumbbell Decline Curl"
        case "傾斜啞鈴彎舉": return "Dumbbell Incline Curl"
        case "啞鈴頭顱壓碎者": return "Dumbbell Skull Crusher"
        case "下斜三頭屈伸": return "Decline Tricep Extension"
        case "上斜三頭屈伸": return "Incline Triceps Extension"
        case "平躺三頭屈伸": return "Lying Tricep Extension"
        case "機械式彎舉": return "Machine Bicep Curl"
        case "機械式撐體": return "Machine Seated Dip"
        case "繩索過頭屈伸": return "Overhead Cable Extension"
        case "斜板屈臂彎舉": return "Preacher Curl"
        case "蜘蛛彎舉": return "Spider Curl"
            
        case "肩膀": return "Shoulder"
        case "阿諾推舉": return "Arnold Press"
        case "槓鈴直立上提": return "Barbell Upright Row"
        case "滑輪面拉": return "Cable Face Pull"
        case "滑輪聳肩": return "Cable Shrug"
        case "滑輪單臂側平舉": return "Cable One Arm Lateral Raise"
        case "滑輪反向飛鳥": return "Cable Rear Delt Fly"
        case "滑輪直立上提": return "Cable Upright Row"
        case "滑輪單臂下拉": return "Cable One Arm Pulldown"
        case "啞鈴前平舉": return "Dumbell Front Raise"
        case "啞鈴側平舉": return "Dumbell Lateral Raise"
        case "啞鈴肩推": return "Dumbell Shoulder Press"
        case "啞鈴反向飛鳥": return "Dumbell Reverse Fly"
        case "啞鈴直立上提": return "Dumbell Upright Row"
        case "地雷管肩推": return "Landmine Press"
        case "槓鈴肩推": return "Military Press"
        case "機械式反向飛鳥": return "Machine Reverse Fly"
        case "機械式側平舉": return "Machine Lateral Raise"
        case "機械式肩推": return "Machine Shoulder Press"
        case "機械式下拉": return "Machine Lat Pulldown"
        case "槓片前平舉": return "Plate Front Raise"
            
        case "腹肌": return "Abs"
        case "仰臥起坐": return "Basic Crunch"
        case "仰臥起坐雙手碰膝": return "Crunch Hands to Knees"
        case "死蟲": return "Dead Bug"
        case "抬膝左右摸腳踝": return "Elevated Heel Touch"
        case "仰臥踢腿": return "Flutter Kick"
        case "仰臥剪式": return "Front Scissors"
        case "空心支撐": return "Hollow Hold"
        case "抬膝仰臥起坐": return "Knee-To-Elbow Sit-Up"
        case "仰臥放腿": return "Leg Lowers"
        case "機械式坐姿卷腹": return "Machine Crunch"
        case "平板撐": return "Plank"
        case "反向捲腹": return "Reverse Crunch"
        case "仰臥腳懸空畫圈": return "Raised Leg Circle"
        case "俄羅斯扭轉": return "Russian Twist"
        case "直腿伸起": return "Straight Leg Raise"
        case "單手側撐體": return "Side Plank"
        case "V字屈體": return "V-Sit"
        case "雨刷式": return "Windshield Whiper"
            
        case "臀部": return "Glutes"
        case "滑輪驢子踢腿": return "Cable Donkey Kick"
        case "滑輪側抬腿": return "Cable Lateral Leg Raise"
        case "曲膝橋式": return "Glute Bridge"
        case "臀推": return "Hip Thrust"
        case "壺鈴擺盪": return "Kettlebell Swing"
        case "側向弓步": return "Lateral Lunge"
        case "機械式驢子踢腿": return "Machine Donkey Kick"
        case "機械式坐式外收肌": return "Machine Seated Abduction"
        case "機械式坐式內收肌": return "Machine Seated Adduction"
        case "機械式站式外收肌": return "Machine Standing Abduction"
        case "機械式站式內收肌": return "Machine Standing Adduction"
        case "羅馬尼亞硬舉": return "Romanian Deadlift"
        case "單腳羅馬尼亞硬舉": return "Single-Leg RDL"
        default:
            break
        }
        return nil
    }
}

//MARK: - String
extension String {
    func localizeString(string: String) -> String {
        let path = Bundle.main.path(forResource: string, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}

//MARK: - UIColor
extension UIColor {
    
    static let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
}

//MARK: - UIImageView
extension UIImageView{
    
    var roundedImage: UIImageView {
        let maskLayer = CAShapeLayer(layer: self.layer)
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x:0, y:0))
        bezierPath.addLine(to: CGPoint(x:self.bounds.size.width, y:0))
        bezierPath.addLine(to: CGPoint(x:self.bounds.size.width, y:self.bounds.size.height))
        bezierPath.addQuadCurve(to: CGPoint(x:0, y:self.bounds.size.height), controlPoint: CGPoint(x:self.bounds.size.width/2, y:self.bounds.size.height+self.bounds.size.height*0.3))
        bezierPath.addLine(to: CGPoint(x:0, y:0))
        bezierPath.close()
        maskLayer.path = bezierPath.cgPath
        maskLayer.frame = self.bounds
        maskLayer.masksToBounds = true
        self.layer.mask = maskLayer
        return self
    }
    
}

//MARK: - UIViewController
extension UIViewController {
    
    func configureGradientLayer() {
        let topColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.frame
    }
    
    func showAlert(title:String){
        let alert = UIAlertController(title: "", message: "\(title)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

//MARK: - Sequence
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

//MARK: - UITableViewCell
extension UITableViewCell {
    var selectionColor: UIColor {
        set {
            let view = UIView()
            view.backgroundColor = newValue
            self.selectedBackgroundView = view
        }
        get {
            return self.selectedBackgroundView?.backgroundColor ?? UIColor.clear
        }
    }
}

//MARK: - UIView
extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 1.5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addTopRoundedCornerToView(desiredCurve:CGFloat?)
    {
        let offset: CGFloat = self.frame.width/desiredCurve!
        let bounds: CGRect = self.bounds
        
        let rectBounds: CGRect = CGRect(x: bounds.origin.x,
                                        y: bounds.origin.y+bounds.size.height / 2,
                                        width: bounds.size.width,
                                        height: bounds.size.height / 2)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2,
                                        y: bounds.origin.y,
                                        width: bounds.size.width + offset,
                                        height: bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        maskLayer.fillColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        self.layer.insertSublayer(maskLayer, at: 0)
        
        self.layer.mask = maskLayer
    }
    
    func addBottomRoundedCornerToView(desiredCurve:CGFloat?)
    {
        let offset: CGFloat = self.frame.width/desiredCurve!
        let bounds: CGRect = self.bounds
        
        let rectBounds: CGRect = CGRect(x: bounds.origin.x,
                                        y: bounds.origin.y,
                                        width: bounds.size.width,
                                        height: bounds.size.height / 2)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2,
                                        y: bounds.origin.y,
                                        width: bounds.size.width + offset,
                                        height: bounds.size.height)
        
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        maskLayer.fillColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        self.layer.insertSublayer(maskLayer, at: 0)
        
        self.layer.mask = maskLayer
    }
    
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    @discardableResult
    open func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    @discardableResult
    open func fillSuperview(padding: UIEdgeInsets = .zero) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        let anchoredConstraints = AnchoredConstraints()
        guard let superviewTopAnchor = superview?.topAnchor,
              let superviewBottomAnchor = superview?.bottomAnchor,
              let superviewLeadingAnchor = superview?.leadingAnchor,
              let superviewTrailingAnchor = superview?.trailingAnchor else {
            return anchoredConstraints
        }
        
        return anchor(top: superviewTopAnchor, leading: superviewLeadingAnchor, bottom: superviewBottomAnchor, trailing: superviewTrailingAnchor, padding: padding)
    }
    
    @discardableResult
    open func fillSuperviewSafeAreaLayoutGuide(padding: UIEdgeInsets = .zero) -> AnchoredConstraints {
        let anchoredConstraints = AnchoredConstraints()
        if #available(iOS 11.0, *) {
            guard let superviewTopAnchor = superview?.safeAreaLayoutGuide.topAnchor,
                  let superviewBottomAnchor = superview?.safeAreaLayoutGuide.bottomAnchor,
                  let superviewLeadingAnchor = superview?.safeAreaLayoutGuide.leadingAnchor,
                  let superviewTrailingAnchor = superview?.safeAreaLayoutGuide.trailingAnchor else {
                return anchoredConstraints
            }
            return anchor(top: superviewTopAnchor, leading: superviewLeadingAnchor, bottom: superviewBottomAnchor, trailing: superviewTrailingAnchor, padding: padding)
            
        } else {
            return anchoredConstraints
        }
    }
    
    open func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    open func centerXToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
    }
    
    open func centerYToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
    }
    
    @discardableResult
    open func constrainHeight(_ constant: CGFloat) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        anchoredConstraints.height = heightAnchor.constraint(equalToConstant: constant)
        anchoredConstraints.height?.isActive = true
        return anchoredConstraints
    }
    
    @discardableResult
    open func constrainWidth(_ constant: CGFloat) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        anchoredConstraints.width = widthAnchor.constraint(equalToConstant: constant)
        anchoredConstraints.width?.isActive = true
        return anchoredConstraints
    }
    
    open func setupShadow(opacity: Float = 0, radius: CGFloat = 0, offset: CGSize = .zero, color: UIColor = .black) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }
    
    convenience public init(backgroundColor: UIColor = .clear) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    func loadViewFormNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self).first as? UIView
    }
}

//MARK: - Calendar
extension Calendar {
    func intervalOfWeek(for date: Date) -> DateInterval? {
        dateInterval(of: .weekOfYear, for: date)
    }
    
    func startOfWeek(for date: Date) -> Date? {
        intervalOfWeek(for: date)?.start
    }
    
    func daysWithSameWeekOfYear(as date: Date) -> [Date] {
        guard let startOfWeek = startOfWeek(for: date) else {
            return []
        }
        
        return (0 ... 6).reduce(into: []) { result, daysToAdd in
            result.append(Calendar.current.date(byAdding: .day, value: daysToAdd, to: startOfWeek))
        }
        .compactMap { $0 }
    }
}
