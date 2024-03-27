//
//  CoreDataDeletionService.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/1.
//

import Foundation
import CoreData
import UIKit

final class CoreDataDeletionService {
    fileprivate let now = Date()
    fileprivate let calendar = NSCalendar.current
    fileprivate let dateFormatter = DateFormatter()
    
    func deleteAllDataFromCoredata() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Action> = Action.fetchRequest()
        do {
            let actions = try context.fetch(request)
            
            for action in actions {
                context.delete(action)
            }
            
            let testRequest1: NSFetchRequest<Detail> = Detail.fetchRequest()
            let details = try? context.fetch(testRequest1)
            Log.info("DEBUG: Detail from CoreData after delete \(details ?? [])")
            
            do {
                try context.save()
            } catch {
                Log.error("DEBUG: Error saving delete data to CoreData", error)
            }
            
        } catch {
            Log.error("DEUBG: Error fetching data from Coredata", error)
        }
    }

    func deleteSpecificActionFromCoredata(action: String, time: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        let predicate1 = NSPredicate(format: "ofAction.actionName LIKE %@", action)
        let predicate2 = NSPredicate(format: "time LIKE %@", time)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        do {
            let data = try context.fetch(request)
            Log.info("DEBUG: Successfully fetch \(action) from Coredata \(data.count)")
//            let deleteD = data.filter({$0.time! == time})
            for data in data {
                context.delete(data)
            }
            do {
                try context.save()
            } catch {
                Log.error("DEBUG: Error saving data after delete exercise")
            }
        } catch {
            Log.error("DEBUG: Error fetching data from Coredata", error)
        }
    }
    
    func deleteSpecificSetFromCoredata(id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        request.predicate = NSPredicate(format: "id LIKE %@", id)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        do {
            let data = try context.fetch(request)
            Log.info("DEBUG: Should delete \(data)")
            for data in data {
                context.delete(data)
            }
            do {
                try context.save()
            } catch {
                Log.error("DEBUG: Error saving data after delete")
            }
        } catch {
            Log.error("DEBUG: Error fetching data from Coredata", error)
        }
    }
    
    func deletExpiredData() {
        Log.info("DEBUG: delete epired data")
        let week = getThisWeekDate()
        let donePredicate = NSPredicate(format: "isDone == %@", NSNumber(value: false))
        var compoundPredicates: [NSPredicate] = [donePredicate]
        for i in week.indices {
            compoundPredicates.append(NSPredicate(format: "time != %@", week[i]))
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: compoundPredicates)
        do {
            let details = try context.fetch(request)
            for detail in details {
                context.delete(detail)
                do {
                    try context.save()
                } catch {
                    Log.error("DEBUG: Error saving data")
                }
            }
        } catch {
            Log.error("DEBUG: Error fetching data")
        }
    }
    
    func deleteCustomExercise(exercise: String, completion: @escaping ((Error?)->Void)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<CustomAction> = CustomAction.fetchRequest()
        let request2: NSFetchRequest<Action> = Action.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "actionName LIKE %@", exercise)
        request2.predicate = NSPredicate(format: "actionName LIKE %@", exercise)
        do {
            let data = try context.fetch(request)
            let history = try context.fetch(request2)
            for datum in data {
                context.delete(datum)
            }
            for data in history {
                context.delete(data)
            }
            do {
                try context.save()
                completion(nil)
            } catch {
                Log.error("DEBUG: Error saving data after delete", error)
                completion(error)
            }
        } catch {
            Log.error("DEBUG: Error fetching data", error)
            completion(error)
        }
    }
    
    private func getThisWeekDate() -> [String] {
        let thisWeek = calendar.daysWithSameWeekOfYear(as: now)
        dateFormatter.dateFormat = "yyyy/MM/dd"
        var thisWeekDate: [String] = []
        for i in 0...thisWeek.count - 1 {
            thisWeekDate.append(dateFormatter.string(from: thisWeek[i]))
        }
        return thisWeekDate
    }
}
