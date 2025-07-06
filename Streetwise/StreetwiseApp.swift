//
//  StreetwiseApp.swift
//  Streetwise
//
//  Created by Adriano Zingone on 06/07/2025.
//

import SwiftUI

@main
struct StreetwiseApp: App {
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .preferredColorScheme(.light)
        }
    }
}
