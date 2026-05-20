import Foundation
import UIKit

struct PDFExportService {
    private let storage: DocumentStorageService

    init(storage: DocumentStorageService = DocumentStorageService()) {
        self.storage = storage
    }

    func exportPurchaseSummary(_ purchase: PurchaseItem, attachments: [AttachmentRecord]? = nil) throws -> URL {
        try storage.prepareDirectories()

        let safeName = purchase.name
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ":", with: "-")
        let url = try storage.exportsURL.appending(path: "\(safeName)-\(purchase.id.uuidString.prefix(8)).pdf")
        let purchaseAttachments = attachments ?? purchase.attachments

        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842)
        let margin: CGFloat = 48
        let contentWidth = pageRect.width - (margin * 2)
        let labelWidth: CGFloat = 150
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        try renderer.writePDF(to: url) { context in
            var y: CGFloat = margin

            func beginPage() {
                context.beginPage()
                UIColor.white.setFill()
                context.cgContext.fill(pageRect)
                y = margin
            }

            func ensureSpace(_ height: CGFloat) {
                if y + height > pageRect.height - margin {
                    beginPage()
                }
            }

            func drawSectionTitle(_ title: String) {
                ensureSpace(34)
                draw(title, in: CGRect(x: margin, y: y, width: contentWidth, height: 24), font: .boldSystemFont(ofSize: 14))
                y += 28
            }

            func drawRow(_ label: String, _ value: String) {
                let valueHeight = textHeight(value, width: contentWidth - labelWidth, font: .systemFont(ofSize: 12))
                let rowHeight = max(22, valueHeight)
                ensureSpace(rowHeight + 8)
                draw(label, in: CGRect(x: margin, y: y, width: labelWidth - 12, height: rowHeight), font: .boldSystemFont(ofSize: 12))
                draw(value.isEmpty ? "-" : value, in: CGRect(x: margin + labelWidth, y: y, width: contentWidth - labelWidth, height: rowHeight), font: .systemFont(ofSize: 12))
                y += rowHeight + 8
            }

            beginPage()

            draw(
                String(localized: "export.purchaseSummary", comment: "PDF title"),
                in: CGRect(x: margin, y: y, width: contentWidth, height: 34),
                font: .boldSystemFont(ofSize: 24)
            )
            y += 44

            let rows: [(String, String)] = [
                (String(localized: "field.productName", comment: "Product name field"), purchase.name),
                (String(localized: "field.store", comment: "Store field"), purchase.storeName ?? "-"),
                (String(localized: "field.purchaseDate", comment: "Purchase date field"), DateFormatService.mediumDate(purchase.purchaseDate)),
                (String(localized: "field.price", comment: "Price field"), purchase.price.map { CurrencyService.formattedAmount($0, currencyCode: purchase.currencyCode) } ?? "-"),
                (String(localized: "field.serialNumber", comment: "Serial number field"), purchase.serialNumber ?? "-")
            ]

            for row in rows {
                drawRow(row.0, row.1)
            }

            y += 12
            drawSectionTitle(String(localized: "detail.section.timeline", comment: "Timeline section"))

            if let warranty = purchase.primaryWarranty {
                drawRow(String(localized: "field.warrantyEnds", comment: "Warranty end field"), DateFormatService.mediumDate(warranty.endDate))
            }

            if let returnWindow = purchase.primaryReturnWindow {
                drawRow(String(localized: "field.returnEnds", comment: "Return end field"), DateFormatService.mediumDate(returnWindow.endDate))
            }

            if purchase.primaryWarranty == nil && purchase.primaryReturnWindow == nil {
                drawRow(String(localized: "status.noDate", comment: "No date status"), "-")
            }

            if !purchaseAttachments.isEmpty {
                y += 12
                drawSectionTitle(String(localized: "detail.section.attachments", comment: "Attachments section"))

                for attachment in purchaseAttachments.sorted(by: { $0.createdAt < $1.createdAt }) {
                    let fileSize = attachment.fileSize.map { ByteCountFormatter.string(fromByteCount: $0, countStyle: .file) }
                    let value = [
                        attachment.originalFileName ?? attachment.localFileName,
                        String(localized: String.LocalizationValue(attachment.type.localizationKey)),
                        fileSize
                    ]
                    .compactMap { $0 }
                    .joined(separator: " - ")
                    drawRow(String(localized: "detail.section.attachments", comment: "Attachments section"), value)
                }
            }

            if let notes = purchase.notes, !notes.isEmpty {
                y += 16
                drawSectionTitle(String(localized: "field.notes", comment: "Notes field"))
                let notesHeight = textHeight(notes, width: contentWidth, font: .systemFont(ofSize: 12))
                ensureSpace(notesHeight)
                draw(notes, in: CGRect(x: margin, y: y, width: contentWidth, height: notesHeight), font: .systemFont(ofSize: 12))
            }
        }

        return url
    }

    private func draw(_ text: String, in rect: CGRect, font: UIFont) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        text.draw(in: rect, withAttributes: attributes)
    }

    private func textHeight(_ text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraph
        ]
        let rect = text.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        )
        return ceil(rect.height) + 2
    }
}
