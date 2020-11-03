//
//  SettingsView.swift
//  Habs5
//
//  Created by Lauren Sullivan on 10/9/20.
//  Copyright © 2020 Lauren Sullivan. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    // Adding a local property to save & delete the Core Data managed object context.
    @Environment(\.managedObjectContext) var moc
    
    // States for showing the badge count of incomplete habits for the day
    @State private var authRequested = UserDefaults.standard.bool(forKey: "authRequested")
    @State private var authDenied = UserDefaults.standard.bool(forKey: "authDenied")
    @State private var badgeOn = UserDefaults.standard.bool(forKey: "badgeOn")
    @State private var alertShow = false
    @State private var toggleOn = false
    
    // Fetch habits for functions like resetDays()
    @FetchRequest(entity: Habit.entity(),sortDescriptors: [
        NSSortDescriptor(keyPath: \Habit.todayValue, ascending: true),
        NSSortDescriptor(keyPath: \Habit.title, ascending: true)
    ]) var habits: FetchedResults<Habit>
    
    var body: some View {
        Form {
            
            Section {
                Toggle("Allow badge notification?", isOn: $toggleOn)
                .onReceive([self.toggleOn].publisher.first()) { value in
                    scheduleNotifications(value: value)
                }
                .alert(isPresented: $alertShow) {
                    Alert(title: Text("Important"), message: Text("Please enable notificaions in Settings > Habs > Notifications"))
                }
            }
            
            Section {
                Button(action: {
                    let dayController = DayController()
                    dayController.resetDays(moc: moc, habits: self.habits)
                }) {
                    Text("Reset All Habits")
                }
            }
        }
        
        // Simply getting info on whether badges/notifications are authorized or not and making the badge button appear on or off depending on that
        // !! Needs to be adjusted - what if badge is authorized but they decide they don't want it so turn it off, this would override that. Can we simply change to badgeDenied? No, if badgeDenied is
        .onAppear(perform: {
            toggleOn = (authDenied == false && badgeOn == true)
        })
    }
    
    // Function to ask user to allow a badge
    func scheduleNotifications(value: Bool) {
        
        // Only run first time - save authDenied to know whether to prompt manual activation
        if value == true && authRequested == false {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { success, error in
                if success == true {
                    UserDefaults.standard.set(false, forKey: "authDenied")
                } else {
                    UserDefaults.standard.set(true, forKey: "authDenied")
                }
                
                UserDefaults.standard.set(true, forKey: "authRequested")
            }
        }
        
        // Run every time
        if value == false {
            print(badgeOn)
            badgeOn = false
            UserDefaults.standard.set(badgeOn, forKey: "badgeOn")
            print(badgeOn)
        } else {
            // If auth, allow set to true
            if (authDenied == false) {
                badgeOn = true
                UserDefaults.standard.set(badgeOn, forKey: "badgeOn")
            } else {
                alertShow = true
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
