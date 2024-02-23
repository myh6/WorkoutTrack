//
//  CoredataHelper.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/4/26.
//

import Foundation
import UIKit
import CoreData

enum ErrorMessage: Error {
    case sameSetName
}

final class CoredataService {
    
    static let shared = CoredataService()
    
    // MARK: - Create
    func addDummyDataToCoreData() {
        CoreDataCreationService().addDummyDataToCoreData()
    }
    
    func addDataToCoreData(_ data: Detailed, completion: ((Error?) -> Void)) {
        CoreDataCreationService().addDataToCoreData(data, completion: completion)
    }
    
    func addCustomAction(todatabase action: String, completion: ((Error?) -> Void)) {
        CoreDataCreationService().addCustomAction(todatabase: action, completion: completion)
    }
    
    //MARK: - Read
    func getAllDataFromCoredata(completion: @escaping ([Detail]?, Error?) -> Void) {
        CoreDataFetchingService().getAllDataFromCoredata(completion: completion)
    }
    
    func getCustomActionFromCoredata(ofType: String, completion: @escaping ([String]?, Error?) -> Void) {
        CoreDataFetchingService().getCustomActionFromCoredata(ofType: ofType, completion: completion)
    }
    
    func getTodayActionFromCoredata(completion: @escaping ([AddActionModel]?, Error?) -> Void) {
        CoreDataFetchingService().getTodayActionFromCoredata(completion: completion)
    }
    
    func getDataInSpecificDateFromCoredata(date: String, completion: @escaping ([AddActionModel]?, Error?) -> Void) {
        CoreDataFetchingService().getDataInSpecificDateFromCoredata(date: date, completion: completion)
    }
    
    //Read For Monthly View
    func getDoneDataInSpecificDateFromCoredata(date: String, completion: @escaping ([AddActionModel]?, Error?) -> Void) {
        CoreDataFetchingService().getDoneDataInSpecificDateFromCoredata(date: date, completion: completion)
    }
    
    func getHistoryDataOfSpecificExercise(_ exercise: String, completion: @escaping (([HistoryModel]?, Error?) -> Void)) {
        CoreDataFetchingService().getHistoryDataOfSpecificExercise(exercise, completion: completion)
    }
    
    func allDateHaveData() -> [String]? {
        CoreDataFetchingService().allDateHaveData()
    }
    
    func checkDateHaveData(_ date: String) -> Bool? {
        CoreDataFetchingService().checkDateHaveData(date)
    }
    
    func getNumberOfSetsInThisWeek(of_ type: String, action: String) -> Int? {
        CoreDataFetchingService().getNumberOfSetsInThisWeek(of_: type, action: action)
    }
    
    func getMaxWeight(of_ type: String, action: String, completion: @escaping (((Detail)?) -> Void)) {
        CoreDataFetchingService().getMaxWeight(of_: type, action: action, completion: completion)
    }
    
    func getMaxReps(of_ type: String, action: String, completion: @escaping (((Detail)?) -> Void)) {
        CoreDataFetchingService().getMaxReps(of_: type, action: action, completion: completion)
    }
    
    func getMaxWeightInHistory(of_ type: String, action: String, reps: Int16, completion: @escaping ((([Detail])?)-> Void)) {
        CoreDataFetchingService().getMaxWeightInHistory(of_: type, action: action, reps: reps, completion: completion)
    }
    
    //MARK: - Update
    //Update isDone Property
    func updateCheckPropertytoCoreData(id: String) {
        CoreDataUpdatingService().updateCheckPropertytoCoreData(id: id)
    }
    
    func updateisOpen(type: String, actionName: String, date: inout String) {
        CoreDataUpdatingService().updateisOpen(type: type, actionName: actionName, date: &date)
    }
    
    //Update set data
    func updateSetData(id: String, weight: String, Reps: String) {
        CoreDataUpdatingService().updateSetData(id: id, weight: weight, Reps: Reps)
    }
    
    //MARK: - Delete
    func deleteAllDataFromCoredata() {
        CoreDataDeletionService().deleteAllDataFromCoredata()
    }
    
    func deleteSpecificActionFromCoredata(action: String, time: String) {
        CoreDataDeletionService().deleteSpecificActionFromCoredata(action: action, time: time)
    }
    
    func deleteSpecificSetFromCoredata(id: String) {
        CoreDataDeletionService().deleteSpecificSetFromCoredata(id: id)
    }
    
    //Delete uncheck expired exercise to save disk space
    func deletExpiredData() {
        CoreDataDeletionService().deletExpiredData()
    }
    
    func deleteCustomExercise(exercise: String, completion: @escaping ((Error?)->Void)) {
        CoreDataDeletionService().deleteCustomExercise(exercise: exercise, completion: completion)
    }
    
}
