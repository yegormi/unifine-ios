import APIClient
import ComposableArchitecture
import Foundation
import OSLog
import SessionClient
import SharedModels

@Reducer
public struct CheckResult: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        let check: Check
        var selectedIssue: Check.Issue?
        var matches: [Match]?
        var isChecking = false

        var showingMatchSheet = false

        public init(check: Check) {
            self.check = check
        }
    }

    public enum Action: ViewAction {
        case `internal`(Internal)
        case view(View)

        public enum Internal {
            case plagiarismCheckResponse(Result<[Match], Error>)
        }

        public enum View {
            case issueSelected(Check.Issue?)
            case plagiarismCheckTapped
            case dismissMatchSheet
        }
    }

    @Dependency(\.apiClient) var api

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .internal(.plagiarismCheckResponse(result)):
                state.isChecking = false

                switch result {
                case let .success(matches):
                    state.matches = matches
                    state.showingMatchSheet = true
                    return .none
                case let .failure(error):
                    os_log(.error, log: .default, "Failed to check for plagiarism: %@", error.localizedDescription)
                    return .none
                }
            case let .view(.issueSelected(issue)):
                state.selectedIssue = issue
                return .none
            case .view(.plagiarismCheckTapped):
                state.isChecking = true
                return .run { [state] send in
                    await send(.internal(.plagiarismCheckResponse(Result {
                        try await self.api.getMatchesById(state.check.id)
                    })))
                }
            case .view(.dismissMatchSheet):
                state.showingMatchSheet = false
                return .none
            }
        }
    }
}
