import SharedModels
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
                    .foregroundStyle(.black)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .underline()

                Spacer()

                Text(self.check.createdAt, format: .dateTime.day().month().year())
                    .font(.subheadline)
                    .foregroundStyle(.black)
            }

            Text(self.check.summary)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 1)
                .background(Color.white)
        )
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
