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

    public init(store: StoreOf<CheckResult>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
//                self.titleSection
                self.highlightedTextSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .sheet(isPresented: self.$showingIssueSheet) {
            if let selectedIssue = store.selectedIssue {
                IssueDetailSheet(issue: selectedIssue)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.store.check.title)
                .font(.title2)
                .fontWeight(.bold)

            Text(self.store.check.summary)
                .foregroundStyle(.secondary)
        }
    }

    private var highlightedTextSection: some View {
        InteractiveTextView(check: self.store.check) { issue in
            self.showingIssueSheet = true
            send(.issueSelected(issue))
        }
        .frame(maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
    }
}

#Preview {
    CheckResultView(
        store: Store(initialState: CheckResult.State(check: .mockTechnical)) {
            CheckResult()
        }
    )
}
