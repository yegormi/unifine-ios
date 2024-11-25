import ComposableArchitecture
import Foundation
import Styleguide
import SwiftHelpers
import SwiftUI
import SwiftUIHelpers
import UniformTypeIdentifiers

@ViewAction(for: CheckInput.self)
public struct CheckInputView: View {
    @Bindable public var store: StoreOf<CheckInput>

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    if let attachment = store.attachment {
                        HStack {
                            Image(systemName: "doc.fill")
                            Text(attachment.fullName)
                                .lineLimit(1)
                            Spacer()
                            Button {
                                send(.removeAttachment)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                    } else {
                        Button {
                            send(.uploadButtonTapped)
                        } label: {
                            HStack {
                                Image(systemName: "doc.fill")
                                Text("Upload file")
                                Text("(pdf only)")
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                        }
                        .disabled(!self.store.text.isEmpty)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                    }

                    Text("or")
                        .foregroundStyle(.secondary)

                    TextEditor(text: self.$store.text)
                        .disabled(self.store.attachment != nil)
                        .opacity(self.store.attachment != nil ? 0.5 : 1)
                        .frame(minHeight: 200)
                        .scrollContentBackground(.hidden)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .overlay(
                            Group {
                                if self.store.text.isEmpty {
                                    Text("Enter text to check")
                                        .foregroundStyle(.secondary)
                                        .padding(.leading, 5)
                                        .padding(.top, 8)
                                }
                            },
                            alignment: .topLeading
                        )
                }
            }
            .padding(40)
        }
        .sheet(isPresented: self.$store.showingDocumentPicker) {
            DocumentPicker(
                types: [.pdf],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case let .success(attachments):
                    if let attachment = attachments.first {
                        send(.fileAttached(attachment))
                    }
                case let .failure(error):
                    send(.documentPickerFailed(error))
                }
            }
        }
        .overlay(alignment: .bottom) {
            if self.store.isUploading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial)
            } else {
                Button {
                    send(.submitButtonTapped)
                } label: {
                    Text("Upload")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.primary(size: .fullWidth))
                .disabled(!self.store.isFormValid)
                .padding(15)
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
                )
            }
        }
    }
}
