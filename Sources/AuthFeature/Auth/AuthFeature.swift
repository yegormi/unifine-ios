import APIClient
import ComposableArchitecture
import Foundation
import KeychainClient
import OSLog
import SessionClient
import SharedModels
import SwiftHelpers

private let logger = Logger(subsystem: "AuthenticationFeature", category: "Auth")

@Reducer
public struct AuthFeature: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        public init() {}

        var authType: AuthType = .signIn
        var email = ""
        var password = ""
        var confirmPassword = ""
        var rawNonce = ""
        var isLoading = false
        @Presents var destination: Destination.State?

        /// Checks if the form inputs are valid based on the authentication type:
        /// - Requires a valid email format and non-empty password.
        /// - For `.signIn`, only email and password are required.
        /// - Otherwise, `password` must match `confirmPassword`.
        var isFormValid: Bool {
            guard self.email.isValidEmail, !self.password.isEmpty else { return false }
            return self.authType == .signIn || self.password == self.confirmPassword
        }

        mutating func regenerateNonce() {
            self.rawNonce = randomNonceString()
        }
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {
            case authSuccessful
        }

        public enum Internal {
            case localAuthResponse(Result<Void, Error>)
            case authResponse(Result<Void, Error>)
        }

        public enum View: BindableAction {
            case binding(BindingAction<AuthFeature.State>)
            case toggleButtonTapped
            case loginButtonTapped
            case signupButtonTapped
        }
    }

    @Reducer(state: .equatable, .sendable, action: .equatable, .sendable)
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

            case let .internal(.localAuthResponse(result)):
                switch result {
                case .success:
                    logger.info("Authenticated the user successfully!")
                    return .send(.delegate(.authSuccessful))
                case let .failure(error):
                    logger.error("Failed to perform an action, error: \(error)")
                    state.destination = .alert(.failedToAuth(error: error))
                    return .none
                }

            case let .internal(.authResponse(result)):
                return .none

            case .view(.binding):
                return .none

            case .view(.toggleButtonTapped):
                state.authType.toggle()
                state.confirmPassword = ""
                return .none

            case .view(.loginButtonTapped):
                return self.login(&state)

            case .view(.signupButtonTapped):
                return self.signup(&state)
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func login(_ state: inout State) -> Effect<Action> {
        guard state.isFormValid, !state.isLoading else { return .none }
        state.isLoading = true

        return .run { [state] send in
            await send(.internal(.authResponse(Result {
                ()
            })))
        }
    }

    private func signup(_ state: inout State) -> Effect<Action> {
        guard state.isFormValid, !state.isLoading else { return .none }
        state.isLoading = true

        return .run { [state] send in
            await send(.internal(.authResponse(Result {
                ()
            })))
        }
    }
}
