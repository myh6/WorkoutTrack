//
//  LocalFeedStore.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//
import Foundation
/// Blueprint for future implementation. Can used by different framework without coupling implenmentation details with Domain Details.
public protocol DetailAdditionStore {
    typealias Result = Swift.Result<Void, Error>
    
    func add(details: [DetailedDTO], toActionWithID actionID: UUID, completion: @escaping (Result) -> Void)
}
