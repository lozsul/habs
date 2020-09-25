//
//  AddView.swift
//  Habs5
//
//  Created by Lauren Sullivan on 8/27/20.
//  Copyright © 2020 Lauren Sullivan. All rights reserved.
//

import SwiftUI

struct AddView: View {
    
    // Adding a local property to save & delete the Core Data managed object context.
    @Environment(\.managedObjectContext) var moc
    
    // To show this view in presentationMode so that it's simple for the user to dismiss it = best for views where you want to dismiss the view when something happens (user clicks button)
    @Environment(\.presentationMode) var presentationMode
    
    // To save the title of the habit to then add to new habit in Core Data
    @State private var title = ""
    
    // Adding validation so that you can't save a habit that has no title
    var isValid: Bool {
        if title.isEmpty {
            return false
        }
        return true
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Habit title", text: $title)
                        .keyboardType(.default)
                }
                
                Section {
                    
                    // Saving the new habit to Core Data
                    Button("Save") {
                        let newHabit = Habit(context: self.moc)
                        newHabit.title = self.title
                        newHabit.todayValue = 0
                        newHabit.id = UUID()
                        
                        // Passing this newly created habit to the addDays function to run so that the last 7 days are added for new habits
                        self.addDays(newHabit: newHabit)
                        
                        // Saving to Core Data
                        try? self.moc.save()
                        
                        // This dismisses this view and takes us back to ContentView
                        self.presentationMode.wrappedValue.dismiss()
                    }
                        
                    // Disables the "Save" button if the validation above is not met
                    .disabled(isValid == false)
                }
            }
            .navigationBarTitle("Add Habit", displayMode: .inline)
        }
    }
    
    // Function to add the last 7 days to a new habit
    func addDays(newHabit: Habit) {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        
        let day0 = Day(context: self.moc)
        day0.date = Date()
        day0.value = 0
        day0.short = String(formatter.string(from: day0.date).prefix(2))
        day0.habit = newHabit
        
        let dayMinus1 = Day(context: self.moc)
        dayMinus1.date = Date().addingTimeInterval(-(1*86400))
        dayMinus1.value = 0
        dayMinus1.short = String(formatter.string(from: dayMinus1.date).prefix(2))
        dayMinus1.habit = newHabit
        
        let dayMinus2 = Day(context: self.moc)
        dayMinus2.date = Date().addingTimeInterval(-(2*86400))
        dayMinus2.value = 0
        dayMinus2.short = String(formatter.string(from: dayMinus2.date).prefix(2))
        dayMinus2.habit = newHabit
        
        let dayMinus3 = Day(context: self.moc)
        dayMinus3.date = Date().addingTimeInterval(-(3*86400))
        dayMinus3.value = 0
        dayMinus3.short = String(formatter.string(from: dayMinus3.date).prefix(2))
        dayMinus3.habit = newHabit
        
        let dayMinus4 = Day(context: self.moc)
        dayMinus4.date = Date().addingTimeInterval(-(4*86400))
        dayMinus4.value = 0
        dayMinus4.short = String(formatter.string(from: dayMinus4.date).prefix(2))
        dayMinus4.habit = newHabit
        
        let dayMinus5 = Day(context: self.moc)
        dayMinus5.date = Date().addingTimeInterval(-(5*86400))
        dayMinus5.value = 0
        dayMinus5.short = String(formatter.string(from: dayMinus5.date).prefix(2))
        dayMinus5.habit = newHabit
        
        let dayMinus6 = Day(context: self.moc)
        dayMinus6.date = Date().addingTimeInterval(-(6*86400))
        dayMinus6.value = 0
        dayMinus6.short = String(formatter.string(from: dayMinus6.date).prefix(2))
        dayMinus6.habit = newHabit
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
