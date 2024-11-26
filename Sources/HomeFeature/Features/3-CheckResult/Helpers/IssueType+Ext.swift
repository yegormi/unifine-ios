import Foundation
import SharedModels
import Styleguide
import SwiftUI

public extension Check.Issue.IssueType {
    var color: Color {
        switch self {
        case .grammar: Color.redMarker
        case .vocabulary: Color.blueMarker
        case .style: Color.orangeMarker
        case .tone: Color.purpleMarker
        }
    }

    var foreground: Color {
        switch self {
        case .grammar: Color.redMarker
        case .vocabulary: Color.blueMarker
        case .style: Color.orangeMarker
        case .tone: Color.purpleMarker
        }
    }
}
