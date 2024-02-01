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
    
    //MARK: - Add Dummy Data To CoreData
    /**Create**/
    func addDummyDataToCoreData() {
        CoreDataCreationService.shared.addDummyDataToCoreData()
    }
    
    //MARK: - Add Data to CoreData
    /**Create**/
    func addDataToCoreData(_ data: Detailed, completion: ((Error?) -> Void)) {
        CoreDataCreationService.shared.addDataToCoreData(data, completion: completion)
    }
    
    //MARK: - Create Custom Action
    func addCustomAction(todatabase action: String, completion: ((Error?) -> Void)) {
        CoreDataCreationService.shared.addCustomAction(todatabase: action, completion: completion)
    }
    
    //MARK: - Get all data from CoreData
    /**Read**/
    func getAllDataFromCoredata(completion: @escaping ([Detail]?, Error?) -> Void) {
        CoreDataFetchingService.shared.getAllDataFromCoredata(completion: completion)
    }
    
    //MARK: - Get custom action from CoreData
    func getCustomActionFromCoredata(ofType: String, completion: @escaping ([String]?, Error?) -> Void) {
        CoreDataFetchingService.shared.getCustomActionFromCoredata(ofType: ofType, completion: completion)
    }
    
    //MARK: - Get today's data from CoreData
    /**Read**/
    func getTodayActionFromCoredata(completion: @escaping ([AddActionModel]?, Error?) -> Void) {
        CoreDataFetchingService.shared.getTodayActionFromCoredata(completion: completion)
    }
    
    //MARK: - Get specific date's data from CoreData
    /**Read**/
    func getDataInSpecificDateFromCoredata(date: String, completion: @escaping ([AddActionModel]?, Error?) -> Void) {
        CoreDataFetchingService.shared.getDataInSpecificDateFromCoredata(date: date, completion: completion)
    }
    
    //MARK: - Get done data for calendar
    /**Read For Monthly View**/
    func getDoneDataInSpecificDateFromCoredata(date: String, completion: @escaping ([AddActionModel]?, Error?) -> Void) {
        CoreDataFetchingService.shared.getDoneDataInSpecificDateFromCoredata(date: date, completion: completion)
    }
    
    //MARK: - Get history dat
    /**Read**/
    func getHistoryDataOfSpecificExercise(_ exercise: String, completion: @escaping (([HistoryModel]?, Error?) -> Void)) {
        CoreDataFetchingService.shared.getHistoryDataOfSpecificExercise(exercise, completion: completion)
    }
    
    //MARK: - Get date which have data for calendar
    /**Read**/
    func allDateHaveData() -> [String]? {
        CoreDataFetchingService.shared.allDateHaveData()
    }
    
    //MARK: - check specific date have data or not
    /**Read**/
    func checkDateHaveData(_ date: String) -> Bool? {
        CoreDataFetchingService.shared.checkDateHaveData(date)
    }
    
    //MARK: - get number of sets that have been done in this week
    /**Read**/
    func getNumberOfSetsInThisWeek(of_ type: String, action: String) -> Int? {
        CoreDataFetchingService.shared.getNumberOfSetsInThisWeek(of_: type, action: action)
    }
    
    //MARK: - get the max weight of specific exercise from CoreData
    /**Read get the max weight of specific exercise from CoreData **/
    func getMaxWeight(of_ type: String, action: String, completion: @escaping (((Detail)?) -> Void)) {
        CoreDataFetchingService.shared.getMaxWeight(of_: type, action: action, completion: completion)
    }
    
    //MARK: - get the max reps of specific exercise from CoreData
    /**Read get the max weight of specific exercise from CoreData **/
    func getMaxReps(of_ type: String, action: String, completion: @escaping (((Detail)?) -> Void)) {
        CoreDataFetchingService.shared.getMaxReps(of_: type, action: action, completion: completion)
    }
    
    //MARK: - get the max weight per date from CoreData
    /**Read get the max weight per date from CoreData**/
    func getMaxWeightInHistory(of_ type: String, action: String, reps: Int16, completion: @escaping ((([Detail])?)-> Void)) {
        CoreDataFetchingService.shared.getMaxWeightInHistory(of_: type, action: action, reps: reps, completion: completion)
    }
    //MARK: - Update isDone property
    /**Update isDone Property**/
    func updateCheckPropertytoCoreData(id: String) {
        CoreDataUpdatingService.shared.updateCheckPropertytoCoreData(id: id)
    }
    
    //MARK: - Update isOpen
    /**Update isOpen**/
    func updateisOpen(type: String, actionName: String, date: inout String) {
        CoreDataUpdatingService.shared.updateisOpen(type: type, actionName: actionName, date: &date)
    }
    
    //MARK: - Update Weight/Reps
    /**Update set data**/
    func updateSetData(id: String, weight: String, Reps: String) {
        CoreDataUpdatingService.shared.updateSetData(id: id, weight: weight, Reps: Reps)
    }
    //MARK: - Delete All data from CoreData
    /**Delete**/
    func deleteAllDataFromCoredata() {
        CoreDataDeletionService.shared.deleteAllDataFromCoredata()
    }
    
    //MARK: - Delete specific action from CoreData
    /**Delete**/
    func deleteSpecificActionFromCoredata(action: String, time: String) {
        CoreDataDeletionService.shared.deleteSpecificActionFromCoredata(action: action, time: time)
    }
    
    //MARK: - Delete specific set from CoreData
    /**Delete**/
    func deleteSpecificSetFromCoredata(id: String) {
        CoreDataDeletionService.shared.deleteSpecificSetFromCoredata(id: id)
    }
    
    //MARK: - Delete uncheck expired exercise to save disk space
    /**Delete**/
    func deletExpiredData() {
        CoreDataDeletionService.shared.deletExpiredData()
    }
    
    //MARK: - Delete custom exercise and relative data
    /**Delete**/
    func deleteCustomExercise(exercise: String, completion: @escaping ((Error?)->Void)) {
        CoreDataDeletionService.shared.deleteCustomExercise(exercise: exercise, completion: completion)
    }
    
}
