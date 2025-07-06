import SwiftUI

struct InterestSelectionView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedInterests: Set<String> = []
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 3)
    private let minimumSelections = 3
    
    var body: some View {
        VStack(spacing: DesignTokens.spacingL) {
            // Header
            VStack(spacing: DesignTokens.spacingS) {
                Text("Choose Your Interests")
                    .font(AppTypography.titleLarge)
                    .foregroundColor(AppColors.neutralDark)
                
                Text("Select at least \(minimumSelections) interests to personalize your experience")
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.neutralMedium)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, DesignTokens.spacingL)
            
            // Interests grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: DesignTokens.spacingM) {
                    ForEach(Interest.allInterests) { interest in
                        InterestCard(
                            interest: interest,
                            isSelected: selectedInterests.contains(interest.id)
                        ) {
                            toggleInterest(interest.id)
                        }
                    }
                }
                .padding(.horizontal, DesignTokens.spacingL)
            }
            
            // Selection counter and continue button
            VStack(spacing: DesignTokens.spacingM) {
                Text("\(selectedInterests.count)/\(Interest.allInterests.count) selected")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.neutralMedium)
                
                Button("Continue") {
                    let selectedInterestObjects = Interest.allInterests.filter { selectedInterests.contains($0.id) }
                    authManager.completeInterestSelection(interests: selectedInterestObjects)
                }
                .primaryButtonStyle()
                .disabled(selectedInterests.count < minimumSelections)
                .padding(.horizontal, DesignTokens.spacingL)
            }
        }
        .padding(.vertical, DesignTokens.spacingL)
        .background(AppColors.background)
    }
    
    private func toggleInterest(_ interestId: String) {
        withAnimation(.easeInOut(duration: DesignTokens.animationFast)) {
            if selectedInterests.contains(interestId) {
                selectedInterests.remove(interestId)
            } else {
                selectedInterests.insert(interestId)
            }
        }
    }
}

struct InterestCard: View {
    let interest: Interest
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: DesignTokens.spacingS) {
                // Emoji
                Text(interest.emoji)
                    .font(.system(size: 32))
                
                // Name
                Text(interest.name)
                    .font(AppTypography.caption)
                    .foregroundColor(isSelected ? .white : AppColors.neutralDark)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusMedium)
                    .fill(isSelected ? AppColors.primaryGradient : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusMedium)
                            .stroke(
                                isSelected ? Color.clear : AppColors.neutralMedium.opacity(0.3),
                                lineWidth: 1
                            )
                    )
            )
            .scaleEffect(isSelected ? 0.95 : 1.0)
            .shadow(
                color: isSelected ? AppColors.primary.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 8 : 4,
                x: 0,
                y: 2
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    InterestSelectionView()
        .environmentObject(AuthenticationManager())
}