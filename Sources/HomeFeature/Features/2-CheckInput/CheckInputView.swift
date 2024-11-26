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
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                    } else {
                        Button {
                            send(.uploadButtonTapped)
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName: "document")
                                    .padding(.trailing, 5)
                                Text("Upload file")
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(.trailing, 4)
                                Text("(pdf only*)")
                                    .font(.system(size: 10, weight: .semibold))
                                Spacer()
                            }
                        }
                        .disabled(!self.store.text.isEmpty)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                    }

                    Text("or")
                        .foregroundStyle(Color.primary)
                        .bold()

                    TextEditor(text: self.$store.text)
                        .disabled(self.store.attachment != nil)
                        .frame(minHeight: 300)
                        .scrollContentBackground(.hidden)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                .opacity(self.store.attachment != nil ? 0.5 : 1)
                        )
                        .overlay(
                            Group {
                                if self.store.text.isEmpty {
                                    Text("Enter text to check")
                                        .opacity(self.store.attachment != nil ? 0.4 : 1)
                                        .foregroundStyle(.secondary)
                                        .padding(.leading, 5)
                                        .padding(.top, 8)
                                }
                            },
                            alignment: .topLeading
                        )
                }
            }
        }
        .contentMargins(.all, 20, for: .scrollContent)
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
        .padding(.bottom, 100)
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
                .disabled(!self.store.isFormValid)
                .buttonStyle(.primary(size: .fullWidth))
                .padding()
                .background(
                    Rectangle()
                        .fill(Color(UIColor.systemBackground))
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
