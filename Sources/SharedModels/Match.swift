import Foundation
import SwiftUI

public struct Match: Sendable, Equatable, Identifiable {
    public let id: String
    public let url: URL
    public let score: Double

    public init(id: String, url: URL, score: Double) {
        self.id = id
        self.url = url
        self.score = score
    }

    // Score classification computed properties
    private var isHigh: Bool {
        self.score >= 0.7
    }

    private var isMedium: Bool {
        self.score >= 0.4 && self.score < 0.7
    }

    private var isLow: Bool {
        self.score < 0.4
    }

    // Color properties (using standard iOS colors)
    public var color: Color {
        if self.isHigh {
            Color(red: 240 / 255, green: 128 / 255, blue: 128 / 255) // Coral pink
        } else if self.isMedium {
            Color(red: 255 / 255, green: 179 / 255, blue: 102 / 255) // Peach
        } else {
            Color(red: 169 / 255, green: 196 / 255, blue: 169 / 255) // Sage green
        }
    }

    // Level classification
    public var level: String {
        if self.isHigh {
            "High"
        } else if self.isMedium {
            "Medium"
        } else {
            "Low"
        }
    }
}
