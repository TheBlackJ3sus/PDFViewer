import SwiftUI
import PDFKit

@available(iOS 14, macOS 11.0, *)
public class PDFController: UIViewController {
    public var document: PDFDocument
    
    public init(document: PDFDocument) {
        self.document = document
        super.init(nibName: nil, bundle: nil)
    }
    //Create document from UIImages
    public convenience init(images: [UIImage]) {
        let newDocument = PDFDocument()
        for image in images {
            if let newPage = PDFPage(image: image) {
                newDocument.insert(newPage, at: newDocument.pageCount)
            }
        }
        self.init(document: newDocument)
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
        return pdfView
    }
    private func createPDFThumbnailView(pdfView: PDFView) -> PDFThumbnailView {
        let thumbnailView = PDFThumbnailView()
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
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

@available(iOS 14, macOS 11.0, *)
public struct PDFViewer: UIViewControllerRepresentable {
    public var build: PDFBuildType
    
    public func makeUIViewController(context: Context) -> PDFController {
        switch build {
        case .document(let document):
            return PDFController(document: document)
        case .images(let images):
            return PDFController(images: images)
        }
    }
        
    public func updateUIViewController(_ uiViewController: PDFController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}

public enum PDFBuildType {
    case document(PDFDocument)
    case images([UIImage])
}
