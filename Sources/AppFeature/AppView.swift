import AuthFeature
import ComposableArchitecture
import HomeFeature
import SplashFeature
import SwiftUI

public struct AppView: View {
    let store: StoreOf<AppReducer>

    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }

    public var body: some View {
        Group {
            switch self.store.destination {
            case .splash:
                SplashScreen()
            case .login:
                if let store = self.store.scope(state: \.destination.login, action: \.destination.login) {
                    LoginView(store: store)
                }
            case .home:
                if let store = self.store.scope(state: \.destination.home, action: \.destination.home) {
                    HomeView(store: store)
                }
            }
        }
        .animation(.smooth, value: self.store.destination)
        .task { await self.store.send(.task).finish() }
    }
}

#Preview {
    AppView(store: Store(initialState: AppReducer.State()) {
        AppReducer()
    })
}
