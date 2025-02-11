//
//  personalToDoApp.swift
//  personalToDo
//
//  Created by Raphael Palacio on 2/10/25.
//

import SwiftUI

@main
struct personalToDoApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
