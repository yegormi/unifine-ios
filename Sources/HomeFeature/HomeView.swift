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
        ScrollView(.vertical) {
            if let checks = self.store.checks {
                LazyVStack(spacing: 14) {
                    ForEach(checks) { check in
                        Button {
//                            send(.courseTapped(course))
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
        .refreshable { await send(.task).finish() }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentMargins(.all, 16, for: .scrollContent)
        .task { await send(.task).finish() }
        .onFirstAppear { send(.onFirstAppear) }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    send(.logoutButtonTapped)
                } label: {
                    Image(systemName: "iphone.and.arrow.right.outward")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .padding(13)
                        .clipShape(Circle())
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
