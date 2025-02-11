import SwiftUI

struct SettingsView: View {
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .padding()
            
            Button("Sign Out") {
                authManager.signOut()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
} 