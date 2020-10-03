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
    
    // To save the title of the habit to then add to new habit in Core Data. Must use @State so we can change the variable, but using @State means we can only use this variable in this view. Always add private to @State as this is what Apple recommends and simply re-inforces the local nature of @State. Every time @State is changed/updated, the view is re-rendered.
    @State private var title = ""
    
    // Adding validation so that you can't save a habit that has no title
    var isValid: Bool {
        if title.isEmpty {
            return false
        }
        return true
    }
    
    let colors = [ColorManager.lightGray, ColorManager.armyGreen]
    let templateDays = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    @State var templateValues = [1, 1, 1, 1, 1, 1, 1]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Habit title", text: $title)
                        .keyboardType(.default)
                }
                
                Section(header: Text("Which days?")) {
                    HStack {
                        ForEach(0..<templateDays.count, id: \.self) { index in
                            Text(self.templateDays[index]).onTapGesture {
                                self.templateValues[index] = self.templateValues[index] == 1 ? 0 : 1
                            }
                            .font(.footnote)
                            .frame(width: 42, height: 42)
                            .background(Circle().fill(self.colors[self.templateValues[index]]))
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Section {
                    
                    // Saving the new habit to Core Data
                    Button("Save") {
                        let newHabit = Habit(context: self.moc)
                        newHabit.id = UUID()
                        newHabit.title = self.title
                        
                        // Set template
                        newHabit.isSu = Int16(self.templateValues[0])
                        newHabit.isMo = Int16(self.templateValues[1])
                        newHabit.isTu = Int16(self.templateValues[2])
                        newHabit.isWe = Int16(self.templateValues[3])
                        newHabit.isTh = Int16(self.templateValues[4])
                        newHabit.isFr = Int16(self.templateValues[5])
                        newHabit.isSa = Int16(self.templateValues[6])
                        
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
            .navigationBarTitle("Add New Habit", displayMode: .inline)
        }
    }
    
    // Function to add the last 7 days to a new habit
    func addDays(newHabit: Habit) {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        
        let day0 = Day(context: self.moc)
        day0.date = Date()
        day0.short = String(formatter.string(from: day0.date).prefix(2))
        day0.habit = newHabit
        
        // Set current day based on template
        switch day0.short {
        case "Su":
            day0.value = newHabit.isSu == 1 ? 0 : 3
        case "Mo":
            day0.value = newHabit.isMo == 1 ? 0 : 3
        case "Tu":
            day0.value = newHabit.isTu == 1 ? 0 : 3
        case "We":
            day0.value = newHabit.isWe == 1 ? 0 : 3
        case "Th":
            day0.value = newHabit.isTh == 1 ? 0 : 3
        case "Fr":
            day0.value = newHabit.isFr == 1 ? 0 : 3
        case "Sa":
            day0.value = newHabit.isSa == 1 ? 0 : 3
        default:
            day0.value = 0
        }
        day0.value = 0
        
        // Set today's value based on template
        newHabit.todayValue = day0.value
        
        let dayMinus1 = Day(context: self.moc)
        dayMinus1.date = Date().addingTimeInterval(-(1*86400))
        dayMinus1.value = 3
        dayMinus1.short = String(formatter.string(from: dayMinus1.date).prefix(2))
        dayMinus1.habit = newHabit
        
        let dayMinus2 = Day(context: self.moc)
        dayMinus2.date = Date().addingTimeInterval(-(2*86400))
        dayMinus2.value = 3
        dayMinus2.short = String(formatter.string(from: dayMinus2.date).prefix(2))
        dayMinus2.habit = newHabit
        
        let dayMinus3 = Day(context: self.moc)
        dayMinus3.date = Date().addingTimeInterval(-(3*86400))
        dayMinus3.value = 3
        dayMinus3.short = String(formatter.string(from: dayMinus3.date).prefix(2))
        dayMinus3.habit = newHabit
        
        let dayMinus4 = Day(context: self.moc)
        dayMinus4.date = Date().addingTimeInterval(-(4*86400))
        dayMinus4.value = 3
        dayMinus4.short = String(formatter.string(from: dayMinus4.date).prefix(2))
        dayMinus4.habit = newHabit
        
        let dayMinus5 = Day(context: self.moc)
        dayMinus5.date = Date().addingTimeInterval(-(5*86400))
        dayMinus5.value = 3
        dayMinus5.short = String(formatter.string(from: dayMinus5.date).prefix(2))
        dayMinus5.habit = newHabit
        
        let dayMinus6 = Day(context: self.moc)
        dayMinus6.date = Date().addingTimeInterval(-(6*86400))
        dayMinus6.value = 3
        dayMinus6.short = String(formatter.string(from: dayMinus6.date).prefix(2))
        dayMinus6.habit = newHabit
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
