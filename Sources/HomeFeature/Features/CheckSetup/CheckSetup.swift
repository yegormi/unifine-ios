import APIClient
import ComposableArchitecture
import Foundation
import OSLog
import SessionClient
import SharedModels

@Reducer
public struct CheckSetup: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        public enum Style: String, Equatable, Sendable, CaseIterable {
            case formal = "Formal"
            case informal = "Informal"
            case neutral = "Neutral"
        }

        var topic = ""
        var style: Style = .neutral
        var excludedWords = ""

        var isFormValid: Bool {
            !self.topic.isEmpty
        }

        public init() {}
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case view(View)

        public enum Delegate {
            case didFinishSetup(CreateCheckRequest)
        }

        public enum View: BindableAction {
            case binding(BindingAction<State>)
            case nextButtonTapped
        }
    }

    public init() {}

    @Dependency(\.uuid) var uuid

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)

        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case .view(.binding):
                return .none

            case .view(.nextButtonTapped):
                let check = CreateCheckRequest(
                    topic: state.topic,
                    style: state.style.rawValue.capitalized,
                    excludedWords: state.excludedWords
                )
                return .send(.delegate(.didFinishSetup(check)))
            }
        }
    }
}
