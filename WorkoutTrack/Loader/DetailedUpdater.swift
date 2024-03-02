//
//  DetailedUpdater.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/1.
//

import Foundation

public protocol DetailedUpdater {
    func updateDetailed(_ detail: Detailed, completion: @escaping (Error?) -> Void)
}
