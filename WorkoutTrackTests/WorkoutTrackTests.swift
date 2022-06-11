//
//  WorkoutTrackTests.swift
//  WorkoutTrackTests
//
//  Created by Min-Yang Huang on 2022/4/23.
//
import Foundation
import XCTest
@testable import GYMHack
import CoreData

class WorkoutTrackTests: XCTestCase {
        
    func test_translation() {
        let exercise = "機械式坐姿卷腹"
        XCTAssertEqual(exercise, "Machine Crunch".localizeString(string: "zh-Hant"))
    }
    
    func test_getThisWeekDate() {
        let week = getThisWeekDate()
        XCTAssertEqual(week, ["2022/06/05","2022/06/06","2022/06/07","2022/06/08","2022/06/09","2022/06/10","2022/06/11"])
    }
    
    func test_CoreDataGetDataOutsideOfThisWeek() {
        var compoundPredicate: [NSPredicate] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Detail> = Detail.fetchRequest()
        let week = getThisWeekDate()
        for i in week.indices {
            compoundPredicate.append(NSPredicate(format: "time != %@", week[i]))
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: compoundPredicate)
        do {
            let details = try context.fetch(request)
            XCTAssertNotNil(details)
        } catch {
            
        }
    }
    
    fileprivate let now = Date()
    fileprivate let calendar = NSCalendar.current
    fileprivate let dateFormatter = DateFormatter()
    
    private func getThisWeekDate() -> [String] {
        let thisWeek = calendar.daysWithSameWeekOfYear(as: now)
        dateFormatter.dateFormat = "yyyy/MM/dd"
        var thisWeekDate: [String] = []
        for i in 0...thisWeek.count - 1 {
            thisWeekDate.append(dateFormatter.string(from: thisWeek[i]))
        }
        return thisWeekDate
    }

}
