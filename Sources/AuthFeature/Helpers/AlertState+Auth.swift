//
//  AlertState+Auth.swift
//  unifine-ios
//
//  Created by Yehor Myropoltsev on 23.11.2024.
//
import ComposableArchitecture
import Foundation

extension AlertState where Action == Never {
    static func failedToAuth(error: any Error) -> Self {
        Self {
            TextState("Failed to authenticate")
        } actions: {
            ButtonState(role: .cancel) {
                TextState("OK")
            }
        } message: {
            TextState(error.localizedDescription)
        }
    }
}
