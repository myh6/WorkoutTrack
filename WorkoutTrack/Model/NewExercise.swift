//
//  NewExercise.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/5/2.
//

import Foundation

struct NewExercise {
    
    static var time: Date?
    static var setName: String?
    static var weight: Float?
    static var reps: Int?
    static var actionName: String?
    static var ofType: String?
    static var statusCheck = false
    
    static func clearData() {
        time = nil
        setName = nil
        weight = nil
        reps = nil
        actionName = nil
        ofType = nil
        statusCheck = false
    }

    
}
