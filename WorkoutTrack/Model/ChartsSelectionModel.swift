//
//  ChartsSelectionModel.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/17.
//

import Foundation
import Charts

struct ChartsSelectionModel {
    
    static var ofType: String?
    static var exercise: String?
    static var reps: String?
    
    static func clearCharts() {
        ofType = nil
        exercise = nil
        reps = nil
    }
}

