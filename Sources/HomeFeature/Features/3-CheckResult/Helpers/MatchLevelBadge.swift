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
