//
//  LoadResult.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/24.
//

public enum LoadResult {
    case success([Detailed])
    case failure(Error)
}
