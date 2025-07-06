import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @State private var selectedFilter: ExploreFilter = .near
    @State private var posts = MockData.explorePosts
    @State private var showingVoiceSearch = false
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Header
                ExploreHeaderView(
                    searchText: $searchText,
                    showingVoiceSearch: $showingVoiceSearch
                )
                
                // Filter Tabs
                ExploreFilterView(selectedFilter: $selectedFilter)
                
                // Content Grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(posts) { post in
                            ExplorePostCell(post: post)
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
                .refreshable {
                    // Handle refresh
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ExploreHeaderView: View {
    @Binding var searchText: String
    @Binding var showingVoiceSearch: Bool
    
    var body: some View {
        HStack(spacing: DesignTokens.spacingM) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.neutralMedium)
                    .font(.system(size: DesignTokens.iconMedium))
                
                TextField("Search places, people, events...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(AppTypography.body)
            }
            .padding(.horizontal, DesignTokens.spacingM)
            .padding(.vertical, DesignTokens.spacingS)
            .background(AppColors.neutralLight)
            .cornerRadius(DesignTokens.cornerRadiusMedium)
            
            // Voice search button
            Button(action: {
                showingVoiceSearch = true
            }) {
                Image(systemName: "mic.fill")
                    .foregroundColor(.white)
                    .font(.system(size: DesignTokens.iconMedium))
                    .frame(width: 44, height: 44)
                    .background(AppColors.primaryGradient)
                    .clipShape(Circle())
            }
            
            // Filter button
            Button(action: {
                // Handle filter
            }) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(AppColors.neutralDark)
                    .font(.system(size: DesignTokens.iconMedium))
            }
        }
        .padding(.horizontal, DesignTokens.spacingL)
        .padding(.vertical, DesignTokens.spacingM)
        .background(Color.white)
    }
}

enum ExploreFilter: String, CaseIterable {
    case near = "📍 Near"
    case trending = "📊 Trending"
    case friends = "👥 Friends"
    case new = "🆕 New"
    case forYou = "⭐ For You"
}

struct ExploreFilterView: View {
    @Binding var selectedFilter: ExploreFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignTokens.spacingM) {
                ForEach(ExploreFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter
                    ) {
                        withAnimation(.easeInOut(duration: DesignTokens.animationFast)) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal, DesignTokens.spacingL)
        }
        .padding(.vertical, DesignTokens.spacingS)
        .background(Color.white)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(AppTypography.caption.weight(.medium))
                .foregroundColor(isSelected ? .white : AppColors.neutralDark)
                .padding(.horizontal, DesignTokens.spacingM)
                .padding(.vertical, DesignTokens.spacingS)
                .background(
                    Group {
                        if isSelected {
                            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                                .fill(AppColors.primaryGradient)
                        } else {
                            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                                .fill(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                                        .stroke(AppColors.neutralMedium.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ExplorePostCell: View {
    let post: Post
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            ZStack {
                // Image
                AsyncImage(url: URL(string: post.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(AppColors.neutralMedium.opacity(0.3))
                }
                .clipped()
                
                // Video indicator (if video)
                if post.videoURL != nil {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                                .font(.system(size: DesignTokens.iconSmall))
                                .padding(DesignTokens.spacingXS)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                                .padding(DesignTokens.spacingS)
                        }
                        Spacer()
                    }
                }
                
                // Distance overlay
                if post.location != nil {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("1.2km")
                                .font(AppTypography.small)
                                .foregroundColor(.white)
                                .padding(.horizontal, DesignTokens.spacingS)
                                .padding(.vertical, DesignTokens.spacingXS)
                                .background(Color.black.opacity(0.6))
                                .cornerRadius(DesignTokens.cornerRadiusSmall)
                                .padding(DesignTokens.spacingS)
                        }
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            PostDetailView(post: post)
        }
    }
}

struct PostDetailView: View {
    let post: Post
    @Environment(\.dismiss) private var dismiss
    @State private var isLiked: Bool
    @State private var isBookmarked: Bool
    
    init(post: Post) {
        self.post = post
        self._isLiked = State(initialValue: post.isLiked)
        self._isBookmarked = State(initialValue: post.isBookmarked)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.spacingM) {
                    // Author info
                    HStack {
                        AsyncImage(url: URL(string: post.author.profileImageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle()
                                .fill(AppColors.neutralMedium)
                        }
                        .frame(width: DesignTokens.avatarMedium, height: DesignTokens.avatarMedium)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(post.author.displayName)
                                .font(AppTypography.body.weight(.semibold))
                                .foregroundColor(AppColors.neutralDark)
                            
                            if let location = post.location {
                                Text(location)
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.neutralMedium)
                            }
                        }
                        
                        Spacer()
                        
                        Text("2h")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.neutralMedium)
                    }
                    
                    // Content image
                    if let imageURL = post.imageURL {
                        AsyncImage(url: URL(string: imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Rectangle()
                                .fill(AppColors.neutralMedium.opacity(0.3))
                                .aspectRatio(1, contentMode: .fit)
                        }
                        .cornerRadius(DesignTokens.cornerRadiusMedium)
                    }
                    
                    // Action buttons
                    HStack(spacing: DesignTokens.spacingL) {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                isLiked.toggle()
                            }
                        }) {
                            HStack(spacing: DesignTokens.spacingXS) {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(isLiked ? .red : AppColors.neutralDark)
                                    .scaleEffect(isLiked ? 1.2 : 1.0)
                                
                                Text("\(post.likeCount + (isLiked ? 1 : 0))")
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.neutralMedium)
                            }
                        }
                        
                        Button(action: {
                            // Handle comment
                        }) {
                            HStack(spacing: DesignTokens.spacingXS) {
                                Image(systemName: "message")
                                    .foregroundColor(AppColors.neutralDark)
                                
                                Text("\(post.commentCount)")
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.neutralMedium)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: DesignTokens.animationFast)) {
                                isBookmarked.toggle()
                            }
                        }) {
                            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                .foregroundColor(isBookmarked ? AppColors.primary : AppColors.neutralDark)
                        }
                    }
                    
                    // Content text
                    Text(post.content)
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.neutralDark)
                    
                    Spacer()
                }
                .padding(DesignTokens.spacingL)
            }
            .navigationTitle("Post")
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
    ExploreView()
}