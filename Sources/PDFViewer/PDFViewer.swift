import SwiftUI
import PDFKit

public enum PDFBuildType {
    case document(PDFDocument)
    case images([UIImage])
}

public struct viewerOptions {
    let autoScales: Bool = false
    let scaleFactor: CGFloat = 1
    let minScaleFactor: CGFloat = 1
    let maxScaleFactor: CGFloat = 4
    let thumbnailSize = CGSize(width: 50, height: 50)
}

@available(iOS 14, macOS 11.0, *)
public class PDFController: UIViewController {
    let document: PDFDocument
    let options: viewerOptions
    
    
    
    init(_ document: PDFDocument, options: viewerOptions) {
        self.document = document
        self.options = options
        super.init(nibName: nil, bundle: nil)
    }
    //Create document from UIImages
    convenience init(_ images: [UIImage], options: viewerOptions) {
        let newDocument = PDFDocument()
        for image in images {
            if let newPage = PDFPage(image: image) {
                newDocument.insert(newPage, at: newDocument.pageCount)
            }
        }
        self.init(newDocument, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(iOS 14, macOS 11.0, *)
extension PDFController {
    private func createPDFView() -> PDFView {
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.document = self.document
        pdfView.autoScales = self.options.autoScales
        pdfView.scaleFactor = self.options.scaleFactor
        pdfView.minScaleFactor = self.options.minScaleFactor
        pdfView.maxScaleFactor = self.options.maxScaleFactor
        return pdfView
    }
    private func createPDFThumbnailView(pdfView: PDFView) -> PDFThumbnailView {
        let thumbnailView = PDFThumbnailView()
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailView.thumbnailSize = self.options.thumbnailSize
        thumbnailView.layoutMode = .horizontal
        thumbnailView.pdfView = pdfView
        return thumbnailView
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        let pdfView = createPDFView()
        let thumbnailView = createPDFThumbnailView(pdfView: pdfView)
        view.addSubview(pdfView)
        view.addSubview(thumbnailView)
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            pdfView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            thumbnailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            thumbnailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            thumbnailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            thumbnailView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}


/// A UIViewController wrapper for PDFController
@available(iOS 14, macOS 11.0, *)
public struct PDFViewer: UIViewControllerRepresentable {
    let build: PDFBuildType
    var options: viewerOptions = viewerOptions()
    
    ///Use default options
    public init(build: PDFBuildType) {
        self.build = build
    }
    
    ///Provide custom options
    public init(_ build: PDFBuildType, options: viewerOptions) {
        self.build = build
        self.options = options
    }
    
    public func makeUIViewController(context: Context) -> PDFController {
        switch build {
        case .document(let document):
            return PDFController(document, options: options)
        case .images(let images):
            return PDFController(images, options: options)
        }
    }
        
    public func updateUIViewController(_ uiViewController: PDFController, context: Context) {
    }
}
