//
//  personalToDoApp.swift
//  personalToDo
//
//  Created by Raphael Palacio on 2/10/25.
//

import SwiftUI

@main
struct personalToDoApp: App {
    @StateObject private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                MainView()
            } else {
                LoginView()
            }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
