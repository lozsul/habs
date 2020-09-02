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

}
