import APIClient
import ComposableArchitecture
import Foundation
import KeychainClient
import OSLog
import SessionClient
import SharedModels
import SwiftHelpers

@Reducer
public struct Login: Reducer {
    @ObservableState
    public struct State: Equatable {
        var path: StackState<Path.State>

        var email = ""
        var password = ""
        var isLoading = false
        var isFormValid: Bool {
            return self.email.isValidEmail && !self.password.isEmpty
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
            case authResponse(Result<Void, Error>)
        }

        public enum View: BindableAction {
            case binding(BindingAction<State>)
            case loginButtonTapped
            case registerButtonTapped
        }
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        case register(Register)
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
            case .path(.element(id: _, action: .register(.delegate(.registerSuccessful)))):
                return .send(.delegate(.loginSuccessful))
            
            case .path:
                return .none
                
            case .delegate:
                return .none

            case .destination:
                return .none

            case let .internal(.authResponse(result)):
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
                // Implement login logic here
                return Void()
            })))
        }
    }
}
