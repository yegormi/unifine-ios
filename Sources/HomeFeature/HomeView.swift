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
        ScrollView {
            EmptyTabView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentMargins(.all, 16, for: .scrollContent)
        .onAppear {
            send(.onAppear)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
//                    send(.settingsButtonTapped)
                } label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .padding(13)
                        .clipShape(Circle())
                }
            }
        }
        .onFirstAppear {
            send(.onFirstAppear)
        }
        .onAppear {
            send(.onAppear)
        }
    }
}

#Preview {
    HomeView(store: Store(initialState: Home.State()) {
        Home()
    })
}
