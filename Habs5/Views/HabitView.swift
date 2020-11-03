//
//  HabitView.swift
//  Habs5
//
//  Created by Lauren Sullivan on 9/24/20.
//  Copyright © 2020 Lauren Sullivan. All rights reserved.
//

import SwiftUI

// Created new view to make the day value change dynamic
struct HabitView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var habit: Habit
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(habit.title)
                .padding(.bottom, 1)
                .padding(.leading, 4)
            WeekView(habit: self.habit)
        }
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        HabitView(habit: Habit())
    }
}
