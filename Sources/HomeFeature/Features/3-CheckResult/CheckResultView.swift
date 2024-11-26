import APIClient
import ComposableArchitecture
import Foundation
import SharedModels
import Styleguide
import SwiftHelpers
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: CheckResult.self)
public struct CheckResultView: View {
    @Bindable public var store: StoreOf<CheckResult>
    @State private var showingIssueSheet = false
    @State private var showingMatchSheet = false

    public init(store: StoreOf<CheckResult>) {
        self.store = store
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("AI generation probability is " + String(format: "%.2f", self.store.check.aiScore) + "%")
                .font(.system(size: 22, weight: .regular))
                .foregroundStyle(.primary)
                .underline()

            self.highlightedTextSection

            Spacer()

            Button {
                send(.plagiarismCheckTapped)
            } label: {
                HStack {
                    if self.store.isChecking {
                        ProgressView()
                    }
                    Text("Plagiarism check")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .semibold))
                }
            }
            .disabled(self.store.isChecking)
            .buttonStyle(.primary(size: .fullWidth))
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: self.$showingIssueSheet) {
            if let selectedIssue = store.selectedIssue {
                IssueDetailSheet(issue: selectedIssue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(25)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
        .sheet(isPresented: Binding(
            get: { self.store.showingMatchSheet },
            set: { newValue in
                if !newValue {
                    send(.dismissMatchSheet)
                }
            }
        )) {
            if let matches = store.matches {
                PlagiarismMatchesView(matches: matches)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .contentMargins(.all, 25, for: .scrollContent)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var highlightedTextSection: some View {
        InteractiveTextView(check: self.store.check) { issue in
            self.showingIssueSheet = true
            send(.issueSelected(issue))
        }
        .frame(maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary, lineWidth: 1)
        )
    }
}

#Preview {
    CheckResultView(
        store: Store(initialState: CheckResult.State(check: .mockChatO1)) {
            CheckResult()
        }
    )
}
