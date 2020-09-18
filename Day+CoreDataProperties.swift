//
//  Day+CoreDataProperties.swift
//  Habs5
//
//  Created by Lauren Sullivan on 9/2/20.
//  Copyright © 2020 Lauren Sullivan. All rights reserved.
//
//

import Foundation
import CoreData


extension Day: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date
    @NSManaged public var value: Int16
    @NSManaged public var short: String?
    @NSManaged public var habit: Habit?
    
    public var wrappedShort: String {
        short ?? "NA"
    }
}
