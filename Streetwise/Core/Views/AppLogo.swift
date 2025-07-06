import SwiftUI

struct AppLogo: View {
    let size: CGFloat
    let showText: Bool
    
    init(size: CGFloat = 120, showText: Bool = true) {
        self.size = size
        self.showText = showText
    }
    
    var body: some View {
        VStack(spacing: DesignTokens.spacingM) {
            // Logo symbol
            ZStack {
                // Background circle
                Circle()
                    .fill(AppColors.primaryGradient)
                    .frame(width: size, height: size)
                    .shadow(
                        color: AppColors.primary.opacity(0.3),
                        radius: size * 0.1,
                        x: 0,
                        y: size * 0.05
                    )
                
                // Street pattern
                StreetsideSymbol(size: size * 0.6)
            }
            
            // App name
            if showText {
                Text("Streetside")
                    .font(.system(size: size * 0.23, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.primaryGradient)
            }
        }
    }
}

struct StreetsideSymbol: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Main street lines
            Group {
                // Horizontal street
                RoundedRectangle(cornerRadius: size * 0.08)
                    .fill(Color.white)
                    .frame(width: size * 0.8, height: size * 0.15)
                
                // Vertical street
                RoundedRectangle(cornerRadius: size * 0.08)
                    .fill(Color.white)
                    .frame(width: size * 0.15, height: size * 0.8)
            }
            
            // Curved corner connection
            Path { path in
                let cornerSize = size * 0.2
                let startPoint = CGPoint(x: size * 0.075, y: -size * 0.075)
                let endPoint = CGPoint(x: -size * 0.075, y: size * 0.075)
                let controlPoint = CGPoint(x: size * 0.15, y: size * 0.15)
                
                path.move(to: startPoint)
                path.addQuadCurve(to: endPoint, control: controlPoint)
            }
            .stroke(Color.white, style: StrokeStyle(lineWidth: size * 0.15, lineCap: .round))
            
            // Location pin
            LocationPin(size: size * 0.4)
                .offset(x: size * 0.1, y: -size * 0.1)
        }
    }
}

struct LocationPin: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Pin shape
            Path { path in
                let pinWidth = size
                let pinHeight = size * 1.2
                let topRadius = pinWidth * 0.5
                
                // Top circle
                path.addEllipse(in: CGRect(
                    x: -topRadius,
                    y: -topRadius,
                    width: topRadius * 2,
                    height: topRadius * 2
                ))
                
                // Bottom point
                path.move(to: CGPoint(x: -topRadius * 0.7, y: topRadius * 0.3))
                path.addLine(to: CGPoint(x: 0, y: pinHeight * 0.4))
                path.addLine(to: CGPoint(x: topRadius * 0.7, y: topRadius * 0.3))
                path.addArc(
                    center: CGPoint(x: 0, y: 0),
                    radius: topRadius,
                    startAngle: .degrees(30),
                    endAngle: .degrees(150),
                    clockwise: false
                )
            }
            .fill(AppColors.accentGradient)
            .shadow(
                color: .black.opacity(0.2),
                radius: 2,
                x: 0,
                y: 1
            )
            
            // Center dot
            Circle()
                .fill(Color.white)
                .frame(width: size * 0.3, height: size * 0.3)
                .offset(y: -size * 0.05)
        }
    }
}

// Animated logo for splash screen
struct AnimatedAppLogo: View {
    @State private var isAnimating = false
    @State private var rotationDegrees: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    let size: CGFloat
    
    init(size: CGFloat = 120) {
        self.size = size
    }
    
    var body: some View {
        AppLogo(size: size, showText: true)
            .scaleEffect(pulseScale)
            .rotationEffect(.degrees(rotationDegrees))
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        // Rotation animation
        withAnimation(
            Animation.linear(duration: 8)
                .repeatForever(autoreverses: false)
        ) {
            rotationDegrees = 360
        }
        
        // Pulse animation
        withAnimation(
            Animation.easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.1
        }
    }
}

// Mini logo for navigation bars
struct MiniAppLogo: View {
    var body: some View {
        StreetsideSymbol(size: 24)
    }
}

// Tab bar icon version
struct TabBarLogo: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(AppColors.primaryGradient)
                .frame(width: 28, height: 28)
            
            StreetsideSymbol(size: 16)
        }
    }
}

#Preview("App Logo") {
    VStack(spacing: 40) {
        AppLogo(size: 120, showText: true)
        AppLogo(size: 80, showText: false)
        MiniAppLogo()
        TabBarLogo()
    }
    .padding()
    .background(AppColors.background)
}

#Preview("Animated Logo") {
    AnimatedAppLogo(size: 150)
        .padding()
        .background(AppColors.primaryGradient)
}