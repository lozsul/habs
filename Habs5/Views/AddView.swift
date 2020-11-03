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
                    HStack(spacing: 2) {
                        ForEach(0..<templateDays.count, id: \.self) { index in
                            Text(self.templateDays[index]).onTapGesture {
                                self.templateValues[index] = self.templateValues[index] == 1 ? 0 : 1
                            }
                            .font(.footnote)
                            .frame(width: 40, height: 40)
                            .background(Circle().fill(self.colors[self.templateValues[index]]))
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                    }
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
                        let dayController = DayController()
                        dayController.addDays(moc: self.moc, habit: newHabit)
                        
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
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
