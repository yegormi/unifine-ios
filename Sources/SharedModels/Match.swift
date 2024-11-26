import Foundation
import SwiftUI

public enum PlagiarismLevel: String {
    case high = "High"
    case medium = "Medium"
    case low = "Low"

    public var color: Color {
        switch self {
        case .high:
            Color(red: 240 / 255, green: 128 / 255, blue: 128 / 255) // Coral pink
        case .medium:
            Color(red: 255 / 255, green: 179 / 255, blue: 102 / 255) // Peach
        case .low:
            Color(red: 169 / 255, green: 196 / 255, blue: 169 / 255) // Sage green
        }
    }
}

// MARK: - Models

public struct Match: Sendable, Equatable, Identifiable {
    public let id: String
    public let url: URL
    public let score: Double

    public init(id: String, url: URL, score: Double) {
        self.id = id
        self.url = url
        self.score = score
    }

    public var level: PlagiarismLevel {
        switch self.score {
        case 70...:
            .high
        case 25 ..< 70:
            .medium
        default:
            .low
        }
    }
}
