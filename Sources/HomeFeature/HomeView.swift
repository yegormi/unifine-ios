import ComposableArchitecture
import Foundation
import Styleguide
import SwiftHelpers
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: Home.self)
public struct HomeView: View {
    @Bindable public var store: StoreOf<Home>

    public init(store: StoreOf<Home>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: self.$store.scope(state: \.path, action: \.path)) {
            ScrollView(.vertical) {
                if let checks = store.checks {
                    LazyVStack(spacing: 14) {
                        ForEach(checks) { check in
                            Button {
                                send(.checkTapped(check))
                            } label: {
                                CheckCard(check: check)
                            }
                        }
                    }
                } else if self.store.isLoading {
                    ProgressView()
                } else {
                    Text("There are no checks for now")
                }
            }
            .navigationTitle("Home")
            .toolbarTitleDisplayMode(.inlineLarge)
            .contentMargins(.all, 16, for: .scrollContent)
            .refreshable { await send(.task).finish() }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .task { await send(.task).finish() }
            .onFirstAppear { send(.onFirstAppear) }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        send(.addCheckButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .clipShape(Rectangle())
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        send(.logoutButtonTapped)
                    } label: {
                        Image(systemName: "iphone.and.arrow.right.outward")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .clipShape(Rectangle())
                    }
                }
            }
        } destination: { store in
            switch store.state {
            case .checkSetup:
                if let store = store.scope(state: \.checkSetup, action: \.checkSetup) {
                    CheckSetupView(store: store)
                        .navigationTitle("Setup")
                        .toolbarTitleDisplayMode(.inlineLarge)
                }
            case .checkInput:
                if let store = store.scope(state: \.checkInput, action: \.checkInput) {
                    CheckInputView(store: store)
                        .navigationTitle("Input")
                        .toolbarTitleDisplayMode(.inlineLarge)
                }
            }
        }
    }
}

#Preview {
    HomeView(store: Store(initialState: Home.State()) {
        Home()
    })
}
