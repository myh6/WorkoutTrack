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
    
    private var detailSet: Set<Detail2> {
        get { return Set(details?.array as? [Detail2] ?? []) }
        set { details = NSOrderedSet(array: Array(newValue)) }
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
        
        let detailsSet = Detail2.createDetails(from: actionDTO.details, forAction: newAction, in: context)
        newAction.detailSet = detailsSet
        return newAction
    }
    
    public func toDomain() -> ActionDTO {
        let detailsDTO = detailSet.map {
            DetailedDTO(uuid: $0.id, weight: $0.weight, isDone: $0.isDone, reps: Int($0.reps))
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
    static func createDetails(from details: [DetailedDTO], forAction action: Action2, in context: NSManagedObjectContext) -> Set<Detail2> {
        var detailsSet = Set<Detail2>()
        for detailDTO in details {
            let detail = Detail2(context: context)
            detail.id = detailDTO.uuid
            detail.isDone = detailDTO.isDone
            detail.reps = Int16(detailDTO.reps)
            detail.weight = detailDTO.weight
            detail.time = Date()
            detail.ofAction = action
            detailsSet.insert(detail)
        }
        return detailsSet
    }
}

@objc(CustomAction2)
class CustomAction2: NSManagedObject {
}
