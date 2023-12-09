// swift-tools-version: 5.8

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "VissionAssist",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "VissionAssist",
            targets: ["AppModule"],
            bundleIdentifier: "sajal.VissionAssist",
            teamIdentifier: "95CJQ834W6",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.brown),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .fileAccess(.pictureFolder, mode: .readWrite),
                .fileAccess(.musicFolder, mode: .readWrite),
                .fileAccess(.userSelectedFiles, mode: .readWrite),
                .fileAccess(.downloadsFolder, mode: .readWrite),
                .fileAccess(.moviesFolder, mode: .readWrite),
                .camera(purposeString: "Unknown Usage Description")
            ],
            appCategory: .developerTools
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)