//
//  WeekView.swift
//  Habs5
//
//  Created by Lauren Sullivan on 9/24/20.
//  Copyright © 2020 Lauren Sullivan. All rights reserved.
//

import SwiftUI

struct WeekView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var habit: Habit

    var body: some View {
        HStack {
            // Showing the LAST 7 days in the array of days of each habit
            ForEach((habit.dayArray.count >= 7 ? habit.dayArray.count-7 : 0)..<habit.dayArray.count, id: \.self) { index in
                DayView(day: self.habit.dayArray[index], habit: self.habit)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(habit: Habit())
    }
}
