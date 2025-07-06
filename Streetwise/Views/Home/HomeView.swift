import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var showingSearch = false
    @State private var searchText = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header
                HomeHeaderView(
                    searchText: $searchText,
                    showingSearch: $showingSearch
                )
                
                // Map Section (Top Half)
                MapView(region: $region)
                    .frame(height: geometry.size.height * 0.4)
                    .clipped()
                
                // Feed Section (Bottom Half)
                HomeFeedView()
                    .frame(maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            locationManager.requestPermission()
        }
    }
}

struct HomeHeaderView: View {
    @Binding var searchText: String
    @Binding var showingSearch: Bool
    
    var body: some View {
        HStack {
            // Search button
            Button(action: {
                showingSearch = true
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.neutralDark)
                    .font(.title2)
            }
            
            Spacer()
            
            // Voice search button
            Button(action: {
                // Handle voice search
            }) {
                Image(systemName: "mic.fill")
                    .foregroundColor(AppColors.primary)
                    .font(.title2)
            }
            
            Spacer()
            
            // Profile button
            Button(action: {
                // Handle profile tap
            }) {
                AsyncImage(url: URL(string: "https://via.placeholder.com/32")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(AppColors.neutralMedium)
                }
                .frame(width: DesignTokens.avatarSmall, height: DesignTokens.avatarSmall)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(AppColors.primaryGradient, lineWidth: 2)
                )
            }
            
            // Menu button
            Button(action: {
                // Handle menu tap
            }) {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(AppColors.neutralDark)
                    .font(.title2)
            }
        }
        .padding(.horizontal, DesignTokens.spacingL)
        .padding(.vertical, DesignTokens.spacingM)
        .background(Color.white)
        .sheet(isPresented: $showingSearch) {
            SearchView(searchText: $searchText)
        }
    }
}

struct MapView: View {
    @Binding var region: MKCoordinateRegion
    @State private var mockFriends = MockData.friends
    @State private var mockEvents = MockData.events
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: mockEvents) { event in
                MapAnnotation(coordinate: event.coordinate) {
                    EventMapPin(event: event)
                }
            }
            .ignoresSafeArea()
            
            // Friend avatars overlay
            ForEach(mockFriends) { friend in
                FriendMapAvatar(friend: friend)
                    .position(
                        x: CGFloat.random(in: 50...300),
                        y: CGFloat.random(in: 50...200)
                    )
            }
        }
    }
}

struct EventMapPin: View {
    let event: Event
    
    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                Circle()
                    .fill(AppColors.accentGradient)
                    .frame(width: 24, height: 24)
                
                Text(event.categoryEmoji)
                    .font(.system(size: 12))
            }
            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            
            Circle()
                .fill(AppColors.accent)
                .frame(width: 4, height: 4)
        }
    }
}

struct FriendMapAvatar: View {
    let friend: Friend
    
    var body: some View {
        VStack(spacing: 2) {
            AsyncImage(url: URL(string: friend.profileImageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(AppColors.neutralMedium)
            }
            .frame(width: 32, height: 32)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(friend.isOnline ? AppColors.success : AppColors.neutralMedium, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
        }
    }
}

struct HomeFeedView: View {
    @State private var feedItems = MockData.homeFeedItems
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: DesignTokens.spacingM) {
                ForEach(feedItems) { item in
                    HomeFeedCard(item: item)
                        .padding(.horizontal, DesignTokens.spacingL)
                }
            }
            .padding(.vertical, DesignTokens.spacingM)
        }
        .background(AppColors.background)
        .refreshable {
            // Handle refresh
        }
    }
}

struct HomeFeedCard: View {
    let item: HomeFeedItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingS) {
            // Header
            HStack {
                Text(item.sectionTitle)
                    .font(AppTypography.title)
                    .foregroundColor(AppColors.neutralDark)
                
                Spacer()
                
                if let distance = item.distance {
                    Text(distance)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.neutralMedium)
                }
            }
            
            // Content
            HStack(spacing: DesignTokens.spacingM) {
                // Image
                AsyncImage(url: URL(string: item.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusSmall)
                        .fill(AppColors.neutralMedium.opacity(0.3))
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusSmall))
                
                // Text content
                VStack(alignment: .leading, spacing: DesignTokens.spacingXS) {
                    Text(item.title)
                        .font(AppTypography.body.weight(.semibold))
                        .foregroundColor(AppColors.neutralDark)
                    
                    if let subtitle = item.subtitle {
                        Text(subtitle)
                            .font(AppTypography.bodySmall)
                            .foregroundColor(AppColors.neutralMedium)
                    }
                    
                    if let timestamp = item.timestamp {
                        Text(timestamp)
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.neutralMedium)
                    }
                }
                
                Spacer()
            }
        }
        .padding(DesignTokens.spacingM)
        .cardStyle()
        .onTapGesture {
            // Handle card tap
        }
    }
}

struct SearchView: View {
    @Binding var searchText: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.neutralMedium)
                    
                    TextField("Search places, events, friends...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button("Clear") {
                            searchText = ""
                        }
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.primary)
                    }
                }
                .padding(DesignTokens.spacingM)
                .background(AppColors.neutralLight)
                .cornerRadius(DesignTokens.cornerRadiusMedium)
                .padding(.horizontal, DesignTokens.spacingL)
                
                // Search results would go here
                Spacer()
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    HomeView()
}