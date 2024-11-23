import Dependencies
import DependenciesMacros
import SharedModels
import SwiftUI
import XCTestDynamicOverlay

@DependencyClient
public struct APIClient: Sendable {
    // User Operations
    public var signup: @Sendable (AuthRequest) async throws -> AuthResponse
    public var login: @Sendable (AuthRequest) async throws -> AuthResponse
    public var getCurrentUser: @Sendable () async throws -> User

    // Check Operations
    public var createCheck: @Sendable (CreateCheckRequest) async throws -> Check
    public var getAllChecks: @Sendable () async throws -> [CheckPreview]
    public var getCheck: @Sendable (String) async throws -> Check
    public var deleteCheck: @Sendable (String) async throws -> Void
}

public extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
