import ComposableArchitecture
import Foundation
import Styleguide
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: Register.self)
public struct RegisterView: View {
    @Bindable public var store: StoreOf<Register>

    public init(store: StoreOf<Register>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Create Account")
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
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }

                    VStack(spacing: 4) {
                        Text("Password")
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        PasswordField("Password", text: self.$store.password)
                            .textFieldStyle(.auth)
                            .textContentType(.newPassword)
                    }

                    VStack(spacing: 4) {
                        Text("Confirm Password")
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        PasswordField("Confirm Password", text: self.$store.confirmPassword)
                            .textFieldStyle(.auth)
                            .textContentType(.newPassword)
                    }
                }
                .padding(.bottom, 14)
            }
        }
        .overlay(alignment: .bottom) {
            Button {
                send(.registerButtonTapped)
            } label: {
                Text("Create")
            }
            .buttonStyle(.primary(size: .fullWidth))
            .disabled(!self.store.isFormValid || self.store.isLoading)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .isLoading(self.store.isLoading)
        .alert(self.$store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
}

#Preview {
    RegisterView(
        store: Store(
            initialState: Register.State()
        ) {
            Register()
        }
    )
}
