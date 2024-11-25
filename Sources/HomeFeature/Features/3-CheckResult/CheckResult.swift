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

        public init(check: Check) {
            self.check = check
        }
    }

    public enum Action: ViewAction {
        case view(View)

        public enum View {
            case issueSelected(Check.Issue?)
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(.issueSelected(issue)):
                state.selectedIssue = issue
                return .none
            }
        }
    }
}
