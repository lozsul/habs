//
//  ContentView.swift
//  Habs5
//
//  Created by Lauren Sullivan on 8/27/20.
//  Copyright © 2020 Lauren Sullivan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    // Adding a local property to save & delete the Core Data managed object context.
    @Environment(\.managedObjectContext) var moc
    
    // Adding a FetchRequest to load all the Core Data results that match any criteria I specify (currently by id so that it shows each habit in the order as I added them. Then we can create & manage Core Data fetch requests automatically. No mention of fetching the entity Day here because it knows the relationship exists.
    @FetchRequest(entity: Habit.entity(),sortDescriptors: [
        NSSortDescriptor(keyPath: \Habit.todayValue, ascending: true),
        NSSortDescriptor(keyPath: \Habit.title, ascending: true)
    ]) var habits: FetchedResults<Habit>
    
    let colors = [ColorManager.lightGray, ColorManager.armyGreen, ColorManager.crimsonRed, ColorManager.darkGray]
    
    var body: some View {
        // Adding NavigationView to be able to click through to the Add View, also gives us the header bar at the top to have a heading and Add/Edit buttons
        NavigationView {
            
            // VStack to make "some View" work, to hold all views within it
            VStack {
                
                List {
                    
                    // Using "id: \.self" instead of "id: \.id" because when I use the latter it shows the title of the last habit multiple times (over as many habits I have)
                    ForEach(habits, id: \.self) { habit in
                        HabitView(habit: habit)
                    }
                    
                        
                    // Refers to delete function below that will fully delete the habit from Core Data when the user swipes to delete
                    .onDelete(perform: deleteHabits)
                }
                .listStyle(PlainListStyle())
            }
            
            // When app is opened on phone, we want to run a function to add days if needed
            .onAppear(perform: loadDays)
            
            // When app is opened from the background, we want the loadDays function to run too
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                loadDays()
            }
                
            // NavigationBarTitle with inline displayMode so that it shows nicely in header instead of a massive heading under the header
            .navigationBarTitle(Text("\(success())%"), displayMode: .inline)
                
            // NavigationBarItems for Add/plus button on the right to add a new habit
            .navigationBarItems(
                leading: NavigationLink(destination: SettingsView().environment(\.managedObjectContext, self.moc)) {
                    Image(systemName: "person")
                        .frame(width: 30, height: 30)
                }
                ,
                trailing:
                NavigationLink(destination: AddView().environment(\.managedObjectContext, self.moc)) {
                    
                    // Using a plus system icon instead of text
                    Image(systemName: "plus")
                    // Adding a frame to it so that the area around the plus is clickable
                    .frame(width: 30, height: 30)
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Function to delete habit from Core Data. IndexSet is a method that can delete from a list of items.
    func deleteHabits(at offsets: IndexSet) {
        for offset in offsets {
            let habit = habits[offset]
            moc.delete(habit)
        }
        
        try? moc.save()
    }
    
    // Function to add any days since app was last opened
    func loadDays() {
        
        let today = Date()
        
        // Loop through all habits
        // Making sure there's at least 1 habit to loop through
        if habits.count > 0 {
            
            // Creating an index of the habits to loop through
            for indexHabits in 0...habits.count-1 {

                // Adding a habit.id in case one is not set already (fixing initial bug)
                if habits[indexHabits].id == nil {
                    habits[indexHabits].id = UUID()
                    try? self.moc.save()
                }
                
                // Calculate number of days in between
                let totalHabitDays = habits[indexHabits].dayArray.count
                let lastDate = habits[indexHabits].dayArray[totalHabitDays-1].date
                let lastDateMidday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: lastDate)!
                let todayMidday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: today)!
                let diff = Calendar.current.dateComponents([.day], from: lastDateMidday, to: todayMidday)
                let days = diff.day!
                
                // For loop in REVERSE for that many days (why reverse?)
                for indexDays in stride(from: days, to: 0, by: -1) {

                    // Adding a new day on each loop
                    let formatter = DateFormatter()
                    formatter.dateFormat = "E"

                    let newDay = Day(context: self.moc)
                    let newDate = todayMidday.addingTimeInterval(-(Double(indexDays-1)*86400))

                    newDay.date = newDate
                    newDay.short = String(formatter.string(from: newDate).prefix(2))
                    newDay.habit = habits[indexHabits]
                    
                    // Set current day based on template
                    switch newDay.short {
                    case "Su":
                        newDay.value = habits[indexHabits].isSu == 1 ? 0 : 3
                    case "Mo":
                        newDay.value = habits[indexHabits].isMo == 1 ? 0 : 3
                    case "Tu":
                        newDay.value = habits[indexHabits].isTu == 1 ? 0 : 3
                    case "We":
                        newDay.value = habits[indexHabits].isWe == 1 ? 0 : 3
                    case "Th":
                        newDay.value = habits[indexHabits].isTh == 1 ? 0 : 3
                    case "Fr":
                        newDay.value = habits[indexHabits].isFr == 1 ? 0 : 3
                    case "Sa":
                        newDay.value = habits[indexHabits].isSa == 1 ? 0 : 3
                    default:
                        newDay.value = 0
                    }
                    
                    // Reset todayValue to 0
                    habits[indexHabits].todayValue = newDay.value
                }
            }
        }
        
        // Set app icon badge
        if UserDefaults.standard.bool(forKey: "badgeOn") == true {
            var count = 0
            for habit in habits {
                if habit.todayValue == 0  {
                    count += 1
                }
            }
            UIApplication.shared.applicationIconBadgeNumber = count
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    func success() -> Int {
        var complete = 0
        var incomplete = 0
        for indexHabits in 0...habits.count-1 {
            for indexDays in ((habits[indexHabits].dayArray.count >= 7 ? habits[indexHabits].dayArray.count-7 : 0)..<habits[indexHabits].dayArray.count) {
                if habits[indexHabits].dayArray[indexDays].value == 1 {
                    complete += 1
                } else if habits[indexHabits].dayArray[indexDays].value != 3 {
                    incomplete += 1
                }
            }
        }
        return Int(round(Double(complete)/Double(complete+incomplete)*100))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
