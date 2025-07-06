import SwiftUI

struct DesignTokens {
    // Spacing
    static let spacingXS: CGFloat = 4
    static let spacingS: CGFloat = 8
    static let spacingM: CGFloat = 16
    static let spacingL: CGFloat = 24
    static let spacingXL: CGFloat = 32
    
    // Corner Radius
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 20
    
    // Button Heights
    static let buttonHeight: CGFloat = 48
    static let buttonHeightSmall: CGFloat = 36
    static let buttonHeightLarge: CGFloat = 56
    
    // Card Properties
    static let cardElevation: CGFloat = 4
    static let cardShadowRadius: CGFloat = 8
    static let cardShadowOpacity: Double = 0.1
    static let cardShadowOffset = CGSize(width: 0, height: 2)
    
    // Animation Durations
    static let animationFast: Double = 0.2
    static let animationNormal: Double = 0.3
    static let animationSlow: Double = 0.5
    
    // Icon Sizes
    static let iconSmall: CGFloat = 16
    static let iconMedium: CGFloat = 24
    static let iconLarge: CGFloat = 32
    
    // Avatar Sizes
    static let avatarSmall: CGFloat = 32
    static let avatarMedium: CGFloat = 48
    static let avatarLarge: CGFloat = 64
    static let avatarXL: CGFloat = 100
}

extension View {
    func cardStyle() -> some View {
        self
            .background(Color.white)
            .cornerRadius(DesignTokens.cornerRadiusMedium)
            .shadow(
                color: .black.opacity(DesignTokens.cardShadowOpacity),
                radius: DesignTokens.cardShadowRadius,
                x: DesignTokens.cardShadowOffset.width,
                y: DesignTokens.cardShadowOffset.height
            )
    }
    
    func primaryButtonStyle() -> some View {
        self
            .frame(height: DesignTokens.buttonHeight)
            .background(AppColors.primaryGradient)
            .foregroundColor(.white)
            .cornerRadius(DesignTokens.cornerRadiusMedium)
            .font(AppTypography.body.weight(.semibold))
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .frame(height: DesignTokens.buttonHeight)
            .background(Color.white)
            .foregroundColor(AppColors.primary)
            .cornerRadius(DesignTokens.cornerRadiusMedium)
            .font(AppTypography.body.weight(.semibold))
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusMedium)
                    .stroke(AppColors.primary, lineWidth: 1)
            )
    }
}