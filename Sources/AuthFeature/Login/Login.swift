import APIClient
import ComposableArchitecture
import Foundation
import KeychainClient
import OSLog
import SessionClient
import SharedModels
import SwiftHelpers

@Reducer
public struct Login: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        var path: StackState<Path.State>

        var email = ""
        var password = ""
        var isLoading = false
        var isFormValid: Bool {
            self.email.isValidEmail && self.password.isValidPassword
        }

        @Presents var destination: Destination.State?

        public init() {
            self.path = StackState<Path.State>()
        }
    }

    public enum Action: ViewAction {
        case path(StackAction<Path.State, Path.Action>)
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {
            case loginSuccessful
        }

        public enum Internal {
            case authResponse(Result<AuthResponse, Error>)
            case sessionResponse(Result<Void, Error>)
        }

        public enum View: BindableAction {
            case binding(BindingAction<State>)
            case loginButtonTapped
            case registerButtonTapped
        }
    }

    @Reducer(state: .equatable, .sendable)
    public enum Path {
        case register(Register)
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
            case let .path(.element(id: _, action: .register(.delegate(.registerSuccessful(accessToken))))):
                return self.authenticate(with: accessToken, &state)

            case .path:
                return .none

            case .delegate:
                return .none

            case .destination:
                return .none

            case let .internal(.authResponse(result)):
                state.isLoading = false

                switch result {
                case let .success(response):
                    return self.authenticate(with: response.accessToken, &state)
                case let .failure(error):
                    state.destination = .alert(.failedToAuth(error: error))
                    return .none
                }

            case let .internal(.sessionResponse(result)):
                switch result {
                case .success:
                    return .send(.delegate(.loginSuccessful))
                case let .failure(error):
                    state.destination = .alert(.failedToAuth(error: error))
                    return .none
                }

            case .view(.binding):
                return .none

            case .view(.loginButtonTapped):
                return self.login(&state)

            case .view(.registerButtonTapped):
                state.path.append(.register(Register.State()))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.path, action: \.path)
    }

    private func login(_ state: inout State) -> Effect<Action> {
        guard state.isFormValid, !state.isLoading else { return .none }
        state.isLoading = true

        return .run { [state] send in
            await send(.internal(.authResponse(Result {
                let request = AuthRequest(email: state.email, password: state.password)
                return try await self.api.login(request)
            })))
        }
    }

    private func authenticate(with accessToken: String, _: inout State) -> Effect<Action> {
        .run { send in
            await send(.internal(.sessionResponse(Result {
                try self.session.setCurrentAccessToken(accessToken)
                let user = try await self.api.getCurrentUser()
                self.session.authenticate(user)
            })))
        }
    }
}
