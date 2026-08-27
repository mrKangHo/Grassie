import AppKit
import SwiftUI

class DynamicGrassIconGenerator {
    static func createIcon(days: [ContributionDay], isDark: Bool = true) -> NSImage {
        let size = NSSize(width: 17, height: 17)
        let image = NSImage(size: size)

        image.lockFocus()

        let last9Days: [ContributionDay]
        if days.count >= 9 {
            last9Days = Array(days.suffix(9))
        } else {
            // Placeholder 9 days if no data yet
            last9Days = (0..<9).map { _ in ContributionDay(date: Date(), count: 0, level: 0) }
        }

        let cellSize: CGFloat = 4.2
        let spacing: CGFloat = 1.3
        let cornerRadius: CGFloat = 1.0

        for index in 0..<9 {
            let row = 2 - (index / 3) // Top-to-bottom drawing
            let col = index % 3

            let x = CGFloat(col) * (cellSize + spacing) + 0.5
            let y = CGFloat(row) * (cellSize + spacing) + 0.5

            let rect = NSRect(x: x, y: y, width: cellSize, height: cellSize)
            let path = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)

            let dayLevel = index < last9Days.count ? last9Days[index].level : 0
            let color = colorForLevel(dayLevel, isDark: isDark)

            color.setFill()
            path.fill()

            // Subtle border for empty or low level cells
            let borderColor = dayLevel == 0 ? NSColor(white: 0.5, alpha: 0.3) : NSColor(white: 1.0, alpha: 0.25)
            borderColor.setStroke()
            path.lineWidth = 0.5
            path.stroke()
        }

        image.unlockFocus()
        image.isTemplate = false // Allows vibrant real green colors in macOS status bar!

        return image
    }

    private static func colorForLevel(_ level: Int, isDark: Bool) -> NSColor {
        switch level {
        case 1:
            return NSColor(srgbRed: 14/255.0, green: 68/255.0, blue: 41/255.0, alpha: 1.0)
        case 2:
            return NSColor(srgbRed: 0/255.0, green: 110/255.0, blue: 26/255.0, alpha: 1.0)
        case 3:
            return NSColor(srgbRed: 40/255.0, green: 200/255.0, blue: 64/255.0, alpha: 1.0)
        case 4:
            return NSColor(srgbRed: 113/255.0, green: 255/255.0, blue: 116/255.0, alpha: 1.0)
        default:
            return isDark ? NSColor(white: 0.3, alpha: 0.6) : NSColor(white: 0.75, alpha: 0.8)
        }
    }
}
