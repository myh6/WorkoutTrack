//
//  Action.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/25.
//

import CoreData

@objc(Action2)
class Action2: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var isOpen: Bool
    @NSManaged var name: String
    @NSManaged var ofType: String
    
    @NSManaged var details: NSOrderedSet?
}

extension Action2 {
    
    private var detailSet: NSOrderedSet {
        get { return details ?? NSOrderedSet() }
        set { details = newValue }
    }
    
    static func find(in context: NSManagedObjectContext, with predicate: NSPredicate?) throws -> [Action2] {
        let request = NSFetchRequest<Action2>(entityName: entity().name!)
        request.predicate = predicate
        return try context.fetch(request)
    }
    
    static func createNewAction(from actionDTO: ActionDTO, in context: NSManagedObjectContext) -> Action2 {
        let newAction = Action2(context: context)
        newAction.id = actionDTO.id
        newAction.isOpen = actionDTO.isOpen
        newAction.name = actionDTO.actionName
        newAction.ofType = actionDTO.typeName
        
        newAction.detailSet = Detail2.createDetails(from: actionDTO.details, forAction: newAction, in: context)
        return newAction
    }
    
    public func toDomain() -> ActionDTO {
        let detailsDTO: [DetailedDTO] = detailSet.array.compactMap { detail in
            guard let detail = detail as? Detail2 else { return nil }
            return DetailedDTO(uuid: detail.id, weight: detail.weight, isDone: detail.isDone, reps: Int(detail.reps), time: detail.time)
        }
        return ActionDTO(id: id, actionName: name, typeName: ofType, isOpen: isOpen, details: detailsDTO)
    }
}

@objc(Detail2)
class Detail2: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var isDone: Bool
    @NSManaged var reps: Int16
    @NSManaged var time: Date
    @NSManaged var weight: Float
    
    @NSManaged var ofAction: Action2
}

extension Detail2 {
    static func createDetails(from detailsDTOs: [DetailedDTO], forAction action: Action2, in context: NSManagedObjectContext) -> NSOrderedSet {
        let details = detailsDTOs.map { detailDTO -> Detail2 in
            let detail = Detail2(context: context)
            detail.id = detailDTO.uuid
            detail.isDone = detailDTO.isDone
            detail.reps = Int16(detailDTO.reps)
            detail.weight = detailDTO.weight
            detail.time = detailDTO.time
            detail.ofAction = action
            return detail
        }
        return NSOrderedSet(array: details)
    }
    
    static func find(in context: NSManagedObjectContext, with predicate: NSPredicate?) throws -> [Detail2] {
        let request = NSFetchRequest<Detail2>(entityName: entity().name!)
        request.predicate = predicate
        return try context.fetch(request)
    }
    
    public func toDTO() -> DetailedDTO {
        return DetailedDTO(uuid: id, weight: weight, isDone: isDone, reps: Int(reps), time: time)
    }
}

@objc(CustomAction2)
class CustomAction2: NSManagedObject {
}
