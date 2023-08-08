// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PDFViewer",
    products: [
        .library(
            name: "PDFViewer",
            targets: ["PDFViewer"]
        ),
    ],
    targets: [
        .target(
            name: "PDFViewer"),
        .testTarget(
            name: "PDFViewerTests",
            dependencies: ["PDFViewer"]),
    ]
)
