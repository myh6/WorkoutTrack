//
//  Chart3Cell.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/16.
//

import UIKit
import Charts

class Chart3Cell: UITableViewCell {
    
    //MARK: - Properties
    private let customBackgrund: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    var lineChart = LineChartView()
    static var title: UILabel = {
        let label = UILabel()
        label.text = "Weight Records For Rep(s)"
        label.font = UIFont.init(name: "Futura-Bold", size: 10)
        return label
    }()
    static var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.init(name: "Futura", size: 10)
        return label
    }()
    static var weightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight"
        label.font = UIFont.init(name: "Futura", size: 10)
        return label
    }()
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    fileprivate func configureUI() {
        backgroundColor = .clear
        addSubview(customBackgrund)
        customBackgrund.anchor(top: topAnchor, left: leftAnchor,
                          bottom: bottomAnchor,
                          right: rightAnchor,
                               paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10)
        customBackgrund.dropShadow()
        customBackgrund.addSubview(Chart3Cell.title)
        Chart3Cell.title.anchor(top: customBackgrund.topAnchor,
                     left: customBackgrund.leftAnchor, paddingTop: 20, paddingLeft: 20)
        let stack = UIStackView(arrangedSubviews: [Chart3Cell.dateLabel, Chart3Cell.weightLabel])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = .zero
        customBackgrund.addSubview(stack)
        stack.anchor(top: Chart3Cell.title.topAnchor,
                     left: Chart3Cell.title.rightAnchor, paddingLeft: 40)
        //customBackgrund.addSubview(lineChart)
        contentView.addSubview(lineChart)
        lineChart.delegate = self
        lineChart.pinchZoomEnabled = true
        lineChart.dragEnabled = true
        lineChart.setScaleEnabled(true)
        //lineChart.chartDescription.enabled = false
        lineChart.legend.enabled = false
        lineChart.leftAxis.drawGridLinesEnabled = false
        lineChart.leftAxis.drawLabelsEnabled = false
        lineChart.leftAxis.drawAxisLineEnabled = false
        lineChart.xAxis.enabled = false
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.granularity = 5.0
        lineChart.rightAxis.enabled = false
        lineChart.leftAxis.axisMinimum = 0
        lineChart.leftAxis.granularity = 1.0
        lineChart.noDataText = "No Data Yet"
        lineChart.noDataFont = UIFont.init(name: "Futura", size: 20) ?? .systemFont(ofSize: 20)
        lineChart.noDataTextColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1).withAlphaComponent(0.6)
        lineChart.isUserInteractionEnabled = true
        lineChart.anchor(top: customBackgrund.topAnchor,
                         left: customBackgrund.leftAnchor,
                         bottom: customBackgrund.bottomAnchor,
                         right: customBackgrund.rightAnchor,
                         paddingTop: 50)
    }
}

//MARK: - Extension: ChartViewDelegate
extension Chart3Cell: ChartViewDelegate {

}
