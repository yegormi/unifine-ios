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
    public var getCheck: @Sendable (Check.ID) async throws -> Check
    public var deleteCheck: @Sendable (Check.ID) async throws -> Void

    // Match Operations
    public var getMatchesById: @Sendable (Check.ID) async throws -> [Match]
}

public extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
