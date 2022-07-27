//
//  HistoryActionModel.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/8.
//

import Foundation


struct HistoryModel {
    
    var time: String
    var detail: [HistoryDetail]
}

struct HistoryDetail {
    
    var setName: String
    var weight: Float
    var reps: Int
}
