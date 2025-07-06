import SwiftUI

struct AppColors {
    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "1E3A8A"), Color(hex: "7C3AED")],
        startPoint: .topLeading, 
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [Color(hex: "F59E0B"), Color(hex: "EC4899")],
        startPoint: .leading, 
        endPoint: .trailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [Color(hex: "06B6D4"), Color(hex: "3B82F6")],
        startPoint: .leading, 
        endPoint: .trailing
    )
    
    static let neutralLight = Color(hex: "F8FAFC")
    static let neutralMedium = Color(hex: "64748B")
    static let neutralDark = Color(hex: "1E293B")
    
    static let primary = Color(hex: "1E3A8A")
    static let secondary = Color(hex: "7C3AED")
    static let accent = Color(hex: "06B6D4")
    
    static let background = Color(hex: "F8FAFC")
    static let surface = Color.white
    static let error = Color(hex: "EF4444")
    static let success = Color(hex: "10B981")
    static let warning = Color(hex: "F59E0B")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}