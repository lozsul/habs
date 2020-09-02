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
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
