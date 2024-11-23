import APIClient
import Foundation
import SharedModels

extension Components.Schemas.UserDto {
    func toDomain() -> SharedModels.User {
        User(
            id: self.id,
            email: self.email
        )
    }
}

extension AuthRequest {
    func toAPI() -> Components.Schemas.AuthRequestDto {
        .init(email: self.email, password: self.password)
    }
}

extension Components.Schemas.LoginResponseDto {
    func toDomain() -> AuthResponse {
        .init(accessToken: self.accessToken, user: self.user.toDomain())
    }
}

extension Components.Schemas.SignupResponseDto {
    func toDomain() -> AuthResponse {
        .init(accessToken: self.accessToken, user: self.user.toDomain())
    }
}
