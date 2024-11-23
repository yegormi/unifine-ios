import APIClient
import ComposableArchitecture
import Foundation
import KeychainClient
import OSLog
import SessionClient
import SharedModels
import SwiftHelpers

@Reducer
public struct Register: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        var email = ""
        var password = ""
        var confirmPassword = ""
        var isLoading = false
        var isFormValid: Bool {
            self.email.isValidEmail && self.password.isValidPassword && self.password == self.confirmPassword
        }

        @Presents var destination: Destination.State?
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {
            case registerSuccessful(String)
        }

        public enum Internal {
            case authResponse(Result<AuthResponse, Error>)
        }

        public enum View: BindableAction {
            case binding(BindingAction<State>)
            case registerButtonTapped
        }
    }

    @Reducer(state: .equatable, .sendable)
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
                state.isLoading = false

                switch result {
                case let .success(response):
                    return .send(.delegate(.registerSuccessful(response.accessToken)))
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
                let request = AuthRequest(email: state.email, password: state.password)
                return try await self.api.signup(request)
            })))
        }
    }
}
