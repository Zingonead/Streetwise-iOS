import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedTab = 0
    @State private var showingSettings = false
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignTokens.spacingL) {
                    // Profile Header
                    ProfileHeaderView(
                        user: authManager.currentUser,
                        showingSettings: $showingSettings,
                        showingEditProfile: $showingEditProfile
                    )
                    
                    // Stats Section
                    ProfileStatsView(user: authManager.currentUser)
                    
                    // Content Tabs
                    ProfileContentTabs(selectedTab: $selectedTab)
                    
                    // Content based on selected tab
                    ProfileContentView(selectedTab: selectedTab)
                }
            }
            .navigationBarHidden(true)
            .background(AppColors.background)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(user: authManager.currentUser)
        }
    }
}

struct ProfileHeaderView: View {
    let user: User?
    @Binding var showingSettings: Bool
    @Binding var showingEditProfile: Bool
    
    var body: some View {
        VStack(spacing: DesignTokens.spacingM) {
            // Top bar
            HStack {
                Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gearshape")
                        .foregroundColor(AppColors.neutralDark)
                        .font(.title2)
                }
                
                Spacer()
                
                Text(user?.displayName ?? "User")
                    .font(AppTypography.title)
                    .foregroundColor(AppColors.neutralDark)
                
                Spacer()
                
                Button(action: {
                    // Show menu
                }) {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(AppColors.neutralDark)
                        .font(.title2)
                }
            }
            .padding(.horizontal, DesignTokens.spacingL)
            
            // Profile image
            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(AppColors.neutralMedium)
            }
            .frame(width: DesignTokens.avatarXL, height: DesignTokens.avatarXL)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(AppColors.primaryGradient, lineWidth: 3)
            )
            
            // User info
            VStack(spacing: DesignTokens.spacingXS) {
                Text("@\(user?.username ?? "username")")
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.neutralMedium)
                
                HStack(spacing: DesignTokens.spacingS) {
                    Image(systemName: "location")
                        .foregroundColor(AppColors.neutralMedium)
                        .font(.caption)
                    
                    Text(user?.location ?? "Location")
                        .font(AppTypography.bodySmall)
                        .foregroundColor(AppColors.neutralMedium)
                }
                
                // Interest badges
                if let interests = user?.interests, !interests.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DesignTokens.spacingS) {
                            ForEach(interests.prefix(3)) { interest in
                                HStack(spacing: DesignTokens.spacingXS) {
                                    Text(interest.emoji)
                                        .font(.caption)
                                    
                                    Text(interest.name)
                                        .font(AppTypography.caption)
                                        .foregroundColor(AppColors.neutralMedium)
                                }
                                .padding(.horizontal, DesignTokens.spacingS)
                                .padding(.vertical, DesignTokens.spacingXS)
                                .background(AppColors.neutralLight)
                                .cornerRadius(DesignTokens.cornerRadiusLarge)
                            }
                        }
                        .padding(.horizontal, DesignTokens.spacingL)
                    }
                }
            }
        }
    }
}

struct ProfileStatsView: View {
    let user: User?
    
    var body: some View {
        HStack {
            StatItem(title: "Posts", value: "\(user?.postsCount ?? 0)")
            StatItem(title: "Friends", value: "\(user?.friendsCount ?? 0)")
            StatItem(title: "Places", value: "\(user?.placesCount ?? 0)")
        }
        .padding(.horizontal, DesignTokens.spacingL)
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: DesignTokens.spacingXS) {
            Text(value)
                .font(AppTypography.titleLarge)
                .foregroundColor(AppColors.neutralDark)
            
            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.neutralMedium)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProfileContentTabs: View {
    @Binding var selectedTab: Int
    
    private let tabs = ["Posts", "Map", "Achievements", "Favorites"]
    private let icons = ["photo", "map", "trophy", "heart"]
    
    var body: some View {
        VStack(spacing: DesignTokens.spacingM) {
            // Edit Profile Button
            Button("Edit Profile") {
                // Handle edit profile
            }
            .primaryButtonStyle()
            .padding(.horizontal, DesignTokens.spacingL)
            
            // Tab selector
            HStack(spacing: 0) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    Button(action: {
                        withAnimation(.easeInOut(duration: DesignTokens.animationFast)) {
                            selectedTab = index
                        }
                    }) {
                        VStack(spacing: DesignTokens.spacingXS) {
                            Image(systemName: selectedTab == index ? "\(icons[index]).fill" : icons[index])
                                .foregroundColor(selectedTab == index ? AppColors.primary : AppColors.neutralMedium)
                                .font(.title3)
                            
                            Text(tab)
                                .font(AppTypography.caption)
                                .foregroundColor(selectedTab == index ? AppColors.primary : AppColors.neutralMedium)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, DesignTokens.spacingL)
            .padding(.vertical, DesignTokens.spacingS)
            .background(Color.white)
        }
    }
}

struct ProfileContentView: View {
    let selectedTab: Int
    
    var body: some View {
        Group {
            switch selectedTab {
            case 0:
                PostsGridView()
            case 1:
                MapView()
            case 2:
                AchievementsView()
            case 3:
                FavoritesView()
            default:
                PostsGridView()
            }
        }
    }
}

struct PostsGridView: View {
    private let posts = MockData.explorePosts
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(posts) { post in
                AsyncImage(url: URL(string: post.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(AppColors.neutralMedium.opacity(0.3))
                }
                .aspectRatio(1, contentMode: .fit)
                .clipped()
                .onTapGesture {
                    // Handle post tap
                }
            }
        }
        .padding(.horizontal, DesignTokens.spacingL)
    }
}

struct MapView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusMedium)
                .fill(AppColors.neutralLight)
                .frame(height: 300)
                .overlay(
                    VStack {
                        Image(systemName: "map")
                            .foregroundColor(AppColors.neutralMedium)
                            .font(.largeTitle)
                        
                        Text("Your Places Map")
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.neutralMedium)
                    }
                )
        }
        .padding(.horizontal, DesignTokens.spacingL)
    }
}

struct FavoritesView: View {
    private let favorites = MockData.explorePosts.filter { $0.isBookmarked }
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: DesignTokens.spacingM) {
            ForEach(favorites) { post in
                VStack(alignment: .leading, spacing: DesignTokens.spacingS) {
                    AsyncImage(url: URL(string: post.imageURL ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(AppColors.neutralMedium.opacity(0.3))
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(DesignTokens.cornerRadiusMedium)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: DesignTokens.spacingXS) {
                        Text(post.location ?? "Location")
                            .font(AppTypography.bodySmall.weight(.semibold))
                            .foregroundColor(AppColors.neutralDark)
                            .lineLimit(1)
                        
                        Text(post.content)
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.neutralMedium)
                            .lineLimit(2)
                    }
                }
                .cardStyle()
            }
        }
        .padding(.horizontal, DesignTokens.spacingL)
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationView {
            List {
                Section("Account") {
                    SettingsRow(icon: "person.circle", title: "Edit Profile", color: AppColors.primary)
                    SettingsRow(icon: "lock", title: "Privacy", color: AppColors.primary)
                    SettingsRow(icon: "bell", title: "Notifications", color: AppColors.primary)
                }
                
                Section("App") {
                    SettingsRow(icon: "location", title: "Location Services", color: AppColors.accent)
                    SettingsRow(icon: "square.and.arrow.down", title: "Data & Storage", color: AppColors.accent)
                    SettingsRow(icon: "questionmark.circle", title: "Help & Support", color: AppColors.accent)
                }
                
                Section("About") {
                    SettingsRow(icon: "info.circle", title: "About Streetside", color: AppColors.neutralMedium)
                    SettingsRow(icon: "doc.text", title: "Terms of Service", color: AppColors.neutralMedium)
                    SettingsRow(icon: "hand.raised", title: "Privacy Policy", color: AppColors.neutralMedium)
                }
                
                Section {
                    Button("Sign Out") {
                        authManager.signOut()
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                trailing: Button("Done") {
                    dismiss()
                }
            )
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: DesignTokens.spacingM) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .frame(width: 24)
            
            Text(title)
                .font(AppTypography.body)
                .foregroundColor(AppColors.neutralDark)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(AppColors.neutralMedium)
                .font(.caption)
        }
        .padding(.vertical, DesignTokens.spacingXS)
    }
}

struct EditProfileView: View {
    let user: User?
    @Environment(\.dismiss) private var dismiss
    @State private var displayName = ""
    @State private var bio = ""
    @State private var location = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignTokens.spacingL) {
                    // Profile image editor
                    VStack(spacing: DesignTokens.spacingM) {
                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle()
                                .fill(AppColors.neutralMedium)
                        }
                        .frame(width: DesignTokens.avatarXL, height: DesignTokens.avatarXL)
                        .clipShape(Circle())
                        
                        Button("Change Photo") {
                            // Handle photo change
                        }
                        .font(AppTypography.body.weight(.semibold))
                        .foregroundColor(AppColors.primary)
                    }
                    
                    // Form fields
                    VStack(spacing: DesignTokens.spacingM) {
                        VStack(alignment: .leading, spacing: DesignTokens.spacingS) {
                            Text("Display Name")
                                .font(AppTypography.body.weight(.semibold))
                                .foregroundColor(AppColors.neutralDark)
                            
                            TextField("Enter your display name", text: $displayName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: DesignTokens.spacingS) {
                            Text("Bio")
                                .font(AppTypography.body.weight(.semibold))
                                .foregroundColor(AppColors.neutralDark)
                            
                            TextField("Tell people about yourself", text: $bio, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(3...6)
                        }
                        
                        VStack(alignment: .leading, spacing: DesignTokens.spacingS) {
                            Text("Location")
                                .font(AppTypography.body.weight(.semibold))
                                .foregroundColor(AppColors.neutralDark)
                            
                            TextField("Your location", text: $location)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, DesignTokens.spacingL)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    // Handle save
                    dismiss()
                }
                .disabled(displayName.isEmpty)
            )
        }
        .onAppear {
            displayName = user?.displayName ?? ""
            bio = user?.bio ?? ""
            location = user?.location ?? ""
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager())
}