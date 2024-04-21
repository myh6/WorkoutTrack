//
//  CoreDataActionStore.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/25.
//

import CoreData

public typealias ActionStore = ActionRetrievalStore & ActionAdditionStore & ActionRemovalStore
public final class CoreDataStore: ActionStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "WorkoutTrack2", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func retrieve(predicate: NSPredicate?, completion: @escaping (ActionRetrievalStore.Result) -> Void) {
        perform { context in
            completion(Result {
                return try Action2.find(in: context, with: predicate).map { $0.toDomain() }
            })
        }
    }
    
    public func addAction(action: [ActionDTO], completion: @escaping (ActionAdditionStore.Result) -> Void) {
        perform { context in
            completion(Result {
                _ = action.map { Action2.createNewAction(from: $0, in: context) }
                try context.save()
            })
        }
    }
    
    public func remove(actionID: UUID, completion: @escaping (ActionRemovalStore.Result) -> Void) {
        perform { context in
            completion(Result{
                let predicate = NSPredicate(format: "id == %@", actionID as CVarArg)
                _ = try Action2.find(in: context, with: predicate).map(context.delete).map(context.save)
            })
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
 
extension CoreDataStore: DetailRetrievalStore {
    public func retrieve(predicate: NSPredicate?, completion: @escaping (DetailRetrievalStore.Result) -> Void) {
        perform { context in
            completion(Result {
                return try Detail2.find(in: context, with: predicate).map { $0.toDTO() }
            })
        }
    }
}
#warning("Duplicate details and action??")
extension CoreDataStore: DetailAdditionStore {
    public func add(details: [DetailedDTO], toActionWithID actionID: UUID, completion: @escaping (DetailAdditionStore.Result) -> Void) {
        perform { context in
            completion(Result {
                let predicate = NSPredicate(format: "id == %@", actionID as CVarArg)
                let action = try Action2.find(in: context, with: predicate).first
                if let action = action {
                    let newDetails = Detail2.createDetails(from: details, forAction: action, in: context)
                    
                    let updatedDetails = action.details?.mutableCopy() as? NSMutableOrderedSet
                    updatedDetails?.union(newDetails)
                    action.details = updatedDetails
                    try context.save()
                }
            })
        }
    }
}

extension CoreDataStore: DetailRemovalStore {
    public func remove(details: [DetailedDTO], completion: @escaping (DetailRemovalStore.Result) -> Void) {
        perform { context in
            completion(Result{
                let ids = details.map { $0.uuid } as [UUID]
                let predicate = NSPredicate(format: "id IN %@", ids as CVarArg)
                _ = try Detail2.find(in: context, with: predicate).map(context.delete).map(context.save)
            })
        }
    }
}
