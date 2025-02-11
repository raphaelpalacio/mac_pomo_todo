import Foundation
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices
import AppKit

class AuthManager: NSObject, ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    static let shared = AuthManager()
    
    private override init() {
        super.init()
        // Restore previous sign-in if it exists
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if let user = user {
                self?.handleGoogleUser(user)
            }
        }
    }
    
    func signInWithGoogle() async throws {
        let signInConfig = GIDConfiguration(clientID: "YOUR-CLIENT-ID.apps.googleusercontent.com")
        
        guard let window = NSApplication.shared.windows.first else {
            throw AuthError.noViewController
        }
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            GIDSignIn.sharedInstance.signIn(
                withPresenting: window as NSWindow
            ) { [weak self] (signInResult: GIDSignInResult?, error: Error?) in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let signInResult = signInResult else {
                    continuation.resume(throwing: NSError(domain: "", code: -1))
                    return
                }
                
                self?.handleGoogleUser(signInResult.user)
                continuation.resume()
            }
        }
    }
    
    private func handleGoogleUser(_ user: GIDGoogleUser) {
        guard let profile = user.profile else { return }
        
        let appUser = User(
            id: user.userID ?? UUID().uuidString,
            email: profile.email,
            name: profile.name,
            photoURL: profile.imageURL(withDimension: 100)?.absoluteString,
            provider: .google
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.currentUser = appUser
            self?.isAuthenticated = true
        }
    }
    
    // Comment out or remove Apple Sign In related methods
    /* 
    func signInWithApple() async throws {
        // ... code ...
    }
    
    func authorizationController(...) {
        // ... code ...
    }
    */
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        
        DispatchQueue.main.async { [weak self] in
            self?.currentUser = nil
            self?.isAuthenticated = false
        }
    }
}

// MARK: - Window Provider for Apple Sign In
class WindowProvider: NSObject, ASAuthorizationControllerPresentationContextProviding {
    static let shared = WindowProvider()
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = NSApplication.shared.windows.first else {
            fatalError("No window available")
        }
        return window
    }
}

enum AuthError: Error {
    case noViewController
    case signInFailed(Error)
} 
