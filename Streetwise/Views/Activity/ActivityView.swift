import SwiftUI

struct ActivityView: View {
    @State private var notifications = MockData.notifications
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom segmented control
                ActivityTabSelector(selectedTab: $selectedTab)
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    NotificationsListView(notifications: $notifications)
                        .tag(0)
                    
                    FriendRequestsView()
                        .tag(1)
                    
                    AchievementsView()
                        .tag(2)
                    
                    WeeklySummaryView()
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ActivityTabSelector: View {
    @Binding var selectedTab: Int
    
    private let tabs = ["All", "Requests", "Achievements", "Summary"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: DesignTokens.animationFast)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: DesignTokens.spacingXS) {
                        Text(tab)
                            .font(AppTypography.body.weight(selectedTab == index ? .semibold : .regular))
                            .foregroundColor(selectedTab == index ? AppColors.primary : AppColors.neutralMedium)
                        
                        Rectangle()
                            .fill(selectedTab == index ? AppColors.primary : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, DesignTokens.spacingL)
        .background(Color.white)
    }
}

struct NotificationsListView: View {
    @Binding var notifications: [Notification]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: DesignTokens.spacingS) {
                ForEach(notifications) { notification in
                    NotificationCard(notification: notification) {
                        handleNotificationAction(notification)
                    }
                }
            }
            .padding(.horizontal, DesignTokens.spacingL)
            .padding(.vertical, DesignTokens.spacingM)
        }
        .background(AppColors.background)
        .refreshable {
            // Handle refresh
        }
    }
    
    private func handleNotificationAction(_ notification: Notification) {
        // Mark as read and handle specific action
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index] = Notification(
                id: notification.id,
                type: notification.type,
                title: notification.title,
                subtitle: notification.subtitle,
                timestamp: notification.timestamp,
                isRead: true,
                relatedUser: notification.relatedUser,
                relatedPost: notification.relatedPost
            )
        }
    }
}

struct NotificationCard: View {
    let notification: Notification
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DesignTokens.spacingM) {
                // Icon or user avatar
                Group {
                    if let user = notification.relatedUser {
                        AsyncImage(url: URL(string: user.profileImageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle()
                                .fill(AppColors.neutralMedium)
                        }
                        .frame(width: DesignTokens.avatarMedium, height: DesignTokens.avatarMedium)
                        .clipShape(Circle())
                    } else {
                        ZStack {
                            Circle()
                                .fill(notificationIconBackground)
                                .frame(width: DesignTokens.avatarMedium, height: DesignTokens.avatarMedium)
                            
                            Image(systemName: notificationIcon)
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                    }
                }
                
                // Content
                VStack(alignment: .leading, spacing: DesignTokens.spacingXS) {
                    Text(notification.title)
                        .font(AppTypography.body.weight(notification.isRead ? .regular : .semibold))
                        .foregroundColor(AppColors.neutralDark)
                        .multilineTextAlignment(.leading)
                    
                    Text(notification.subtitle)
                        .font(AppTypography.bodySmall)
                        .foregroundColor(AppColors.neutralMedium)
                        .multilineTextAlignment(.leading)
                    
                    Text(timeAgo(from: notification.timestamp))
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.neutralMedium)
                }
                
                Spacer()
                
                // Unread indicator
                if !notification.isRead {
                    Circle()
                        .fill(AppColors.primary)
                        .frame(width: 8, height: 8)
                }
                
                // Action buttons for friend requests
                if notification.type == .friendRequest {
                    VStack(spacing: DesignTokens.spacingS) {
                        Button("Accept") {
                            // Handle accept
                        }
                        .font(AppTypography.caption.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, DesignTokens.spacingM)
                        .padding(.vertical, DesignTokens.spacingXS)
                        .background(AppColors.primary)
                        .cornerRadius(DesignTokens.cornerRadiusSmall)
                        
                        Button("Decline") {
                            // Handle decline
                        }
                        .font(AppTypography.caption.weight(.semibold))
                        .foregroundColor(AppColors.neutralMedium)
                        .padding(.horizontal, DesignTokens.spacingM)
                        .padding(.vertical, DesignTokens.spacingXS)
                        .background(AppColors.neutralLight)
                        .cornerRadius(DesignTokens.cornerRadiusSmall)
                    }
                }
            }
            .padding(DesignTokens.spacingM)
            .background(Color.white)
            .cornerRadius(DesignTokens.cornerRadiusMedium)
            .shadow(
                color: .black.opacity(0.05),
                radius: 4,
                x: 0,
                y: 2
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var notificationIcon: String {
        switch notification.type {
        case .like: return "heart.fill"
        case .comment: return "message.fill"
        case .friendRequest: return "person.2.fill"
        case .mention: return "at"
        case .achievement: return "trophy.fill"
        case .event: return "calendar"
        }
    }
    
    private var notificationIconBackground: LinearGradient {
        switch notification.type {
        case .like: return LinearGradient(colors: [.red, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .comment: return AppColors.accentGradient
        case .friendRequest: return AppColors.primaryGradient
        case .mention: return AppColors.secondaryGradient
        case .achievement: return LinearGradient(colors: [.orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .event: return LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    private func timeAgo(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        
        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        } else {
            let days = Int(interval / 86400)
            return "\(days)d ago"
        }
    }
}

struct FriendRequestsView: View {
    @State private var friendRequests = MockData.friends.prefix(2)
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: DesignTokens.spacingM) {
                ForEach(Array(friendRequests), id: \.id) { friend in
                    FriendRequestCard(friend: friend)
                }
            }
            .padding(.horizontal, DesignTokens.spacingL)
            .padding(.vertical, DesignTokens.spacingM)
        }
        .background(AppColors.background)
    }
}

struct FriendRequestCard: View {
    let friend: Friend
    
    var body: some View {
        HStack(spacing: DesignTokens.spacingM) {
            AsyncImage(url: URL(string: friend.profileImageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(AppColors.neutralMedium)
            }
            .frame(width: DesignTokens.avatarLarge, height: DesignTokens.avatarLarge)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: DesignTokens.spacingXS) {
                Text(friend.displayName)
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundColor(AppColors.neutralDark)
                
                Text("@\(friend.username)")
                    .font(AppTypography.bodySmall)
                    .foregroundColor(AppColors.neutralMedium)
                
                Text("\(friend.mutualFriends) mutual friends")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.neutralMedium)
                
                HStack(spacing: DesignTokens.spacingS) {
                    Button("Accept") {
                        // Handle accept
                    }
                    .font(AppTypography.bodySmall.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, DesignTokens.spacingL)
                    .padding(.vertical, DesignTokens.spacingS)
                    .background(AppColors.primary)
                    .cornerRadius(DesignTokens.cornerRadiusMedium)
                    
                    Button("Decline") {
                        // Handle decline
                    }
                    .font(AppTypography.bodySmall.weight(.semibold))
                    .foregroundColor(AppColors.neutralMedium)
                    .padding(.horizontal, DesignTokens.spacingL)
                    .padding(.vertical, DesignTokens.spacingS)
                    .background(AppColors.neutralLight)
                    .cornerRadius(DesignTokens.cornerRadiusMedium)
                }
            }
            
            Spacer()
        }
        .padding(DesignTokens.spacingM)
        .cardStyle()
    }
}

struct AchievementsView: View {
    private let achievements = [
        Achievement(id: "1", title: "🏖️ Beach Explorer", description: "Visited 5 beaches this month", isUnlocked: true, progress: 1.0),
        Achievement(id: "2", title: "📸 Photo Master", description: "Posted 20 photos", isUnlocked: true, progress: 1.0),
        Achievement(id: "3", title: "🎭 Culture Buff", description: "Visit 10 cultural sites", isUnlocked: false, progress: 0.7),
        Achievement(id: "4", title: "🍕 Foodie", description: "Try 15 different cuisines", isUnlocked: false, progress: 0.4)
    ]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: DesignTokens.spacingM) {
                ForEach(achievements) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
            .padding(.horizontal, DesignTokens.spacingL)
            .padding(.vertical, DesignTokens.spacingM)
        }
        .background(AppColors.background)
    }
}

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let isUnlocked: Bool
    let progress: Double
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: DesignTokens.spacingM) {
            Text(String(achievement.title.prefix(2)))
                .font(.largeTitle)
                .opacity(achievement.isUnlocked ? 1.0 : 0.4)
            
            VStack(alignment: .leading, spacing: DesignTokens.spacingXS) {
                Text(String(achievement.title.dropFirst(2)))
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundColor(AppColors.neutralDark)
                
                Text(achievement.description)
                    .font(AppTypography.bodySmall)
                    .foregroundColor(AppColors.neutralMedium)
                
                if !achievement.isUnlocked {
                    ProgressView(value: achievement.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: AppColors.primary))
                        .frame(height: 4)
                }
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(AppColors.success)
                    .font(.title2)
            }
        }
        .padding(DesignTokens.spacingM)
        .cardStyle()
        .opacity(achievement.isUnlocked ? 1.0 : 0.7)
    }
}

struct WeeklySummaryView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.spacingL) {
                // Stats cards
                VStack(spacing: DesignTokens.spacingM) {
                    SummaryStatCard(title: "Places Visited", value: "12", subtitle: "This week", icon: "location.fill", color: AppColors.primary)
                    SummaryStatCard(title: "New Posts", value: "8", subtitle: "Shared this week", icon: "photo.fill", color: AppColors.accent)
                    SummaryStatCard(title: "Friends Met", value: "3", subtitle: "In person", icon: "person.2.fill", color: AppColors.secondary)
                }
                
                // Weekly chart would go here
                VStack(alignment: .leading, spacing: DesignTokens.spacingM) {
                    Text("Activity Overview")
                        .font(AppTypography.title)
                        .foregroundColor(AppColors.neutralDark)
                    
                    RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusMedium)
                        .fill(AppColors.neutralLight)
                        .frame(height: 200)
                        .overlay(
                            Text("Weekly Activity Chart")
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.neutralMedium)
                        )
                }
                .padding(DesignTokens.spacingM)
                .cardStyle()
            }
            .padding(.horizontal, DesignTokens.spacingL)
            .padding(.vertical, DesignTokens.spacingM)
        }
        .background(AppColors.background)
    }
}

struct SummaryStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: DesignTokens.spacingM) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: DesignTokens.spacingXS) {
                Text(value)
                    .font(AppTypography.titleLarge)
                    .foregroundColor(AppColors.neutralDark)
                
                Text(title)
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundColor(AppColors.neutralDark)
                
                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.neutralMedium)
            }
            
            Spacer()
        }
        .padding(DesignTokens.spacingM)
        .cardStyle()
    }
}

#Preview {
    ActivityView()
}