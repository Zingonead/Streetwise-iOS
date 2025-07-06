import SwiftUI
import Combine

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var hasCompletedInterestSelection = false
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        checkAuthenticationStatus()
    }
    
    func checkAuthenticationStatus() {
        // Check if user is already authenticated (from Keychain or UserDefaults)
        let isAuth = UserDefaults.standard.bool(forKey: "isAuthenticated")
        let hasInterests = UserDefaults.standard.bool(forKey: "hasCompletedInterestSelection")
        
        DispatchQueue.main.async {
            self.isAuthenticated = isAuth
            self.hasCompletedInterestSelection = hasInterests
        }
    }
    
    func signIn(email: String, password: String) {
        isLoading = true
        
        // Simulate authentication
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            
            // Mock successful authentication
            let mockUser = User(
                id: "1",
                email: email,
                username: "johndoe",
                displayName: "John Doe",
                profileImageURL: nil,
                bio: "Explorer of new places",
                location: "San Francisco, CA",
                interests: [],
                friendsCount: 156,
                postsCount: 125,
                placesCount: 89
            )
            
            self.currentUser = mockUser
            self.isAuthenticated = true
            
            UserDefaults.standard.set(true, forKey: "isAuthenticated")
        }
    }
    
    func signInWithGoogle() {
        isLoading = true
        
        // Simulate Google authentication
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.isAuthenticated = true
            UserDefaults.standard.set(true, forKey: "isAuthenticated")
        }
    }
    
    func signInWithInstagram() {
        isLoading = true
        
        // Simulate Instagram authentication
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.isAuthenticated = true
            UserDefaults.standard.set(true, forKey: "isAuthenticated")
        }
    }
    
    func completeInterestSelection(interests: [Interest]) {
        hasCompletedInterestSelection = true
        currentUser?.interests = interests
        UserDefaults.standard.set(true, forKey: "hasCompletedInterestSelection")
    }
    
    func signOut() {
        isAuthenticated = false
        hasCompletedInterestSelection = false
        currentUser = nil
        
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
        UserDefaults.standard.set(false, forKey: "hasCompletedInterestSelection")
    }
}

struct User: Identifiable {
    let id: String
    let email: String
    let username: String
    let displayName: String
    let profileImageURL: String?
    let bio: String
    let location: String
    var interests: [Interest]
    let friendsCount: Int
    let postsCount: Int
    let placesCount: Int
}

struct Interest: Identifiable {
    let id: String
    let name: String
    let emoji: String
    let category: String
}

extension Interest {
    static let allInterests = [
        Interest(id: "music", name: "Music", emoji: "🎵", category: "Entertainment"),
        Interest(id: "food", name: "Food", emoji: "🍽️", category: "Dining"),
        Interest(id: "sports", name: "Sports", emoji: "⚽", category: "Fitness"),
        Interest(id: "arts", name: "Arts", emoji: "🎭", category: "Culture"),
        Interest(id: "shopping", name: "Shopping", emoji: "🛍️", category: "Retail"),
        Interest(id: "culture", name: "Culture", emoji: "🎨", category: "Arts"),
        Interest(id: "travel", name: "Travel", emoji: "✈️", category: "Adventure"),
        Interest(id: "nightlife", name: "Nightlife", emoji: "🌙", category: "Entertainment"),
        Interest(id: "photography", name: "Photography", emoji: "📸", category: "Creative"),
        Interest(id: "events", name: "Events", emoji: "🎪", category: "Social"),
        Interest(id: "gaming", name: "Gaming", emoji: "🎮", category: "Entertainment"),
        Interest(id: "wellness", name: "Wellness", emoji: "🧘", category: "Health")
    ]
}