// swift-tools-version:6.0

import Foundation
import PackageDescription

let package = Package(
    name: "unifine-ios",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "AccountFeature", targets: ["AccountFeature"]),
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "APIClientLive", targets: ["APIClientLive"]),
        .library(name: "AppearanceClient", targets: ["AppearanceClient"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "AuthFeature", targets: ["AuthFeature"]),
        .library(name: "HomeFeature", targets: ["HomeFeature"]),
        .library(name: "KeychainClient", targets: ["KeychainClient"]),
        .library(name: "SessionClient", targets: ["SessionClient"]),
        .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "SplashFeature", targets: ["SplashFeature"]),
        .library(name: "Styleguide", targets: ["Styleguide"]),
        .library(name: "SwiftHelpers", targets: ["SwiftHelpers"]),
        .library(name: "SwiftUIHelpers", targets: ["SwiftUIHelpers"]),
        .library(name: "TabsFeature", targets: ["TabsFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.4.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.6.0"),
        .package(url: "https://github.com/apple/swift-openapi-urlsession", from: "1.0.2"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.16.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.5.2"),
        .package(url: "https://github.com/tgrapperon/swift-dependencies-additions", from: "1.1.1"),
        .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.10.0"),
    ],
    targets: [
        .target(
            name: "AccountFeature",
            dependencies: [
                "APIClient",
                "SessionClient",
                "SettingsFeature",
                "SharedModels",
                "Styleguide",
                "SwiftUIHelpers",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "APIClient",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "APIClientLive",
            dependencies: [
                "APIClient",
                "SessionClient",
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession"),
                .product(name: "Tagged", package: "swift-tagged"),
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
            ]
        ),
        .target(
            name: "AppearanceClient",
            dependencies: [
                "SharedModels",
                "SwiftHelpers",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "DependenciesAdditions", package: "swift-dependencies-additions"),
            ]
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "AuthFeature",
                "SplashFeature",
                "TabsFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AuthFeature",
            dependencies: [
                "APIClient",
                "KeychainClient",
                "SessionClient",
                "SharedModels",
                "Styleguide",
                "SwiftHelpers",
                "SwiftUIHelpers",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "HomeFeature",
            dependencies: [
                "APIClient",
                "SharedModels",
                "Styleguide",
                "SwiftHelpers",
                "SwiftUIHelpers",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "KeychainClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "SessionClient",
            dependencies: [
                "KeychainClient",
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "SettingsFeature",
            dependencies: [
                "APIClient",
                "AppearanceClient",
                "SessionClient",
                "SharedModels",
                "Styleguide",
                "SwiftUIHelpers",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "SharedModels",
            dependencies: []
        ),
        .target(
            name: "SplashFeature",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "Styleguide",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "SwiftHelpers",
            dependencies: []
        ),
        .target(
            name: "SwiftUIHelpers",
            dependencies: [
                "Styleguide",
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "TabsFeature",
            dependencies: [
                "AccountFeature",
                "HomeFeature",
                "Styleguide",
                "SwiftHelpers",
                "SwiftUIHelpers",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
