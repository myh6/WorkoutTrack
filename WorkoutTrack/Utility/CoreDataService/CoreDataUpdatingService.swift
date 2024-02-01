//
//  CoreDataUpdatingService.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/1.
//

import Foundation
import CoreData
import UIKit

final class CoreDataUpdatingService {
    static let shared = CoreDataUpdatingService()
    
    func updateCheckPropertytoCoreData(id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        request.predicate = NSPredicate(format: "id LIKE %@", id)
        do {
            let details = try context.fetch(request)
            for detail in details {
                detail.isDone = !detail.isDone
            }
            do {
                try context.save()
            } catch {
                Log.error("DEBUG: Error updating check status", error)
            }
        } catch {
            Log.error("DEBUG: UpdateCheckProperty Error retriving data from coredata", error)
        }
    }

    func updateisOpen(type: String, actionName: String, date: inout String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if date == "TODAY" {
            date = dateFormatter.string(from: Date())
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        let predicate1 = NSPredicate(format: "ofAction.actionName LIKE %@", actionName)
        let predicate2 = NSPredicate(format: "ofAction.ofType LIKE %@", type)
        let predicate3 = NSPredicate(format: "time LIKE %@", date)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
        do {
            let details = try context.fetch(request)
            for detail in details {
                guard detail.ofAction != nil else {return}
                detail.ofAction?.isOpen = !detail.ofAction!.isOpen
            }
            do {
                try context.save()
            } catch {
                Log.error("DEBUG: Error updating isOpen proeprty", error)
            }
        } catch {
            Log.error("DEBUG: Error retriving data from CoreData", error)
        }
    }
    
    func updateSetData(id: String, weight: String, Reps: String) {
        let newW = Float(weight)
        let newR = Int16(Reps)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        request.predicate = NSPredicate(format: "id LIKE %@", id)
        request.fetchLimit = 1
        do {
            let detail = try context.fetch(request)
            for detail in detail {
                detail.weight = newW ?? detail.weight
                detail.reps = newR ?? detail.reps
            }
            do {
                try context.save()
            } catch {
                Log.error("DEBUG: Error updating data", error)
            }
        } catch {
            Log.error("DEBUG: Error retriving data", error)
        }
    }
}
