import Foundation
import CoreLocation

struct Event: Identifiable {
    let id: String
    let title: String
    let description: String
    let categoryEmoji: String
    let coordinate: CLLocationCoordinate2D
    let distance: String
    let attendeeCount: Int
    let isJoined: Bool
    let timestamp: Date
}

struct Friend: Identifiable {
    let id: String
    let username: String
    let displayName: String
    let profileImageURL: String
    let isOnline: Bool
    let lastSeen: Date?
    let mutualFriends: Int
}

struct HomeFeedItem: Identifiable {
    let id: String
    let sectionTitle: String
    let title: String
    let subtitle: String?
    let imageURL: String
    let distance: String?
    let timestamp: String?
    let type: FeedItemType
}

enum FeedItemType {
    case nearbyEvent
    case friendActivity
    case recommendation
    case achievement
}

struct Post: Identifiable {
    let id: String
    let author: Friend
    let content: String
    let imageURL: String?
    let videoURL: String?
    let location: String?
    let timestamp: Date
    let likeCount: Int
    let commentCount: Int
    let isLiked: Bool
    let isBookmarked: Bool
}

struct Notification: Identifiable {
    let id: String
    let type: NotificationType
    let title: String
    let subtitle: String
    let timestamp: Date
    let isRead: Bool
    let relatedUser: Friend?
    let relatedPost: Post?
}

enum NotificationType {
    case like
    case comment
    case friendRequest
    case mention
    case achievement
    case event
}

struct MockData {
    static let friends = [
        Friend(
            id: "1",
            username: "maria_explorer",
            displayName: "Maria Santos",
            profileImageURL: "https://images.unsplash.com/photo-1494790108755-2616b612b1dc?w=150&h=150&fit=crop&crop=face",
            isOnline: true,
            lastSeen: nil,
            mutualFriends: 12
        ),
        Friend(
            id: "2",
            username: "alex_photo",
            displayName: "Alex Johnson",
            profileImageURL: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
            isOnline: false,
            lastSeen: Date().addingTimeInterval(-3600),
            mutualFriends: 8
        ),
        Friend(
            id: "3",
            username: "sarah_adventures",
            displayName: "Sarah Kim",
            profileImageURL: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
            isOnline: true,
            lastSeen: nil,
            mutualFriends: 15
        )
    ]
    
    static let events = [
        Event(
            id: "1",
            title: "Beach Volleyball Tournament",
            description: "Join us for a fun beach volleyball tournament at Ocean Beach!",
            categoryEmoji: "🏐",
            coordinate: CLLocationCoordinate2D(latitude: 37.7594, longitude: -122.5107),
            distance: "0.8 km",
            attendeeCount: 24,
            isJoined: false,
            timestamp: Date().addingTimeInterval(86400)
        ),
        Event(
            id: "2",
            title: "Art Gallery Opening",
            description: "Contemporary art exhibition opening night",
            categoryEmoji: "🎨",
            coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094),
            distance: "1.2 km",
            attendeeCount: 45,
            isJoined: true,
            timestamp: Date().addingTimeInterval(172800)
        ),
        Event(
            id: "3",
            title: "Food Truck Festival",
            description: "Street food from around the world",
            categoryEmoji: "🍕",
            coordinate: CLLocationCoordinate2D(latitude: 37.7699, longitude: -122.4194),
            distance: "0.5 km",
            attendeeCount: 156,
            isJoined: false,
            timestamp: Date().addingTimeInterval(259200)
        )
    ]
    
    static let homeFeedItems = [
        HomeFeedItem(
            id: "1",
            sectionTitle: "📍 Happening Near You",
            title: "Beach Volleyball Tournament",
            subtitle: "Ocean Beach • 24 people going",
            imageURL: "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=300&h=200&fit=crop",
            distance: "0.8km away",
            timestamp: nil,
            type: .nearbyEvent
        ),
        HomeFeedItem(
            id: "2",
            sectionTitle: "👥 Friends' Latest",
            title: "Maria just visited Blue Bottle Coffee",
            subtitle: "\"Amazing single-origin espresso! ☕️\"",
            imageURL: "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=300&h=200&fit=crop",
            distance: nil,
            timestamp: "2h ago",
            type: .friendActivity
        ),
        HomeFeedItem(
            id: "3",
            sectionTitle: "☕ For You",
            title: "Perfect time for your coffee break!",
            subtitle: "Based on your routine, you usually grab coffee around this time",
            imageURL: "https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=300&h=200&fit=crop",
            distance: nil,
            timestamp: nil,
            type: .recommendation
        )
    ]
    
    static let explorePosts = [
        Post(
            id: "1",
            author: friends[0],
            content: "Amazing sunset at Golden Gate Bridge! 🌅",
            imageURL: "https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400&h=400&fit=crop",
            videoURL: nil,
            location: "Golden Gate Bridge",
            timestamp: Date().addingTimeInterval(-7200),
            likeCount: 42,
            commentCount: 8,
            isLiked: false,
            isBookmarked: true
        ),
        Post(
            id: "2",
            author: friends[1],
            content: "Street art tour in the Mission District was incredible! 🎨",
            imageURL: "https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400&h=400&fit=crop",
            videoURL: nil,
            location: "Mission District",
            timestamp: Date().addingTimeInterval(-14400),
            likeCount: 67,
            commentCount: 12,
            isLiked: true,
            isBookmarked: false
        ),
        Post(
            id: "3",
            author: friends[2],
            content: "Best tacos in the city! 🌮",
            imageURL: "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=400&fit=crop",
            videoURL: nil,
            location: "La Taqueria",
            timestamp: Date().addingTimeInterval(-21600),
            likeCount: 89,
            commentCount: 15,
            isLiked: true,
            isBookmarked: true
        )
    ]
    
    static let notifications = [
        Notification(
            id: "1",
            type: .like,
            title: "John liked your beach photo",
            subtitle: "Your post from Ocean Beach",
            timestamp: Date().addingTimeInterval(-3600),
            isRead: false,
            relatedUser: friends[0],
            relatedPost: explorePosts[0]
        ),
        Notification(
            id: "2",
            type: .friendRequest,
            title: "Sarah wants to be friends",
            subtitle: "You have 5 mutual friends",
            timestamp: Date().addingTimeInterval(-7200),
            isRead: false,
            relatedUser: friends[2],
            relatedPost: nil
        ),
        Notification(
            id: "3",
            type: .achievement,
            title: "🏖️ Beach Explorer",
            subtitle: "You've visited 5 beaches this month!",
            timestamp: Date().addingTimeInterval(-14400),
            isRead: true,
            relatedUser: nil,
            relatedPost: nil
        )
    ]
}

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .denied, .restricted:
            stopUpdatingLocation()
        default:
            break
        }
    }
}