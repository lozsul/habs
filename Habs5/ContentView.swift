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
    
    // Adding a FetchRequest to load all the Core Data results that match any criteria I specify (currently by id so that it shows each habit in the order as I added them. Then we can create & manage Core Data fetch requests automatically.
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Habit.id, ascending: true)]) var habits: FetchedResults<Habit>
    
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
                        Text(habit.title)
                    }
                        
                    // Refers to delete function below that will fully delete the habit from Core Data when the user swipes to delete
                    .onDelete(perform: deleteHabits)
                }
            }
                
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
                    }
            )
                
                // Signalling that a new sheet called AddView is to pop up when showingAddHabit boolean is true, and passing through the environment/moc so that saving a new habit works
                .sheet(isPresented: self.$showingAddHabit) {
                AddView().environment(\.managedObjectContext, self.moc)
            }
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
