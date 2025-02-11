import Foundation

struct User: Codable {
    let id: String
    let email: String
    let name: String?
    let photoURL: String?
    let provider: AuthProvider
}

enum AuthProvider: String, Codable {
    case google
    case apple
    case email
} 