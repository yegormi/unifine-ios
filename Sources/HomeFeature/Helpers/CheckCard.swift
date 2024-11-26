import SharedModels
import Styleguide
import SwiftUI

public struct CheckCard: View {
    let check: CheckPreview

    public init(check: CheckPreview) {
        self.check = check
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(self.check.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .foregroundStyle(.black)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .underline()

                Spacer()

                Text(self.check.createdAt, format: self.dateStyle)
                    .font(.subheadline)
                    .foregroundStyle(.black)
            }

            Text(self.check.summary)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .truncationMode(.tail)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 1)
                .background(Color.orangeBackground)
        )
    }

    var dateStyle: Date.FormatStyle {
        .dateTime.day(.twoDigits).month(.twoDigits).year(.extended())
    }
}

#Preview {
    VStack(spacing: 12) {
        CheckCard(check: .mock1)
        CheckCard(check: .mock2)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
    .background(Color(.systemGray6))
}
