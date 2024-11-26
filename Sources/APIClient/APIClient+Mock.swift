import SharedModels

public extension APIClient {
    static let mock = Self(
        signup: { _ in .mock },
        login: { _ in .mock },
        getCurrentUser: { .mock },
        createCheck: { _ in .mock },
        getAllChecks: {
            [.mock1, .mock2]
        },
        getCheck: { _ in .mock },
        deleteCheck: { _ in },
        getMatches: { _ in .init() }
    )
}
