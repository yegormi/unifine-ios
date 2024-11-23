import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    public enum Size {
        case small
        case fullWidth

        var verticalPadding: CGFloat {
            18
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small: 32
            case .fullWidth: 0
            }
        }
    }

    @Environment(\.isEnabled) var isEnabled
    let size: Size

    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(maxWidth: self.size == .fullWidth ? .infinity : nil)
            .font(.titleLarge)
            .foregroundStyle(Color.white)
            .padding(.vertical, self.size.verticalPadding)
            .padding(.horizontal, self.size.horizontalPadding)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(self.isEnabled ? Color.orangePrimary : Color.gray)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring, value: configuration.isPressed)
            .brightness(configuration.isPressed ? -0.1 : 0)
    }
}

public extension ButtonStyle where Self == PrimaryButtonStyle {
    static func primary(size: PrimaryButtonStyle.Size) -> PrimaryButtonStyle {
        .init(size: size)
    }

    /// Default primary button style (dynamic)
    static var primary: PrimaryButtonStyle { .primary(size: .small) }
}
