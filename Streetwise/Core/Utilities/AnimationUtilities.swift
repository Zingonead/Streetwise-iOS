import SwiftUI

struct AnimationUtilities {
    
    // Standard animations
    static let fastAnimation = Animation.easeInOut(duration: DesignTokens.animationFast)
    static let normalAnimation = Animation.easeInOut(duration: DesignTokens.animationNormal)
    static let slowAnimation = Animation.easeInOut(duration: DesignTokens.animationSlow)
    
    // Spring animations
    static let springAnimation = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let bounceAnimation = Animation.spring(response: 0.4, dampingFraction: 0.5)
    
    // Custom button animations
    static let buttonPress = Animation.easeInOut(duration: 0.1)
    static let buttonRelease = Animation.easeInOut(duration: 0.2)
}

// Custom button style with haptic feedback
struct InteractiveButtonStyle: ButtonStyle {
    let hapticFeedback: UIImpactFeedbackGenerator.FeedbackStyle
    
    init(hapticFeedback: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        self.hapticFeedback = hapticFeedback
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(AnimationUtilities.buttonPress, value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed {
                    let impact = UIImpactFeedbackGenerator(style: hapticFeedback)
                    impact.impactOccurred()
                }
            }
    }
}

// Shimmer loading effect
struct ShimmerView: View {
    @State private var isAnimating = false
    
    var body: some View {
        LinearGradient(
            colors: [
                Color.gray.opacity(0.3),
                Color.gray.opacity(0.1),
                Color.gray.opacity(0.3)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .mask(
            LinearGradient(
                colors: [Color.clear, Color.black, Color.clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .scaleEffect(x: isAnimating ? 1 : 0.1)
            .offset(x: isAnimating ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width)
        )
        .onAppear {
            withAnimation(
                Animation.linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
            ) {
                isAnimating = true
            }
        }
    }
}

// Card appear animation
struct CardAppearModifier: ViewModifier {
    @State private var isVisible = false
    let delay: Double
    
    init(delay: Double = 0) {
        self.delay = delay
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                withAnimation(
                    AnimationUtilities.normalAnimation
                        .delay(delay)
                ) {
                    isVisible = true
                }
            }
    }
}

// Floating action button animation
struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.title2)
                .frame(width: 56, height: 56)
                .background(AppColors.primaryGradient)
                .clipShape(Circle())
                .shadow(
                    color: AppColors.primary.opacity(0.3),
                    radius: isPressed ? 4 : 8,
                    x: 0,
                    y: isPressed ? 2 : 4
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            withAnimation(AnimationUtilities.springAnimation) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(AnimationUtilities.springAnimation) {
                    isPressed = false
                }
            }
            
            action()
        }
    }
}

// Pull to refresh indicator
struct PullToRefreshView: View {
    @Binding var isRefreshing: Bool
    let onRefresh: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            if isRefreshing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primary))
                    .scaleEffect(0.8)
            } else {
                Image(systemName: "arrow.down")
                    .foregroundColor(AppColors.primary)
                    .rotationEffect(.degrees(isRefreshing ? 180 : 0))
                    .animation(AnimationUtilities.normalAnimation, value: isRefreshing)
            }
            
            Spacer()
        }
        .padding(.vertical, DesignTokens.spacingM)
        .onTapGesture {
            if !isRefreshing {
                withAnimation(AnimationUtilities.normalAnimation) {
                    isRefreshing = true
                }
                onRefresh()
            }
        }
    }
}

// Like button with heart animation
struct LikeButton: View {
    @Binding var isLiked: Bool
    let likeCount: Int
    
    @State private var animateHeart = false
    @State private var showParticles = false
    
    var body: some View {
        Button(action: {
            withAnimation(AnimationUtilities.springAnimation) {
                isLiked.toggle()
                
                if isLiked {
                    animateHeart = true
                    showParticles = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animateHeart = false
                        showParticles = false
                    }
                }
            }
            
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }) {
            HStack(spacing: DesignTokens.spacingXS) {
                ZStack {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : AppColors.neutralDark)
                        .font(.title3)
                        .scaleEffect(animateHeart ? 1.3 : 1.0)
                    
                    // Heart particles effect
                    if showParticles {
                        ForEach(0..<8, id: \.self) { index in
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red.opacity(0.7))
                                .font(.caption)
                                .scaleEffect(0.5)
                                .offset(
                                    x: cos(Double(index) * .pi / 4) * 20,
                                    y: sin(Double(index) * .pi / 4) * 20
                                )
                                .opacity(showParticles ? 0 : 1)
                                .animation(
                                    AnimationUtilities.normalAnimation.delay(Double(index) * 0.05),
                                    value: showParticles
                                )
                        }
                    }
                }
                
                Text("\(likeCount + (isLiked ? 1 : 0))")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.neutralMedium)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Loading skeleton for cards
struct SkeletonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingS) {
            // Header skeleton
            HStack {
                Circle()
                    .fill(AppColors.neutralLight)
                    .frame(width: 40, height: 40)
                    .overlay(ShimmerView())
                
                VStack(alignment: .leading, spacing: 4) {
                    Rectangle()
                        .fill(AppColors.neutralLight)
                        .frame(width: 120, height: 12)
                        .overlay(ShimmerView())
                    
                    Rectangle()
                        .fill(AppColors.neutralLight)
                        .frame(width: 80, height: 10)
                        .overlay(ShimmerView())
                }
                
                Spacer()
            }
            
            // Image skeleton
            Rectangle()
                .fill(AppColors.neutralLight)
                .frame(height: 200)
                .cornerRadius(DesignTokens.cornerRadiusMedium)
                .overlay(ShimmerView())
            
            // Text skeleton
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(AppColors.neutralLight)
                    .frame(height: 12)
                    .overlay(ShimmerView())
                
                Rectangle()
                    .fill(AppColors.neutralLight)
                    .frame(width: 200, height: 12)
                    .overlay(ShimmerView())
            }
        }
        .padding(DesignTokens.spacingM)
        .cardStyle()
    }
}

// Floating notification
struct FloatingNotification: View {
    let message: String
    let type: NotificationType
    @Binding var isVisible: Bool
    
    enum NotificationType {
        case success, error, info
        
        var color: Color {
            switch self {
            case .success: return AppColors.success
            case .error: return AppColors.error
            case .info: return AppColors.primary
            }
        }
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error: return "exclamationmark.triangle.fill"
            case .info: return "info.circle.fill"
            }
        }
    }
    
    var body: some View {
        HStack(spacing: DesignTokens.spacingM) {
            Image(systemName: type.icon)
                .foregroundColor(type.color)
                .font(.title3)
            
            Text(message)
                .font(AppTypography.body)
                .foregroundColor(AppColors.neutralDark)
            
            Spacer()
        }
        .padding(DesignTokens.spacingM)
        .background(Color.white)
        .cornerRadius(DesignTokens.cornerRadiusMedium)
        .shadow(
            color: .black.opacity(0.1),
            radius: 8,
            x: 0,
            y: 4
        )
        .offset(y: isVisible ? 0 : -100)
        .opacity(isVisible ? 1 : 0)
        .animation(AnimationUtilities.springAnimation, value: isVisible)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(AnimationUtilities.normalAnimation) {
                    isVisible = false
                }
            }
        }
    }
}

extension View {
    func cardAppear(delay: Double = 0) -> some View {
        self.modifier(CardAppearModifier(delay: delay))
    }
    
    func interactiveButton(haptic: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.buttonStyle(InteractiveButtonStyle(hapticFeedback: haptic))
    }
}