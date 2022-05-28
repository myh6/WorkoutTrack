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
            print("DEBUG: Successfully save data to Coredata")
        } catch {
            print("DEBUG: Error saving data to Coredata \(error.localizedDescription)")
        }
        
    }
    
    //MARK: - Add Data to CoreData
    /**Create**/
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
            print("DEBUG: Successfully save data to Coredata")
            completion(nil)
        } catch {
            print("DEBUG: Error saving data to Coredata \(error.localizedDescription)")
            completion(error)
        }
    }
    
    //MARK: - Get all data from CoreData
    /**Read**/
    func getAllDataFromCoredata(completion: @escaping ([Detail]?, Error?) -> Void) {
        var details = [Detail]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        do {
            details = try context.fetch(request)
            completion(details, nil)
        } catch {
            print("DEBUG: Error fetching data from Coredata \(error.localizedDescription)")
            completion(nil, error)
        }
    }
    
    //MARK: - Get today's data from CoreData
    /**Read**/
    func getTodayActionFromCoredata(completion: @escaping ([AddActionModel]?, Error?) -> Void) {
        
        var details = [Detail]()
        var output = [AddActionModel]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let timeString = dateFormatter.string(from: Date())
        
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        request.predicate = NSPredicate(format: "time LIKE %@", timeString)
        do {
            details = try context.fetch(request)
            
            for detail in details {
                
                print("DEBUG: getTodayActionFromCoredata - \(detail)")
                
                /***/
                if output.isEmpty {
                    
                    output.append(AddActionModel(moveName: detail.ofAction?.actionName ?? "", ofType: detail.ofAction?.ofType ?? "", detail: [Detailed(setName: detail.setName ?? "", weight: detail.weight, isDone: detail.isDone, reps: Int(detail.reps), id: detail.id ?? "")], isOpen: detail.ofAction?.isOpen ?? false))
                    
                } else {
                    
                    /***/
                    if output.contains(where: {$0.moveName == detail.ofAction?.actionName}) {
                        for index in 0 ..< output.count {
                            if output[index].moveName == detail.ofAction?.actionName {
                                output[index].detail.append(Detailed(setName: detail.setName ?? "", weight: detail.weight, isDone: detail.isDone, reps: Int(detail.reps), id: detail.id ?? ""))
                            }
                        }
                    } else {
                        output.append(AddActionModel(moveName: detail.ofAction?.actionName ?? "", ofType: detail.ofAction?.ofType ?? "", detail: [Detailed(setName: detail.setName ?? "Set", weight: detail.weight, isDone: detail.isDone, reps: Int(detail.reps), id: detail.id ?? "")], isOpen: detail.ofAction?.isOpen ?? false))
                    }
                    /***/
                }
                /***/
                
            }
            
            completion(output, nil)
        } catch {
            print("DEBUG: Error fetching today data from Coredata \(error.localizedDescription)")
            completion(nil, error)
        }
        
    }
    
    //MARK: - Get specific date's data from CoreData
    /**Read**/
    func getDataInSpecificDateFromCoredata(date: String, completion: @escaping ([AddActionModel]?, Error?) -> Void) {
        var details = [Detail]()
        var output = [AddActionModel]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        request.predicate = NSPredicate(format: "time LIKE %@", date)
        do {
            details = try context.fetch(request)
            
            for detail in details {
                
                print("DEBUG: get \(date) data from Coredata - \(detail)")
                
                /***/
                if output.isEmpty {
                    
                    output.append(AddActionModel(moveName: detail.ofAction?.actionName ?? "", ofType: detail.ofAction?.ofType ?? "", detail: [Detailed(setName: detail.setName ?? "", weight: detail.weight, isDone: detail.isDone, reps: Int(detail.reps), id: detail.id ?? "")], isOpen: detail.ofAction?.isOpen ?? false))
                    
                } else {
                    
                    /***/
                    if output.contains(where: {$0.moveName == detail.ofAction?.actionName}) {
                        for index in 0 ..< output.count {
                            if output[index].moveName == detail.ofAction?.actionName {
                                output[index].detail.append(Detailed(setName: detail.setName ?? "", weight: detail.weight, isDone: detail.isDone, reps: Int(detail.reps), id: detail.id ?? ""))
                            }
                        }
                    } else {
                        output.append(AddActionModel(moveName: detail.ofAction?.actionName ?? "", ofType: detail.ofAction?.ofType ?? "", detail: [Detailed(setName: detail.setName ?? "Set", weight: detail.weight, isDone: detail.isDone, reps: Int(detail.reps), id: detail.id ?? "")], isOpen: detail.ofAction?.isOpen ?? false))
                    }
                    /***/
                }
                /***/
                
            }
            
            completion(output, nil)
        } catch {
            print("DEBUG: Error fetching today data from Coredata \(error.localizedDescription)")
            completion(nil, error)
        }
    }
    
    //MARK: - Get done data for calendar
    /**Read For Monthly View**/
    func getDoneDataInSpecificDateFromCoredata(date: String, completion: @escaping ([AddActionModel]?, Error?) -> Void) {
        var details = [Detail]()
        var output = [AddActionModel]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        let predicate1 = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        let predicate2 = NSPredicate(format: "time LIKE %@", date)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        do {
            details = try context.fetch(request)
            
            for detail in details {
                
                print("DEBUG: get \(date) data from Coredata - \(detail)")
                
                /***/
                if output.isEmpty {
                    
                    output.append(AddActionModel(moveName: detail.ofAction?.actionName ?? "", ofType: detail.ofAction?.ofType ?? "", detail: [Detailed(setName: detail.setName ?? "", weight: detail.weight, isDone: detail.isDone, reps: Int(detail.reps), id: detail.id ?? "")], isOpen: detail.ofAction?.isOpen ?? false))
                    
                } else {
                    
                    /***/
                    if output.contains(where: {$0.moveName == detail.ofAction?.actionName}) {
                        for index in 0 ..< output.count {
                            if output[index].moveName == detail.ofAction?.actionName {
                                output[index].detail.append(Detailed(setName: detail.setName ?? "", weight: detail.weight, isDone: detail.isDone, reps: Int(detail.reps), id: detail.id ?? ""))
                            }
                        }
                    } else {
                        output.append(AddActionModel(moveName: detail.ofAction?.actionName ?? "", ofType: detail.ofAction?.ofType ?? "", detail: [Detailed(setName: detail.setName ?? "Set", weight: detail.weight, isDone: detail.isDone, reps: Int(detail.reps), id: detail.id ?? "")], isOpen: detail.ofAction?.isOpen ?? false))
                    }
                    /***/
                }
                /***/
                
            }
            
            completion(output, nil)
        } catch {
            print("DEBUG: Error fetching today data from Coredata \(error.localizedDescription)")
            completion(nil, error)
        }
    }
    
    //MARK: - Get history dat
    /**Read**/
    func getHistoryDataOfSpecificExercise(_ exercise: String, completion: @escaping (([HistoryModel]?, Error?) -> Void)) {
        var details = [Detail]()
        var output = [HistoryModel]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        request.predicate = NSPredicate(format: "ofAction.actionName LIKE %@", exercise)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        do {
            details = try context.fetch(request)
            for detail in details {
                /***/
                if output.isEmpty {
                    
                    output.append(HistoryModel(time: detail.time!, detail: [HistoryDetail(setName: detail.setName ?? "", weight: detail.weight, reps: Int(detail.reps))]))
                    
                } else {
                    
                    /***/
                    if output.contains(where: {$0.time == detail.time!}) {
                        for index in 0 ..< output.count {
                            if output[index].time == detail.time! {
                                output[index].detail.append(HistoryDetail(setName: detail.setName ?? "", weight: detail.weight, reps: Int(detail.reps)))
                            }
                        }
                    } else {
                        output.append(HistoryModel(time: detail.time!, detail: [HistoryDetail(setName: detail.setName ?? "", weight: detail.weight, reps: Int(detail.reps))]))
                    }
                    /***/
                }
                /***/
            }
            completion(output, nil)
        } catch {
            print("DEBUG: getHistoryDataOfSpecificExercise Error fetching data \(error.localizedDescription)")
            completion(nil, error)
        }
    }
    
    //MARK: - Get date which have data for calendar
    /**Read**/
    func allDateHaveData() -> [String]? {
        var outputDate: [String]? = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        let context = appDelegate.persistentContainer.viewContext
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        request.predicate = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        do {
            let details = try context.fetch(request)
            for detail in details {
                guard let safeTime = detail.time else {return nil}
                outputDate?.append(safeTime)
            }
            return outputDate?.uniqued()
        } catch {
            print("DEBUG: Error retriving data allDatehaveData \(error.localizedDescription)")
        }
        return outputDate
    }
    
    //MARK: - check specific date have data or not
    /**Read**/
    func checkDateHaveData(_ date: String) -> Bool? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        let context = appDelegate.persistentContainer.viewContext
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        request.predicate = NSPredicate(format: "time LIKE %@", date)
        do {
            let details = try context.fetch(request)
            return details.isEmpty ? false : true
        } catch {
            print("DEBUG: checkDateHaveData Error retriving data.")
            return nil
        }
    }
    
    //MARK: - get number of sets that have been done in this week
    /**Read**/
    func getNumberOfSetsInThisWeek(of_ type: String, action: String) -> Int? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd"
        let calendar = NSCalendar.current
        let weekStart = calendar.startOfWeek(for: Date())
        var weeks: [String] = []
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: weekStart!) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    weeks += [dateFormater.string(from: day)]
                }
            }
        }
        print("DEBUG: \(weeks)")
        guard weeks.count == 7 else { return nil }
        let startDate = weeks.first
        let endDate = weeks.last
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        let predicate1 = NSPredicate(format: "ofAction.actionName LIKE %@", action)
        let predicate2 = NSPredicate(format: "ofAction.ofType LIKE %@", type)
        let predicate3 = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        let predicate4 = NSPredicate(format: "time >= %@ && time <= %@", startDate!, endDate!)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4])
        do {
            let details = try context.fetch(request)
            print(details.count)
            return details.count
        } catch {
            print("DEBUG: Error retriving data in getNumberOfsetinThisWeek from CoreData \(error.localizedDescription)")
            return nil
        }

    }
    
    //MARK: - get the max weight of specific exercise from CoreData
    /**Read get the max weight of specific exercise from CoreData **/
    func getMaxWeight(of_ type: String, action: String, completion: @escaping (((Detail)?) -> Void)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        let predicate1 = NSPredicate(format: "ofAction.actionName LIKE %@", action)
        let predicate2 = NSPredicate(format: "ofAction.ofType LIKE %@", type)
        let predicate3 = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        let sort = NSSortDescriptor(key: "weight", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2 ,predicate3])
        request.fetchLimit = 1
        do {
            let detail = try context.fetch(request).first
            completion(detail)
        } catch {
            print("DEBUG: getMaxWeight Error retriving data from Coredata \(error.localizedDescription)")
        }
    }
    
    //MARK: - get the max reps of specific exercise from CoreData
    /**Read get the max weight of specific exercise from CoreData **/
    func getMaxReps(of_ type: String, action: String, completion: @escaping (((Detail)?) -> Void)) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        let predicate1 = NSPredicate(format: "ofAction.actionName LIKE %@", action)
        let predicate2 = NSPredicate(format: "ofAction.ofType LIKE %@", type)
        let predicate3 = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        let sort = NSSortDescriptor(key: "reps", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
        request.fetchLimit = 1
        do {
            let detail = try context.fetch(request).first
            completion(detail)
        } catch {
            print("DEBUG: getMaxWeight Error retriving data from Coredata \(error.localizedDescription)")
        }
    }
    
    //MARK: - get the max weight per date from CoreData
    /**Read get the max weight per date from CoreData**/
    func getMaxWeightInHistory(of_ type: String, action: String, reps: Int16, completion: @escaping ((([Detail])?)-> Void)) {
        var output: [Detail] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        let predicate1 = NSPredicate(format: "ofAction.actionName LIKE %@", action)
        let predicate2 = NSPredicate(format: "ofAction.ofType LIKE %@", type)
        let predicate3 = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        let predicate4 = NSPredicate(format: "reps == %i", reps)
        let sort = NSSortDescriptor(key: "time", ascending: true)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4])
        request.sortDescriptors = [sort]
        do {
            let detail = try context.fetch(request)
            for detail in detail {
//                print("DEBUG: got detail back from getMaxWeightInHistory -> Date: \(detail.time), Weight:\(detail.weight)")
                if output.isEmpty {
                    output.append(detail)
                } else {
                    /***/
                    if output.contains(where: {$0.time == detail.time}) {
                        for i in 0 ..< output.count {
                            if output[i].time == detail.time {
                                if detail.weight > output[i].weight {
                                    output[i] = detail
                                }
                            }
                        }
                    } else {
                        output.append(detail)
                    }
                }
                /***/
            }
            completion(output)
        } catch {
            print("DEBUG: Error getMaxWeightInHistory Error retriving data from CoreData \(error.localizedDescription)")
        }
    }
    //MARK: - Update isDone property
    /**Update isDone Property**/
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
                print("DEBUG: Error updating check status \(error.localizedDescription)")
            }
        } catch {
            print("DEBUG: UpdateCheckProperty Error retriving data from coredata \(error.localizedDescription)")
        }
    }
    
    //MARK: - Update isOpen
    /**Update isOpen**/
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
                print("DEBUG: Error updating isOpen proeprty \(error.localizedDescription)")
            }
        } catch {
            print("DEBUG: Error retriving data from CoreData \(error.localizedDescription)")
        }
    }
    
    //MARK: - Update Weight/Reps
    /**Update set data**/
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
                print("DEBUG: Error updating data \(error.localizedDescription)")
            }
        } catch {
            print("DEBUG: Error retriving data \(error.localizedDescription)")
        }
    }
    //MARK: - Delete All data from CoreData
    /**Delete**/
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
            print("DEBUG: Detail from CoreData after delete \(details ?? [])")
            
            do {
                try context.save()
            } catch {
                print("DEBUG: Error saving delete data to CoreData \(error.localizedDescription)")
            }
            
        } catch {
            print("DEUBG: Error fetching data from Coredata \(error.localizedDescription)")
        }
    }
    
    //MARK: - Delete specific action from CoreData
    /**Delete**/
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
            print("DEBUG: Successfully fetch \(action) from Coredata \(data.count)")
//            let deleteD = data.filter({$0.time! == time})
            for data in data {
                context.delete(data)
            }
            do {
                try context.save()
            } catch {
                print("DEBUG: Error saving data after delete \(action)")
            }
        } catch {
            print("DEBUG: Error fetching \(action) from Coredata \(error.localizedDescription)")
        }
    }
    
    //MARK: - Delete specific set from CoreData
    /**Delete**/
    func deleteSpecificSetFromCoredata(id: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        request.predicate = NSPredicate(format: "id LIKE %@", id)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        do {
            let data = try context.fetch(request)
            print("DEBUG: Should delete \(data)")
            for data in data {
                context.delete(data)
            }
            do {
                try context.save()
            } catch {
                print("DEBUG: Error saving data after delete")
            }
        } catch {
            print("DEBUG: Error fetching \(id) of data from Coredata \(error.localizedDescription)")
        }
        
    }
    
    //MARK: - Delete uncheck expired exercise to save disk space
    /**Delete**/
    func deletExpiredData() {
        print("DEBUG: delete epired data")
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
//        let context = appDelegate.persistentContainer.viewContext
//        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
    }
    
    
}
