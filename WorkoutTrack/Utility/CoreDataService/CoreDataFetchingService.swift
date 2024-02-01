//
//  CoreDataFetchingService.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/1.
//
import CoreData
import Foundation
import UIKit

final class CoreDataFetchingService {
    static let shared = CoreDataFetchingService()
    
    // Get all data from CoreData
    func getAllDataFromCoredata(completion: @escaping ([Detail]?, Error?) -> Void) {
        var details = [Detail]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        do {
            details = try context.fetch(request)
            completion(details, nil)
        } catch {
            Log.error("DEBUG: Error fetching data from Coredata", error)
            completion(nil, error)
        }
    }

    func getCustomActionFromCoredata(ofType: String, completion: @escaping ([String]?, Error?) -> Void) {
        var fetchData = [CustomAction]()
        var output = [String]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<CustomAction> = CustomAction.fetchRequest()
        request.predicate = NSPredicate(format: "ofType LIKE %@", ofType)
        do {
            fetchData = try context.fetch(request)
            for data in fetchData {
                guard data.actionName != nil else {return}
                output.append(data.actionName!)
            }
            completion(output, nil)
        } catch {
            completion(nil, error)
        }
    }
    
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
            Log.error("DEBUG: Error fetching today data from Coredata", error)
            completion(nil, error)
        }
    }
    
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
                
                Log.info("DEBUG: get \(date) data from Coredata - \(detail)")
                
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
            Log.error("DEBUG: Error fetching today data from Coredata", error)
            completion(nil, error)
        }
    }
    
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
                
                Log.info("DEBUG: get \(date) data from Coredata - \(detail)")
                
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
            Log.error("DEBUG: Error fetching today data from Coredata", error)
            completion(nil, error)
        }
    }
    
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
            Log.error("DEBUG: getHistoryDataOfSpecificExercise Error fetching data", error)
            completion(nil, error)
        }
    }
    
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
            Log.error("DEBUG: Error retriving data allDatehaveData", error)
        }
        return outputDate
    }
    
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
            Log.error("DEBUG: checkDateHaveData Error retriving data.")
            return nil
        }
    }
    
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
        Log.info("DEBUG: \(weeks)")
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
            return details.count
        } catch {
            Log.error("DEBUG: Error retriving data in getNumberOfsetinThisWeek from CoreData", error)
            return nil
        }
    }
    
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
            Log.error("DEBUG: getMaxWeight Error retriving data from Coredata", error)
        }
    }
    
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
            Log.error("DEBUG: getMaxWeight Error retriving data from Coredata", error)
        }
    }
    
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
            Log.error("DEBUG: Error getMaxWeightInHistory Error retriving data from CoreData", error)
        }
    }
}
