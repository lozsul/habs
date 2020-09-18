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
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Habit.todayValue, ascending: true)
    ]) var habits: FetchedResults<Habit>
    
    // Adding this boolean variable for when to show AddView, have to use @State so we can change the variable, but using @State means we can only use this variable in this view. Always add private to @State as this is what Apple recommends and simply re-inforces the local nature of @State. Every time @State is changed/updated, the view is re-rendered.
    @State private var showingAddHabit = false
    
    var body: some View {
        // Adding NavigationView to be able to click through to the Add View, also gives us the header bar at the top to have a heading and Add/Edit buttons
        NavigationView {
            
            // VStack to make "some View" work, to hold all views within it
            VStack {
                List {
                    
                    // Using "id: \.self" instead of "id: \.id" because when I use the latter it shows the title of the last habit multiple times (over as many habits I have)
                    ForEach(habits, id: \.self) { habit in
                        VStack(alignment: .leading) {
                            Text(habit.title)
                                .padding(.bottom, 4)
                            HStack {
                                // Showing the LAST 7 days in the array of days of each habit
                                ForEach(habit.dayArray.count-7..<habit.dayArray.count, id: \.self) { index in
                                    DayView(day: habit.dayArray[index], habit: habit)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                        
                    // Refers to delete function below that will fully delete the habit from Core Data when the user swipes to delete
                    .onDelete(perform: deleteHabits)
                }
            }
                
            // When app is opened on phone, we want to run a function to add days if needed
            .onAppear(perform: self.loadDays)
                
            // NavigationBarTitle with inline displayMode so that it shows nicely in header instead of a massive heading under the header
            .navigationBarTitle(Text("Habs"), displayMode: .inline)
                
            // NavigationBarItems for Add/plus button on the right to add a new habit
                .navigationBarItems(trailing:
                Button(action: {
                    
                    // Changes showingAddHabit boolean to true if false so that Add View pops up
                    self.showingAddHabit.toggle()
                }) {
                    
                    // Using a plus system icon instead of text
                    Image(systemName: "plus")
                    // Adding a frame to it so that the area around the plus is clickable
                    .frame(width: 23, height: 23)
                    }
            )
                
                // Signalling that a new sheet called AddView is to pop up when showingAddHabit boolean is true, and passing through the environment/moc so that saving a new habit works
                .sheet(isPresented: self.$showingAddHabit) {
                AddView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    // Created new view to make the day value change dynamic
    struct DayView: View {
        @Environment(\.managedObjectContext) var moc
        @ObservedObject var day: Day   // !! @ObserveObject is the key!!!
        var habit: Habit   // !! @ObserveObject is the key!!!
        let colors = [ColorManager.lightGray, ColorManager.armyGreen, ColorManager.crimsonRed, ColorManager.darkGray]

        var body: some View {
            // Using alignment: .leading otherwise the habit title moves into the middle of the screen
            Text("\(day.wrappedShort)").onTapGesture {
                self.changeValue(day: self.day, habit: self.habit)
            }
            .font(.footnote)
            .frame(width: 42, height: 42)
            .background(self.colors[Int(self.day.value)])
            .buttonStyle(BorderlessButtonStyle())
            .foregroundColor(.white)
            .clipShape(Circle())
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
                print(habits[indexHabits].title)
                print(habits[indexHabits].todayValue)
                
                // Calculate number of days in between
                let totalHabitDays = habits[indexHabits].dayArray.count
                let lastDate = habits[indexHabits].dayArray[totalHabitDays-1].date
                let lastDateMidday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: lastDate)!
                let todayMidday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: today)!
                let diff = Calendar.current.dateComponents([.day], from: lastDateMidday, to: todayMidday)
                let days = diff.day!
                
                // For loop in REVERSE for that many days
                for indexDays in stride(from: days, to: 0, by: -1) {

                    // Adding a new day on each loop
                    let formatter = DateFormatter()
                    formatter.dateFormat = "E"

                    let newDay = Day(context: self.moc)
                    let newDate = todayMidday.addingTimeInterval(-(Double(indexDays-1)*86400))

                    newDay.date = newDate
                    newDay.value = 0
                    newDay.short = String(formatter.string(from: newDate).prefix(2))
                    newDay.habit = habits[indexHabits]
                    
                    // Check if today has a value other than zero
//                    let result = habits.sorted {
//                        $0.todayMidday.value > $1.todayMidday.value
//                    }
//
//                    print(result)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
