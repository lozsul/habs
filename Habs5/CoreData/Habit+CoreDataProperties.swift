//
//  Habit+CoreDataProperties.swift
//  Habs5
//
//  Created by Lauren Sullivan on 9/1/20.
//  Copyright © 2020 Lauren Sullivan. All rights reserved.
//
//

import Foundation
import CoreData

// Added Identifiable so that my list in ContentView can just work off "habits" instead of "habits, id: \.self".
extension Habit: Identifiable {

    @nonobjc public class func createfetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String
    @NSManaged public var todayValue: Int16
    @NSManaged public var lastUpdated: Date?
    
    @NSManaged public var isSu: Int16
    @NSManaged public var isMo: Int16
    @NSManaged public var isTu: Int16
    @NSManaged public var isWe: Int16
    @NSManaged public var isTh: Int16
    @NSManaged public var isFr: Int16
    @NSManaged public var isSa: Int16
    
    // Copied from hackingwithswift as I created the NSManagedObject subclass after wiring the relationship to day
    @NSManaged public var day: NSSet?
    
    // Converting the NSSet to a Set<Day> because the former is the older, Objective-C data type that is equivalent to Swift’s Set, but we can’t use it with SwiftUI’s ForEach. The latter is a Swift-native type where we know the types of its contents.
    // Need to adjust the set.sorted part as I don't need it sorted, but this was from an example I copied from hackingwithswift
    public var dayArray: [Day] {
        let set = day as? Set<Day> ?? []
        return set.sorted {
            $0.date < $1.date
        }
    }    
}

// Copied from hackingwithswift as I created the NSManagedObject subclass after wiring the relationship to day
// MARK: Generated accessors for day
extension Habit {
    
    @objc(addDayObject:)
    @NSManaged public func addToDay(_ value: Day)
    
    @objc(removeDayObject:)
    @NSManaged public func removeFromDay(_ value: Day)
    
    @objc(addDay:)
    @NSManaged public func addToDay(_ values: NSSet)
    
    @objc(removeDay:)
    @NSManaged public func removeFromDay(_ values: NSSet)
}
