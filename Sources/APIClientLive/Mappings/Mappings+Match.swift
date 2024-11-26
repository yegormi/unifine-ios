import APIClient
import Foundation
import SharedModels

extension Components.Schemas.MatchDto {
    func toDomain() -> SharedModels.Match {
        Match(
            id: self.id,
            url: URL(string: self.url)!,
            score: self.score
        )
    }
}
