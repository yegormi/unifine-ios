import APIClient
import ComposableArchitecture
import Foundation
import SharedModels

@Reducer
public struct Home: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        var checks: [CheckPreview]?
        var isLoading = false

        public init() {}
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {}

        public enum Internal {
            case checksResponse(Result<[CheckPreview], Error>)
        }

        public enum View: BindableAction {
            case binding(BindingAction<Home.State>)
            case onFirstAppear
            case task
            case logoutButtonTapped
        }
    }

    @Dependency(\.apiClient) var api

    @Dependency(\.uuid) var uuid

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)

        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case let .internal(.checksResponse(.success(checks))):
                state.checks = checks
                return .none

            case .internal:
                return .none

            case .view(.binding):
                return .none

            case .view(.onFirstAppear):
                return .none

            case .view(.task):
                return self.reload(&state)

            case .view(.logoutButtonTapped):
                return .none
            }
        }
    }

    private func reload(_ state: inout State) -> Effect<Action> {
        .run { [state] send in
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
