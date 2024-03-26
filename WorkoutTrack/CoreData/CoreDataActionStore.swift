//
//  CoreDataActionStore.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/25.
//

import CoreData

public final class CoreDataActionStore: ActionRetrievalStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "WorkoutTrack2", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func retrieve(predicate: NSPredicate?, completion: @escaping (ActionRetrievalStore.Result) -> Void) {
        perform { context in
            completion(Result{
                return try Action2.find(in: context, with: predicate).map { $0.toDomain() }
            })
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
 
