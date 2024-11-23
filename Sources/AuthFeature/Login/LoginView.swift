import ComposableArchitecture
import Foundation
import Styleguide
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: Login.self)
public struct LoginView: View {
    @Bindable public var store: StoreOf<Login>

    public init(store: StoreOf<Login>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: self.$store.scope(state: \.path, action: \.path)) {
            ScrollView {
                VStack(spacing: 0) {
                    Text("Login")
                        .font(.system(size: 44, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 30)

                    VStack(spacing: 14) {
                        VStack(spacing: 4) {
                            Text("Email")
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Email", text: self.$store.email)
                                .textFieldStyle(.auth)
                                .textContentType(.emailAddress)
                        }
                        VStack(spacing: 4) {
                            Text("Password")
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            PasswordField("Password", text: self.$store.password)
                                .textFieldStyle(.auth)
                                .textContentType(.password)
                        }
                    }
                    .padding(.bottom, 14)

                    Button {
                        send(.registerButtonTapped)
                    } label: {
                        Text("Create new account")
                            .underline()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.blue)
                    .disabled(self.store.isLoading)
                }
            }
            .overlay(alignment: .bottom) {
                Button {
                    send(.loginButtonTapped)
                } label: {
                    Text("Login")
                }
                .buttonStyle(.primary(size: .fullWidth))
                .disabled(!self.store.isFormValid || self.store.isLoading)
            }
            .padding(40)
        } destination: { store in
            switch store.state {
            case .register:
                if let store = store.scope(state: \.register, action: \.register) {
                    RegisterView(store: store)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .isLoading(self.store.isLoading)
        .alert(self.$store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
}
