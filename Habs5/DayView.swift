//
//  DayView.swift
//  Habs5
//
//  Created by Lauren Sullivan on 9/24/20.
//  Copyright © 2020 Lauren Sullivan. All rights reserved.
//

import SwiftUI

struct DayView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var day: Day
    var habit: Habit
    let colors = [ColorManager.lightGray, ColorManager.armyGreen, ColorManager.crimsonRed, ColorManager.darkGray]

    var body: some View {
        // Using alignment: .leading otherwise the habit title moves into the middle of the screen
        Text("\(day.wrappedShort)").onTapGesture {
            self.changeValue(day: self.day, habit: self.habit)
        }
        .font(.footnote)
        .frame(width: 42, height: 42)
        .background(Circle().fill(self.colors[Int(self.day.value)]))
        .buttonStyle(BorderlessButtonStyle())
        .foregroundColor(.white)
    }
    
    // Function to change the value on a day when tapped
    func changeValue(day: Day, habit: Habit) {
        if day.value < 3 {
            day.value = (day.value + 1)
        } else {
            day.value = 0
        }
        
        let today = Date()
        if Calendar.current.compare(today, to: day.date, toGranularity: .day) == .orderedSame {
            habit.todayValue = day.value
        }

        try? self.moc.save()
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(day: Day(), habit: Habit())
    }
}
