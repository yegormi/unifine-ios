import ComposableArchitecture
import Foundation
import Styleguide
import SwiftHelpers
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: CheckSetup.self)
public struct CheckSetupView: View {
    @Bindable public var store: StoreOf<CheckSetup>

    public init(store: StoreOf<CheckSetup>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("Topic")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter text topic", text: self.$store.topic)
                        .textFieldStyle(.auth)
                }

                VStack(spacing: 4) {
                    Text("Style")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Menu {
                        Picker("Style", selection: self.$store.style) {
                            ForEach(CheckSetup.State.Style.allCases, id: \.self) { style in
                                Text(style.rawValue).tag(style)
                            }
                        }
                    } label: {
                        HStack {
                            Text(self.store.style.rawValue)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .padding(.horizontal, 5)
                        }
                        .tint(Color.primary)
                        .padding(12)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.systemBackground))
                                .stroke(Color.primary, lineWidth: 1)
                        )
                    }
                }

                VStack(spacing: 4) {
                    Text("Excluded words")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField(
                        "Enter text excluded words",
                        text: self.$store.excludedWords,
                        axis: .vertical
                    )
                    .lineLimit(5, reservesSpace: true)
                    .textFieldStyle(.auth)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .padding(30)
        .overlay(alignment: .bottom) {
            Button {
                send(.nextButtonTapped)
            } label: {
                Text("Next")
            }
            .buttonStyle(.primary(size: .fullWidth))
            .padding(15)
            .padding(.horizontal, 15)
            .background(
                Rectangle()
                    .fill(Color.orangePrimary.opacity(0.2))
                    .clipShape(
                        .rect(
                            topLeadingRadius: 14,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 14
                        )
                    )
                    .ignoresSafeArea(.container)
            )
        }
    }
}

#Preview {
    NavigationStack {
        CheckSetupView(
            store: Store(initialState: CheckSetup.State()) {
                CheckSetup()
            }
        )
    }
}
