import APIClient
import ComposableArchitecture
import Foundation
import KeychainClient
import OSLog
import SessionClient
import SharedModels
import SwiftHelpers

@Reducer
public struct Register: Reducer {
    @ObservableState
    public struct State: Equatable {
        var email = ""
        var password = ""
        var confirmPassword = ""
        var isLoading = false
        var isFormValid: Bool {
            return self.email.isValidEmail && !self.password.isEmpty && self.password == self.confirmPassword
        }
        @Presents var destination: Destination.State?
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {
            case registerSuccessful
        }

        public enum Internal {
            case authResponse(Result<Void, Error>)
        }

        public enum View: BindableAction {
            case binding(BindingAction<State>)
            case registerButtonTapped
        }
    }

    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Never>)
    }

    @Dependency(\.apiClient) var api
    @Dependency(\.session) var session
    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case .destination:
                return .none

            case let .internal(.authResponse(result)):
                switch result {
                case .success:
                    return .send(.delegate(.registerSuccessful))
                case let .failure(error):
                    state.destination = .alert(.failedToAuth(error: error))
                    return .none
                }

            case .view(.binding):
                return .none

            case .view(.registerButtonTapped):
                return self.register(&state)
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func register(_ state: inout State) -> Effect<Action> {
        guard state.isFormValid, !state.isLoading else { return .none }
        state.isLoading = true

        return .run { [state] send in
            await send(.internal(.authResponse(Result {
                // Implement registration logic here
                return Void()
            })))
        }
    }
}
