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
    
    @NSManaged var details: NSSet?
}

extension Action2 {
    
    var detailSet: Set<Detail> {
        get { details as? Set<Detail> ?? [] }
        set { details = NSSet(set: newValue) }
    }
    
    static func find(in context: NSManagedObjectContext, with predicate: NSPredicate?) throws -> [Action2] {
        let request = NSFetchRequest<Action2>(entityName: entity().name!)
        request.predicate = predicate
        return try context.fetch(request)
    }
    
    #warning("Wrong model for ActionFeed")
    public func toDomain() -> ActionFeed {
        return ActionFeed(actionName: name, typeName: ofType)
    }
}

@objc(Detail2)
class Detail2: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var isDone: Bool
    @NSManaged var reps: Int16
    @NSManaged var time: String
    @NSManaged var weight: Float
    
    @NSManaged var ofAction: Action
}

@objc(CustomAction2)
class CustomAction2: NSManagedObject {
}
