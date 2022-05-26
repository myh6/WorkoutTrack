//
//  XAxisNameFormater.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/19.
//

import Foundation
import Charts

/**Transform date into label shown in line chart**/
final class XAxisNameFormater: NSObject, IAxisValueFormatter {

    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"

        return formatter.string(from: Date(timeIntervalSince1970: value))
    }

}
