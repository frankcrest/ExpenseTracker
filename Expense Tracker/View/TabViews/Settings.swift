//
//  Settings.swift
//  Expense Tracker
//
//  Created by Frank Chen on 2024-04-01.
//

import SwiftUI

struct Settings: View {
    
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("User Name") {
                    TextField("iJustine", text: $userName)
                }
                
                Section("App Lock") {
                    Toggle("Enable App Lock", isOn: $isAppLockEnabled)
                    
                    if isAppLockEnabled {
                        Toggle("Lock When AppGoesBackground", isOn: $lockWhenAppGoesBackground)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
}
