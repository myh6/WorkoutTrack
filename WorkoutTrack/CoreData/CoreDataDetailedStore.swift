//
//  CoreDataDetailedStore.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/3/28.
//

import CoreData

//public final class CoreDataDetailedStore: DetailRetrievalStore {
//    
//    private let container: NSPersistentContainer
//    private let context: NSManagedObjectContext
//    
//    public init(storeURL: URL, bundle: Bundle = .main) throws {
//        container = try NSPersistentContainer.load(modelName: "WorkoutTrack2", url: storeURL, in: bundle)
//        context = container.newBackgroundContext()
//    }
//        
//
//    
//    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
//        let context = self.context
//        context.perform { action(context) }
//    }
//}
