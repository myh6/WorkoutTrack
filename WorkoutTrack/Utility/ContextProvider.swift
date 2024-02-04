//
//  ContextProvider.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//
import CoreData
import UIKit

public protocol ContextProviding {
    var context: NSManagedObjectContext { get }
}

final class ContextProvider: ContextProviding {
    var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate is unavailable.")
        }
        return appDelegate.persistentContainer.viewContext
    }
}

