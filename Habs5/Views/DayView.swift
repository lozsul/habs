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
    @State private var badgeOn = UserDefaults.standard.bool(forKey: "badgeOn")
    @ObservedObject var habit: Habit
    let colors = [ColorManager.lightGray, ColorManager.armyGreen, ColorManager.crimsonRed, ColorManager.darkGray]
    let colorsText = [Color.white, Color.white, Color.white, ColorManager.lightGray]

    var body: some View {
        // Using alignment: .leading otherwise the habit title moves into the middle of the screen
        Text("\(day.wrappedShort)").onTapGesture {
            self.changeValue(day: self.day, habit: self.habit)
        }
        .font(.footnote)
        .frame(width: 40, height: 40) // Use 40x40 to fit onto tested screens: iphone 8, 11, 11 Pro, 11 Max
        .background(Circle().fill(self.colors[Int(self.day.value)]))
        .buttonStyle(BorderlessButtonStyle())
        .foregroundColor(self.colorsText[Int(self.day.value)])
    }
    
    // Function to change the value on a day when tapped
    func changeValue(day: Day, habit: Habit) {
        let beforeValue = day.value
        
        if day.value < 3 {
            day.value = (day.value + 1)
        } else {
            day.value = 0
        }
        
        habit.lastUpdated = Date()
        
        let today = Date()
        if Calendar.current.compare(today, to: day.date, toGranularity: .day) == .orderedSame {
            habit.todayValue = day.value
            
            // Set app icon badge
            if badgeOn == true {
                let afterValue = habit.todayValue
                
                if beforeValue == 0 {
                    UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber - 1
                }
                
                if afterValue == 0 {
                    UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
                }
            } else {
               UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }

        try? self.moc.save()
        
        // Update % complete
        
        
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(day: Day(), habit: Habit())
    }
}
