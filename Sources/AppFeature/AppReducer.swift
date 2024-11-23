import AuthFeature
import ComposableArchitecture
import Dependencies
import OSLog
import SharedModels
import SplashFeature
import TabsFeature

private let logger = Logger(subsystem: "AppFeature", category: "AppReducer")

@Reducer
public struct AppReducer: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        var destination = Destination.State.splash

        public init() {}
    }

    public enum Action {
        case destination(Destination.Action)
        case changeToDestination(Destination.State)
        case task
    }

    @Reducer(state: .equatable)
    public enum Destination {
        @ReducerCaseIgnored
        case splash
        case login(Login)
        case tabs(Tabs)
    }

    @Dependency(\.apiClient) var api

    @Dependency(\.session) var session

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.destination, action: \.destination) {
            Destination.body
        }

        Reduce { state, action in
            switch action {
            case .destination(.login(.delegate(.loginSuccessful))):
                state.destination = .tabs(Tabs.State())
                return .none
                
//            case .destination(.login(.path(.register(.delegate(.registerSuccessful))))):
//                state.destination = .tabs(Tabs.State())
//                return .none

            case .destination:
                return .none

            case let .changeToDestination(destination):
                state.destination = destination
                return .none

            case .task:
                return .run { send in
                    do {
                        if let storedAccessToken = try self.session.currentAccessToken() {
                            logger.info("Found access token in keychain, attempting to login...")
                            try self.session.setCurrentAccessToken(storedAccessToken)
                            let user = try await self.api.getCurrentUser()
                            self.session.authenticate(user)
                            logger.info("Logged in successfully!")
                            await send(.changeToDestination(.tabs(Tabs.State())))
                        } else {
                            await send(.changeToDestination(.login(Login.State())))
                            logger.info("Did not find a stored ID token, showing login screen.")
                        }
                    } catch {
                        logger.warning("An error occurred while trying to sign the user in: \(error)")
                        await send(.changeToDestination(.login(Login.State())))
                        try self.session.logout()
                    }

                    // Logout
                    for await user in self.session.currentUsers() where user == nil {
                        await send(.changeToDestination(.login(Login.State())))
                    }
                }
            }
        }
    }
}
