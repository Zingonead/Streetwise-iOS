import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    @State private var progressValue: Double = 0.0
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: DesignTokens.spacingXL) {
                Spacer()
                
                // Logo
                StreetsideLogo()
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            logoScale = 1.0
                            logoOpacity = 1.0
                        }
                    }
                
                VStack(spacing: DesignTokens.spacingM) {
                    Text("Loading...")
                        .font(AppTypography.body)
                        .foregroundColor(.white.opacity(0.8))
                    
                    ProgressView(value: progressValue)
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .frame(width: 200)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2.0)) {
                                progressValue = 1.0
                            }
                        }
                }
                
                Spacer()
            }
        }
    }
}

struct StreetsideLogo: View {
    var body: some View {
        VStack(spacing: DesignTokens.spacingM) {
            ZStack {
                // Background circle
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                // Street icon representation
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white)
                            .frame(width: 30, height: 4)
                        
                        Circle()
                            .fill(AppColors.accentGradient)
                            .frame(width: 16, height: 16)
                    }
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(width: 4, height: 30)
                }
            }
            
            Text("Streetside")
                .font(AppTypography.displayLarge)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    SplashView()
}