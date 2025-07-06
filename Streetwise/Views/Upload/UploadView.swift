import SwiftUI
import AVFoundation

struct UploadView: View {
    @State private var selectedMode: CameraMode = .photo
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var capturedImage: UIImage?
    @State private var isRecording = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top controls
                UploadHeaderView()
                
                // Camera viewfinder area
                CameraViewfinderArea()
                
                // Bottom controls
                UploadControlsView(
                    selectedMode: $selectedMode,
                    showingImagePicker: $showingImagePicker,
                    showingCamera: $showingCamera,
                    isRecording: $isRecording
                )
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $capturedImage)
        }
    }
}

enum CameraMode: String, CaseIterable {
    case photo = "Photo"
    case story = "Story"
    case video = "Video"
    case live = "Live"
    
    var icon: String {
        switch self {
        case .photo: return "camera"
        case .story: return "circle.dashed"
        case .video: return "video"
        case .live: return "dot.radiowaves.left.and.right"
        }
    }
}

struct UploadHeaderView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.white)
            
            Spacer()
            
            HStack(spacing: DesignTokens.spacingL) {
                Text("LIVE")
                    .font(AppTypography.caption.weight(.bold))
                    .foregroundColor(.white)
                
                Text("PHOTO")
                    .font(AppTypography.caption.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 2)
                    .overlay(
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 2),
                        alignment: .bottom
                    )
                
                Text("REEL")
                    .font(AppTypography.caption.weight(.bold))
                    .foregroundColor(.white)
                
                Text("VIDEO")
                    .font(AppTypography.caption.weight(.bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                // Settings
            }) {
                Image(systemName: "gearshape")
                    .foregroundColor(.white)
                    .font(.title2)
            }
        }
        .padding(.horizontal, DesignTokens.spacingL)
        .padding(.top, DesignTokens.spacingM)
    }
}

struct CameraViewfinderArea: View {
    var body: some View {
        ZStack {
            // Mock camera viewfinder
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .overlay(
                    VStack {
                        Text("Camera Viewfinder")
                            .font(AppTypography.titleLarge)
                            .foregroundColor(.white)
                        
                        Text("Camera access would be implemented here")
                            .font(AppTypography.body)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                )
            
            // Focus indicator (mock)
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.yellow, lineWidth: 2)
                .frame(width: 80, height: 80)
                .opacity(0.8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct UploadControlsView: View {
    @Binding var selectedMode: CameraMode
    @Binding var showingImagePicker: Bool
    @Binding var showingCamera: Bool
    @Binding var isRecording: Bool
    
    var body: some View {
        VStack(spacing: DesignTokens.spacingL) {
            // Camera controls
            HStack {
                // Gallery button
                Button(action: {
                    showingImagePicker = true
                }) {
                    RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusSmall)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "photo.on.rectangle")
                                .foregroundColor(.white)
                                .font(.title2)
                        )
                }
                
                Spacer()
                
                // Capture button
                CaptureButton(
                    mode: selectedMode,
                    isRecording: $isRecording
                ) {
                    handleCapture()
                }
                
                Spacer()
                
                // Camera switch button
                Button(action: {
                    // Switch camera
                }) {
                    Image(systemName: "camera.rotate")
                        .foregroundColor(.white)
                        .font(.title)
                        .frame(width: 50, height: 50)
                }
            }
            .padding(.horizontal, DesignTokens.spacingXL)
            
            // Mode selector
            HStack(spacing: DesignTokens.spacingXL) {
                ForEach(CameraMode.allCases, id: \.self) { mode in
                    VStack(spacing: DesignTokens.spacingXS) {
                        Image(systemName: mode.icon)
                            .foregroundColor(selectedMode == mode ? AppColors.accent : .white)
                            .font(.title2)
                        
                        Text(mode.rawValue)
                            .font(AppTypography.caption)
                            .foregroundColor(selectedMode == mode ? AppColors.accent : .white)
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: DesignTokens.animationFast)) {
                            selectedMode = mode
                        }
                    }
                }
            }
            
            // Post-processing tools
            HStack(spacing: DesignTokens.spacingXL) {
                PostProcessingTool(icon: "slider.horizontal.3", title: "Filter")
                PostProcessingTool(icon: "textformat", title: "Text")
                PostProcessingTool(icon: "music.note", title: "Music")
                PostProcessingTool(icon: "location", title: "Location")
                PostProcessingTool(icon: "person.2", title: "Tag")
            }
            .padding(.bottom, DesignTokens.spacingL)
        }
        .padding(.vertical, DesignTokens.spacingL)
        .background(Color.black.opacity(0.8))
    }
    
    private func handleCapture() {
        switch selectedMode {
        case .photo:
            // Handle photo capture
            break
        case .story:
            // Handle story capture
            break
        case .video:
            // Handle video recording
            withAnimation(.easeInOut(duration: DesignTokens.animationFast)) {
                isRecording.toggle()
            }
        case .live:
            // Handle live streaming
            break
        }
    }
}

struct CaptureButton: View {
    let mode: CameraMode
    @Binding var isRecording: Bool
    let onCapture: () -> Void
    
    var body: some View {
        Button(action: onCapture) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .fill(isRecording && mode == .video ? .red : Color.white)
                    .frame(width: isRecording && mode == .video ? 30 : 70, height: isRecording && mode == .video ? 30 : 70)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.2), lineWidth: 2)
                    )
                
                if mode == .live {
                    Circle()
                        .fill(.red)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text("LIVE")
                                .font(AppTypography.caption.weight(.bold))
                                .foregroundColor(.white)
                        )
                }
            }
        }
        .scaleEffect(isRecording ? 1.1 : 1.0)
        .animation(.easeInOut(duration: DesignTokens.animationFast), value: isRecording)
    }
}

struct PostProcessingTool: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: DesignTokens.spacingXS) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.title2)
            
            Text(title)
                .font(AppTypography.small)
                .foregroundColor(.white)
        }
        .onTapGesture {
            // Handle tool selection
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    UploadView()
}