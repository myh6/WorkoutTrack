////
////  Chart3Cell.swift
////  WorkoutTrack
////
////  Created by Min-Yang Huang on 2022/5/16.
////
//
//import UIKit
//import Charts
//
//class Chart3Cell: UITableViewCell {
//    
//    //MARK: - Properties
//    private let customBackgrund: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 10
//        return view
//    }()
//    
//    var lineChart = LineChartView()
//    static var title: UILabel = {
//        let label = UILabel()
//        label.text = "Weight Records For Rep(s)"
//        label.font = UIFont.init(name: "Futura-Bold", size: 10)
//        return label
//    }()
//    static var dateLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Date"
//        label.font = UIFont.init(name: "Futura", size: 10)
//        return label
//    }()
//    static var weightLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Weight"
//        label.font = UIFont.init(name: "Futura", size: 10)
//        return label
//    }()
//    //MARK: - Lifecycle
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        configureUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    //MARK: - Helpers
//    fileprivate func configureUI() {
//        backgroundColor = .clear
//        addSubview(customBackgrund)
//        customBackgrund.anchor(top: topAnchor, left: leftAnchor,
//                          bottom: bottomAnchor,
//                          right: rightAnchor,
//                               paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10)
//        customBackgrund.dropShadow()
//        customBackgrund.addSubview(Chart3Cell.title)
//        Chart3Cell.title.anchor(top: customBackgrund.topAnchor,
//                     left: customBackgrund.leftAnchor, paddingTop: 20, paddingLeft: 20)
//        let stack = UIStackView(arrangedSubviews: [Chart3Cell.dateLabel, Chart3Cell.weightLabel])
//        stack.distribution = .fillEqually
//        stack.axis = .vertical
//        stack.spacing = .zero
//        customBackgrund.addSubview(stack)
//        stack.anchor(top: Chart3Cell.title.topAnchor,
//                     left: Chart3Cell.title.rightAnchor, paddingLeft: 40)
//        //customBackgrund.addSubview(lineChart)
//        contentView.addSubview(lineChart)
//        lineChart.delegate = self
//        lineChart.pinchZoomEnabled = true
//        lineChart.dragEnabled = true
//        lineChart.setScaleEnabled(true)
//        //lineChart.chartDescription.enabled = false
//        lineChart.legend.enabled = false
//        lineChart.leftAxis.drawGridLinesEnabled = false
//        lineChart.leftAxis.drawLabelsEnabled = false
//        lineChart.leftAxis.drawAxisLineEnabled = false
//        lineChart.xAxis.enabled = false
//        lineChart.xAxis.labelPosition = .bottom
//        lineChart.xAxis.granularity = 5.0
//        lineChart.rightAxis.enabled = false
//        lineChart.leftAxis.axisMinimum = 0
//        lineChart.leftAxis.granularity = 1.0
//        lineChart.noDataText = "No Data Yet"
//        lineChart.noDataFont = UIFont.init(name: "Futura", size: 20) ?? .systemFont(ofSize: 20)
//        lineChart.noDataTextColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1).withAlphaComponent(0.6)
//        lineChart.isUserInteractionEnabled = true
//        lineChart.anchor(top: customBackgrund.topAnchor,
//                         left: customBackgrund.leftAnchor,
//                         bottom: customBackgrund.bottomAnchor,
//                         right: customBackgrund.rightAnchor,
//                         paddingTop: 50)
//    }
//    
//    /**Converting line data to data set to pass in to charts**/
//    private func convertLineDataToSet(_ linechart: [ChartDataEntry]?) -> LineChartData? {
//        guard linechart != nil else {return nil}
//        let set = LineChartDataSet(entries: linechart!)
//        set.colors = [#colorLiteral(red: 0.01568627451, green: 0.5843137255, blue: 0.6666666667, alpha: 0.8470588235)]
//        set.setCircleColor(#colorLiteral(red: 0.01568627451, green: 0.5843137255, blue: 0.6666666667, alpha: 0.8470588235))
//        set.circleHoleColor = UIColor.white
//        set.circleRadius = 5.0
//        set.circleHoleRadius = 3.0
//        set.lineWidth = 2.0
//        let gradientColors = [#colorLiteral(red: 0.01568627451, green: 0.5843137255, blue: 0.6666666667, alpha: 0.8470588235).cgColor, #colorLiteral(red: 0.537254902, green: 0.8, blue: 0.7725490196, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
//        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: [0.7, 0.1, 0])!
//        set.fillAlpha = 1
//        set.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
//        set.mode = .horizontalBezier
//        set.drawFilledEnabled = true
//        Log.info("DEBUG: convertLineDataToSet: \(set)")
//        return LineChartData(dataSet: set)
//    }
//    
//    func configure(with data: [ChartDataEntry]?) {
//        lineChart.data = convertLineDataToSet(data)
//        lineChart.xAxis.valueFormatter = XAxisNameFormater()
//        Log.info("DEBUG: yAxis should have value \(lineChart.leftAxis.entries) count \(lineChart.leftAxis.entryCount)")
//        Log.info("DEBUG: xAxis \(lineChart.xAxis)")
//        lineChart.data?.setValueFont(UIFont.init(name: "Futura", size: 5) ?? .systemFont(ofSize: 5))
//        lineChart.animate(xAxisDuration: 0.5)
//        lineChart.setNeedsDisplay()
//    }
//}
//
////MARK: - Extension: ChartViewDelegate
//extension Chart3Cell: ChartViewDelegate {
//
//}
