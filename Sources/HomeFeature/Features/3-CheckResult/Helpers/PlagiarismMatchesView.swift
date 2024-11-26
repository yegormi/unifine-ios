import Foundation
import SharedModels
import Styleguide
import SwiftUI

public struct MatchLevelBadge: View {
    public let level: PlagiarismLevel

    public init(level: PlagiarismLevel) {
        self.level = level
    }

    public var body: some View {
        Text(self.level.rawValue)
            .frame(width: 70, alignment: .center)
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(self.level.color)
            )
            .font(.system(size: 14, weight: .regular))
    }
}

public struct PlagiarismMatchesView: View {
    public let matches: [Match]

    public init(matches: [Match]) {
        self.matches = matches
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Plagiarism probability")
                    .foregroundStyle(Color.primary)
                    .font(.system(size: 33, weight: .semibold))

                ForEach(self.matches) { match in
                    VStack(alignment: .leading, spacing: 6) {
                        MatchLevelBadge(level: match.level)

                        Link(destination: match.url) {
                            Text(match.url.absoluteString)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color.linkPrimary)
                                .lineLimit(1)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview

struct PlagiarismMatchesView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMatches = [
            Match(id: "1", url: URL(string: "https://www.wikipedia.org/1")!, score: 85),
            Match(id: "2", url: URL(string: "https://www.wikipedia.org/2")!, score: 45),
            Match(id: "3", url: URL(string: "https://www.wikipedia.org/3")!, score: 15),
        ]

        PlagiarismMatchesView(matches: sampleMatches)
    }
}
