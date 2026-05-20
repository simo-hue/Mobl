import Foundation
import UIKit

struct PDFExportService {
    private let storage: DocumentStorageService

    init(storage: DocumentStorageService = DocumentStorageService()) {
        self.storage = storage
    }

    func exportPurchaseSummary(_ purchase: PurchaseItem) throws -> URL {
        try storage.prepareDirectories()

        let safeName = purchase.name
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ":", with: "-")
        let url = try storage.exportsURL.appending(path: "\(safeName)-\(purchase.id.uuidString.prefix(8)).pdf")

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842))
        try renderer.writePDF(to: url) { context in
            context.beginPage()

            let margin: CGFloat = 48
            var y: CGFloat = margin

            draw(
                String(localized: "export.purchaseSummary", comment: "PDF title"),
                at: CGPoint(x: margin, y: y),
                font: .boldSystemFont(ofSize: 24)
            )
            y += 44

            let rows: [(String, String)] = [
                (String(localized: "field.productName", comment: "Product name field"), purchase.name),
                (String(localized: "field.store", comment: "Store field"), purchase.storeName ?? "-"),
                (String(localized: "field.purchaseDate", comment: "Purchase date field"), DateFormatService.mediumDate(purchase.purchaseDate)),
                (String(localized: "field.price", comment: "Price field"), CurrencyService.formattedAmount(purchase.price, currencyCode: purchase.currencyCode)),
                (String(localized: "field.serialNumber", comment: "Serial number field"), purchase.serialNumber ?? "-")
            ]

            for row in rows {
                draw(row.0, at: CGPoint(x: margin, y: y), font: .boldSystemFont(ofSize: 12))
                draw(row.1, at: CGPoint(x: margin + 160, y: y), font: .systemFont(ofSize: 12))
                y += 24
            }

            y += 12
            if let warranty = purchase.primaryWarranty {
                draw(
                    String(localized: "field.warrantyEnds", comment: "Warranty end field"),
                    at: CGPoint(x: margin, y: y),
                    font: .boldSystemFont(ofSize: 12)
                )
                draw(DateFormatService.mediumDate(warranty.endDate), at: CGPoint(x: margin + 160, y: y), font: .systemFont(ofSize: 12))
                y += 24
            }

            if let returnWindow = purchase.primaryReturnWindow {
                draw(
                    String(localized: "field.returnEnds", comment: "Return end field"),
                    at: CGPoint(x: margin, y: y),
                    font: .boldSystemFont(ofSize: 12)
                )
                draw(DateFormatService.mediumDate(returnWindow.endDate), at: CGPoint(x: margin + 160, y: y), font: .systemFont(ofSize: 12))
                y += 24
            }

            if let notes = purchase.notes, !notes.isEmpty {
                y += 16
                draw(String(localized: "field.notes", comment: "Notes field"), at: CGPoint(x: margin, y: y), font: .boldSystemFont(ofSize: 12))
                y += 20
                drawWrapped(notes, in: CGRect(x: margin, y: y, width: 500, height: 160), font: .systemFont(ofSize: 12))
            }
        }

        return url
    }

    private func draw(_ text: String, at point: CGPoint, font: UIFont) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.label
        ]
        text.draw(at: point, withAttributes: attributes)
    }

    private func drawWrapped(_ text: String, in rect: CGRect, font: UIFont) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.label,
            .paragraphStyle: paragraph
        ]
        text.draw(in: rect, withAttributes: attributes)
    }
}

