import APIClient
import ComposableArchitecture
import Foundation
import OSLog
import SessionClient
import SharedModels

private let logger = Logger(subsystem: "CheckResult", category: "CheckResult")

@Reducer
public struct CheckResult: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        let check: Check
        var isChecking = false
        var matches: [Match]?

        @Presents var destination: Destination.State?

        public init(check: Check) {
            self.check = check
        }
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {
            case didDismiss
        }

        public enum Internal {
            case plagiarismCheckResponse(Result<[Match], Error>)
        }

        public enum View {
            case plagiarismCheckTapped
            case issueTapped(Check.Issue)
            case dismissButtonTapped
        }
    }

    @Reducer(state: .equatable, .sendable)
    public enum Destination {
        case issueDetail(IssueDetail)
        case matchesDetail(MatchesDetail)
    }

    @Dependency(\.apiClient) var api

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case let .internal(.plagiarismCheckResponse(result)):
                state.isChecking = false
                switch result {
                case let .success(matches):
                    state.matches = matches
                    state.destination = .matchesDetail(MatchesDetail.State(matches: matches))
                    return .none
                case let .failure(error):
                    logger.error("Failed to check for plagiarism: \(error)")
                    return .none
                }

            case .view(.plagiarismCheckTapped):
                state.isChecking = true
                return .run { [state] send in
                    await send(.internal(.plagiarismCheckResponse(Result {
                        try await self.api.getMatchesById(state.check.id)
                    })))
                }

            case let .view(.issueTapped(issue)):
                state.destination = .issueDetail(IssueDetail.State(issue: issue))
                return .none

            case .view(.dismissButtonTapped):
                return .send(.delegate(.didDismiss))

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
