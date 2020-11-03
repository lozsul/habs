//
//  DayController.swift
//  Habs5
//
//  Created by Lauren Sullivan on 10/30/20.
//  Copyright © 2020 Lauren Sullivan. All rights reserved.
//

import SwiftUI
import CoreData

struct DayController {
    func addDays(moc: NSManagedObjectContext, habit: Habit) {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        
        let day0 = Day(context: moc)
        day0.date = Date()
        day0.short = String(formatter.string(from: day0.date).prefix(2))
        day0.habit = habit
        
        // Set current day based on template
        switch day0.short {
        case "Su":
            day0.value = habit.isSu == 1 ? 0 : 3
        case "Mo":
            day0.value = habit.isMo == 1 ? 0 : 3
        case "Tu":
            day0.value = habit.isTu == 1 ? 0 : 3
        case "We":
            day0.value = habit.isWe == 1 ? 0 : 3
        case "Th":
            day0.value = habit.isTh == 1 ? 0 : 3
        case "Fr":
            day0.value = habit.isFr == 1 ? 0 : 3
        case "Sa":
            day0.value = habit.isSa == 1 ? 0 : 3
        default:
            day0.value = 0
        }
        
        // Set today's value based on template
        habit.todayValue = day0.value
        
        let dayMinus1 = Day(context: moc)
        dayMinus1.date = Date().addingTimeInterval(-(1*86400))
        dayMinus1.value = 3
        dayMinus1.short = String(formatter.string(from: dayMinus1.date).prefix(2))
        dayMinus1.habit = habit
        
        let dayMinus2 = Day(context: moc)
        dayMinus2.date = Date().addingTimeInterval(-(2*86400))
        dayMinus2.value = 3
        dayMinus2.short = String(formatter.string(from: dayMinus2.date).prefix(2))
        dayMinus2.habit = habit
        
        let dayMinus3 = Day(context: moc)
        dayMinus3.date = Date().addingTimeInterval(-(3*86400))
        dayMinus3.value = 3
        dayMinus3.short = String(formatter.string(from: dayMinus3.date).prefix(2))
        dayMinus3.habit = habit
        
        let dayMinus4 = Day(context: moc)
        dayMinus4.date = Date().addingTimeInterval(-(4*86400))
        dayMinus4.value = 3
        dayMinus4.short = String(formatter.string(from: dayMinus4.date).prefix(2))
        dayMinus4.habit = habit
        
        let dayMinus5 = Day(context: moc)
        dayMinus5.date = Date().addingTimeInterval(-(5*86400))
        dayMinus5.value = 3
        dayMinus5.short = String(formatter.string(from: dayMinus5.date).prefix(2))
        dayMinus5.habit = habit
        
        let dayMinus6 = Day(context: moc)
        dayMinus6.date = Date().addingTimeInterval(-(6*86400))
        dayMinus6.value = 3
        dayMinus6.short = String(formatter.string(from: dayMinus6.date).prefix(2))
        dayMinus6.habit = habit
    }
    
    func resetDays(moc: NSManagedObjectContext, habits: FetchedResults<Habit>) {
        for habit in habits {
            for day in habit.dayArray {
                moc.delete(day)
            }
            self.addDays(moc: moc, habit: habit)
        }
        try? moc.save()
    }
}

    

