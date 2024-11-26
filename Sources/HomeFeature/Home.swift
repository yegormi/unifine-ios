import APIClient
import ComposableArchitecture
import Foundation
import OSLog
import SessionClient
import SharedModels

private let logger = Logger(subsystem: "HomeFeature", category: "Home")

@Reducer
public struct Home: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        var path: StackState<Path.State>

        var checks: [CheckPreview]?
        var isLoading = false
        var isLoadingCheck = false

        public init() {
            self.path = StackState<Path.State>()
        }
    }

    public enum Action: ViewAction {
        case path(StackAction<Path.State, Path.Action>)
        case delegate(Delegate)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {}

        public enum Internal {
            case checksResponse(Result<[CheckPreview], Error>)
            case selectedCheckResponse(Result<Check, Error>)
        }

        public enum View: BindableAction {
            case binding(BindingAction<Home.State>)
            case onFirstAppear
            case task
            case addCheckButtonTapped
            case logoutButtonTapped
            case checkTapped(CheckPreview)
        }
    }

    @Reducer(state: .equatable, .sendable)
    public enum Path {
        case checkSetup(CheckSetup)
        case checkInput(CheckInput)
        case checkResult(CheckResult)
    }

    @Dependency(\.apiClient) var api

    @Dependency(\.session) var session

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)

        Reduce { state, action in
            switch action {
            case let .path(.element(id: _, action: .checkSetup(.delegate(.didFinishSetup(checkRequest))))):
                state.path.append(.checkInput(CheckInput.State(request: checkRequest)))
                return .none

            case let .path(.element(id: _, action: .checkInput(.delegate(.didReceiveSummary(check))))):
                state.path.append(.checkResult(CheckResult.State(check: check)))
                return .none

            case .path(.element(id: _, action: .checkResult(.delegate(.didDismiss)))):
                state.path.removeAll()
                return .none

            case .path:
                return .none

            case .delegate:
                return .none

            case let .internal(.checksResponse(.success(checks))):
                state.isLoading = false

                state.checks = checks
                return .none

            case let .internal(.selectedCheckResponse(result)):
                state.isLoadingCheck = false

                switch result {
                case let .success(check):
                    state.path.append(.checkResult(CheckResult.State(check: check)))
                    return .none
                case let .failure(error):
                    logger.error("Failed to get check: \(error)")
                    return .none
                }

            case .internal:
                return .none

            case .view(.binding):
                return .none

            case .view(.onFirstAppear):
                return .none

            case .view(.task):
                return self.reload(&state)

            case .view(.addCheckButtonTapped):
                state.path.append(.checkSetup(CheckSetup.State()))
                return .none

            case .view(.logoutButtonTapped):
                return .run { _ in
                    do {
                        try self.session.logout()
                    } catch {
                        logger.error("Failed to log out: \(error)")
                    }
                }

            case let .view(.checkTapped(check)):
                state.isLoadingCheck = true

                return .run { send in
                    await send(.internal(.selectedCheckResponse(Result {
                        try await self.api.getCheck(check.id)
                    })))
                }
            }
        }
        .forEach(\.path, action: \.path)
    }

    private func reload(_ state: inout State) -> Effect<Action> {
        guard !state.isLoading else { return .none }
        state.isLoading = true

        return .run { send in
            await withDiscardingTaskGroup { group in
                group.addTask {
                    await send(.internal(.checksResponse(Result {
                        try await self.api.getAllChecks()
                    })))
                }
            }
        }
    }
}
