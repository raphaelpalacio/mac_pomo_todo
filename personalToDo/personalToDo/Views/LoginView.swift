import SwiftUI

struct LoginView: View {
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to PersonalToDo")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button(action: {
                Task {
                    try? await authManager.signInWithGoogle()
                }
            }) {
                HStack {
                    Image(systemName: "g.circle.fill")
                    Text("Sign in with Google")
                }
                .frame(maxWidth: 300)
            }
            .buttonStyle(.borderedProminent)
            
            Button(action: {
                Task {
                    try? await authManager.signInWithApple()
                }
            }) {
                HStack {
                    Image(systemName: "apple.logo")
                    Text("Sign in with Apple")
                }
                .frame(maxWidth: 300)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(width: 400, height: 300)
    }
} 