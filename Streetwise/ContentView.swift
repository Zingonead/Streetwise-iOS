//
//  ContentView.swift
//  Streetwise
//
//  Created by Adriano Zingone on 06/07/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showSplash = false
                            }
                        }
                    }
            } else if authManager.isAuthenticated {
                MainTabView()
            } else {
                AuthenticationFlow()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationManager())
}
