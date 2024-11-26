import APIClient
import Dependencies
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import SharedModels
import SwiftHelpers
import XCTestDynamicOverlay

private func throwingUnderlyingError<T>(_ closure: () async throws -> T) async throws -> T {
    do {
        return try await closure()
    } catch let error as ClientError {
        throw error.underlyingError
    }
}

extension APIClient: DependencyKey {
    public static var liveValue: Self {
        let client = Client(
            serverURL: try! Servers.Server1.url(), // swiftlint:disable:this force_try
            configuration: Configuration(
                dateTranscoder: .iso8601WithFractions
            ),
            transport: URLSessionTransport(),
            middlewares: [
                ErrorMiddleware(),
                AuthenticationMiddleware(),
                LoggingMiddleware(bodyLoggingConfiguration: .upTo(maxBytes: 1024)),
            ]
        )

        return APIClient(
            signup: { request in
                try await throwingUnderlyingError {
                    try await client.signup(body: .json(request.toAPI()))
                        .created
                        .body
                        .json
                        .toDomain()
                }
            },
            login: { request in
                try await throwingUnderlyingError {
                    try await client.login(body: .json(request.toAPI()))
                        .ok
                        .body
                        .json
                        .toDomain()
                }
            },
            getCurrentUser: {
                try await throwingUnderlyingError {
                    try await client.getMe()
                        .ok
                        .body
                        .json
                        .toDomain()
                }
            },
            createCheck: { request in
                try await throwingUnderlyingError {
                    try await client.createCheck(body: .multipartForm(request.toMultipartForm()))
                        .created
                        .body
                        .json
                        .toDomain()
                }
            },
            getAllChecks: {
                try await throwingUnderlyingError {
                    try await client.getChecks()
                        .ok
                        .body
                        .json
                        .map { $0.toDomain() }
                }
            },
            getCheck: { id in
                try await throwingUnderlyingError {
                    try await client.getCheckById(path: .init(id: id))
                        .ok
                        .body
                        .json
                        .toDomain()
                }
            },
            deleteCheck: { id in
                try await throwingUnderlyingError {
                    _ = try await client.deleteCheckById(path: .init(id: id))
                        .noContent
                }
            },
            getMatches: { id in
                try await throwingUnderlyingError {
                    try await client.getMatchesForCheck(path: .init(checkId: id))
                        .ok
                        .body
                        .json
                        .map { $0.toDomain() }
                }
            }
        )
    }
}
