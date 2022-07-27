//
//  AppConfig.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2022/6/12.
//

import Foundation

enum Environment {
    case debug
    case release
}

class AppConfig {
    
    static let target = getTarget()
    private static func getTarget() -> Environment {
        #if DEBUG
        return Environment.debug
        #else
        return Environment.release
        #endif
    }
    
}
