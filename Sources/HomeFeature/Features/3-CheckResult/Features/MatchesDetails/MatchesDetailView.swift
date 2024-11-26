import ComposableArchitecture
import SharedModels
import SwiftUI

@ViewAction(for: MatchesDetail.self)
public struct MatchesDetailView: View {
    @Bindable public var store: StoreOf<MatchesDetail>

    public init(store: StoreOf<MatchesDetail>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Plagiarism probability")
                    .foregroundStyle(Color.primary)
                    .font(.system(size: 33, weight: .semibold))

                ForEach(self.store.matches) { match in
                    VStack(alignment: .leading, spacing: 6) {
                        MatchLevelBadge(level: match.level)

                        Link(destination: match.url) {
                            Text(match.url.absoluteString)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(Color.linkPrimary)
                        }
                    }
                }
            }
        }
    }
}
