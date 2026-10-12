//
//  AssignmentApp.swift
//  Assignment
//
//  Created by Dipankar Bhakat on 12/10/26.
//

import SwiftUI

@main
struct AssignmentApp: App {
    @State private var securityManager = SecurityManager()

    var body: some Scene {
        WindowGroup {
            UserListView()
            .environment(securityManager)
        }
    }
}
