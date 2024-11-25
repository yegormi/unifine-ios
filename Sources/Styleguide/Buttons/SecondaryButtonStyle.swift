import SwiftUI

public struct SecondaryButtonStyle: ButtonStyle {
    public enum Size {
        case small
        case fullWidth

        var verticalPadding: CGFloat {
            14
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small: 32
            case .fullWidth: 0
            }
        }
    }

    @Environment(\.isEnabled) var isEnabled
    @Environment(\.colorScheme) var colorScheme
    let size: Size

    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(maxWidth: self.size == .fullWidth ? .infinity : nil)
            .font(.titleRegular)
            .foregroundStyle(Color.primary)
            .padding(.vertical, self.size.verticalPadding)
            .padding(.horizontal, self.size.horizontalPadding)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.primary, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.systemBackground))
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring, value: configuration.isPressed)
            .brightness(configuration.isPressed ? -0.1 : 0)
    }
}

public extension ButtonStyle where Self == SecondaryButtonStyle {
    static func secondary(size: SecondaryButtonStyle.Size) -> SecondaryButtonStyle {
        .init(size: size)
    }

    /// Default secondary button style (dynamic)
    static var secondary: SecondaryButtonStyle { .secondary(size: .small) }
}
