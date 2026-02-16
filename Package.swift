// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "Habla",
  defaultLocalization: "en",
  products: [
    .library(name: "HablaC", targets: ["HablaC"]),
    .library(name: "Habla", targets: ["Habla"]),
    .executable(name: "HablaExample", targets: ["HablaExample"]),
  ],
  targets: [
    .target(
      name: "HablaC",
      path: "Sources/HablaC",
      publicHeadersPath: "include",
      cSettings: [
        .headerSearchPath("include"),
      ]
    ),
    .target(
      name: "Habla",
      dependencies: ["HablaC"],
      path: "Sources/Habla",
      resources: [
        .process("Resources"),
      ]
    ),
    .executableTarget(
      name: "HablaExample",
      dependencies: ["Habla"],
      path: "Sources/HablaExample"
    ),
  ],
  cLanguageStandard: .c11
)
