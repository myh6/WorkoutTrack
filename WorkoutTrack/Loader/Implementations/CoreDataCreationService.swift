//
//  CoreDataCreationService.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/1.
//

import Foundation
import UIKit
import CoreData

final class CoreDataCreationService {    
    // Add Dummy Data To CoreData
    func addDummyDataToCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        //Create a firstdetail
        let firstDetail = Detail(context: context)
        firstDetail.isDone = true
        firstDetail.weight = 70
        firstDetail.reps = 10
        firstDetail.id = UUID().uuidString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        firstDetail.time = "2021/06/26"
//        firstDetail.time = dateFormatter.string(from: Date())
        let firstAction = Action(context: context)
        firstAction.actionName = "Arnold Press"
        firstAction.ofType = "Shoulder"
        firstAction.details = NSSet.init(object: firstDetail)
        do {
            try context.save()
            Log.info("DEBUG: Successfully save data to Coredata")
        } catch {
            Log.error("DEBUG: Error saving data to Coredata", error)
        }
    }

    // Add Data to CoreData
    func addDataToCoreData(_ data: Detailed, completion: ((Error?) -> Void)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        guard let safeName = NewExercise.actionName else {return}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let detail = Detail(context: context)
        detail.isDone = data.isDone
        detail.setName = data.setName
        detail.weight = data.weight
        detail.reps = Int16(data.reps)
        detail.time = dateFormatter.string(from: NewExercise.time!)
        detail.id = UUID().uuidString
        let action = Action(context: context)
        action.actionName = safeName
        action.ofType = NewExercise.ofType
        action.isOpen = false
        action.details = NSSet.init(object: detail)
        do {
            try context.save()
            Log.info("DEBUG: Successfully save data to Coredata")
            completion(nil)
        } catch {
            Log.error("DEBUG: Error saving data to Coredata", error)
            completion(error)
        }
    }

    // Create Custom Action
    func addCustomAction(todatabase action: String, completion: ((Error?) -> Void)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let customAction = CustomAction(context: context)
        customAction.ofType = NewExercise.ofType
        customAction.actionName = action
        do {
            try context.save()
            Log.info("DEBUG: Successfully save custom action to Core Data")
            completion(nil)
        } catch {
            Log.error("DEBUG: Error saving custom action")
            completion(error)
        }
    }
}
