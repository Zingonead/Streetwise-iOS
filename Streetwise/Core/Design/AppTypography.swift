import SwiftUI

struct AppTypography {
    static let display = Font.system(size: 28, weight: .bold, design: .rounded)
    static let title = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 16, weight: .regular, design: .rounded)
    static let caption = Font.system(size: 12, weight: .medium, design: .rounded)
    static let small = Font.system(size: 10, weight: .regular, design: .rounded)
    
    static let displayLarge = Font.system(size: 32, weight: .bold, design: .rounded)
    static let titleLarge = Font.system(size: 24, weight: .semibold, design: .rounded)
    static let bodyLarge = Font.system(size: 18, weight: .regular, design: .rounded)
    static let bodySmall = Font.system(size: 14, weight: .regular, design: .rounded)
}

extension Text {
    func displayStyle() -> some View {
        self.font(AppTypography.display)
            .foregroundColor(AppColors.neutralDark)
    }
    
    func titleStyle() -> some View {
        self.font(AppTypography.title)
            .foregroundColor(AppColors.neutralDark)
    }
    
    func bodyStyle() -> some View {
        self.font(AppTypography.body)
            .foregroundColor(AppColors.neutralDark)
    }
    
    func captionStyle() -> some View {
        self.font(AppTypography.caption)
            .foregroundColor(AppColors.neutralMedium)
    }
    
    func smallStyle() -> some View {
        self.font(AppTypography.small)
            .foregroundColor(AppColors.neutralMedium)
    }
}