//
//  LightLog.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2022/7/25.
//
import Foundation

enum Log {
    enum LogLevel {
        case info, warning, error
        fileprivate var prefix: String {
            switch self {
            case .info:
                return "INFO 👀"
            case .warning:
                return "WARN ⚠️"
            case .error:
                return "ALERT ❌"
            }
        }
    }
    
    struct Context {
        let file: String
        let function: String
        let line: Int
        var description: String {
            return "\((file as NSString).lastPathComponent): \(line) \(function)"
        }
    }
    
    static func info(_ str: String, shouldLogContext: Bool = true, file: String = #file,
                     function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog(level: .info, str: str, error: nil,
                      shouldLogContext: shouldLogContext, context: context)
    }
    
    static func warning(_ str: String, file: String = #file,
                        function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog(level: .warning, str: str, error: nil, shouldLogContext: true, context: context)
    }
    
    static func warning(_ str: String, _ error: Error, file: String = #file,
                        function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog(level: .warning, str: str, error: error, shouldLogContext: true, context: context)
    }
    
    static func error(_ str: String, file: String = #file,
                        function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog(level: .error, str: str, error: nil, shouldLogContext: true, context: context)
    }
    
    static func error(_ str: String, _ error: Error, file: String = #file,
                        function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog(level: .error, str: str, error: error, shouldLogContext: true, context: context)
    }
    
    fileprivate static func handleLog(level: LogLevel, str: String, error: Error?,
                                      shouldLogContext: Bool, context: Context) {
        let logComponents = ["[\(level.prefix)]", str]
        var fullString = logComponents.joined(separator: " ")
        if shouldLogContext {
            fullString += " ➜ \(context.description)"
        }
        if AppConfig.target == Environment.debug {
            print(fullString)
        }
    }
}
