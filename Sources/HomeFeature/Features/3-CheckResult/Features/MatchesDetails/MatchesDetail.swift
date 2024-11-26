import ComposableArchitecture
import Foundation
import SharedModels

@Reducer
public struct MatchesDetail: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        let matches: [Match]
    }

    public enum Action: ViewAction {
        case view(View)

        public enum View {
            case dismiss
        }
    }

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.dismiss):
                .none
            }
        }
    }
}
