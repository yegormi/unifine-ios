import Foundation
import SharedModels
import Styleguide
import SwiftUI

public extension Check.Issue.IssueType {
    var background: Color {
        switch self {
        case .grammar: Color.red500.opacity(0.2)
        case .vocabulary: Color.blue500.opacity(0.2)
        case .style: Color.orange500.opacity(0.2)
        case .tone: Color.purple500.opacity(0.2)
        }
    }

    var foreground: Color {
        switch self {
        case .grammar: Color.red500
        case .vocabulary: Color.blue500
        case .style: Color.orange500
        case .tone: Color.purple500
        }
    }

    var color: Color {
        switch self {
        case .grammar: Color.redMarker
        case .vocabulary: Color.blueMarker
        case .style: Color.orangeMarker
        case .tone: Color.purpleMarker
        }
    }
}
