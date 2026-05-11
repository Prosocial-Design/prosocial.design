import AppKit

let size = NSSize(width: 1200, height: 630)
let image = NSImage(size: size)

func color(_ hex: UInt32, alpha: CGFloat = 1) -> NSColor {
  let red = CGFloat((hex >> 16) & 0xff) / 255
  let green = CGFloat((hex >> 8) & 0xff) / 255
  let blue = CGFloat(hex & 0xff) / 255
  return NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
}

func strokeCircle(center: NSPoint, radius: CGFloat, stroke: NSColor, width: CGFloat) {
  let rect = NSRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
  let path = NSBezierPath(ovalIn: rect)
  path.lineWidth = width
  stroke.setStroke()
  path.stroke()
}

func drawText(_ text: String, x: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat, font: NSFont, textColor: NSColor, kern: CGFloat = 0) {
  let paragraph = NSMutableParagraphStyle()
  paragraph.lineBreakMode = .byWordWrapping
  let attributes: [NSAttributedString.Key: Any] = [
    .font: font,
    .foregroundColor: textColor,
    .paragraphStyle: paragraph,
    .kern: kern
  ]
  let y = size.height - top - height
  (text as NSString).draw(in: NSRect(x: x, y: y, width: width, height: height), withAttributes: attributes)
}

image.lockFocus()

color(0xfaf8f5).setFill()
NSRect(origin: .zero, size: size).fill()

strokeCircle(center: NSPoint(x: -60, y: 270), radius: 370, stroke: color(0x2ecc71, alpha: 0.22), width: 54)
strokeCircle(center: NSPoint(x: -60, y: 270), radius: 455, stroke: color(0xe84393, alpha: 0.22), width: 54)
strokeCircle(center: NSPoint(x: -60, y: 270), radius: 540, stroke: color(0x9b59b6, alpha: 0.22), width: 54)
strokeCircle(center: NSPoint(x: 1230, y: 60), radius: 300, stroke: color(0x9b59b6, alpha: 0.16), width: 48)
strokeCircle(center: NSPoint(x: 1230, y: 60), radius: 380, stroke: color(0xe84393, alpha: 0.16), width: 48)
strokeCircle(center: NSPoint(x: 1230, y: 60), radius: 460, stroke: color(0x2ecc71, alpha: 0.16), width: 48)

let sansBold = NSFont.systemFont(ofSize: 31, weight: .bold)
let sansMedium = NSFont.systemFont(ofSize: 34, weight: .medium)
let serif = NSFont(name: "Georgia-Bold", size: 82) ?? NSFont.systemFont(ofSize: 82, weight: .heavy)

drawText("PROSOCIAL DESIGN CO.", x: 88, top: 78, width: 900, height: 46, font: sansBold, textColor: color(0x1a1a1a), kern: 3)
drawText("Group chats", x: 88, top: 178, width: 940, height: 92, font: serif, textColor: color(0x1a1a1a))
drawText("weren't built for", x: 88, top: 270, width: 940, height: 92, font: serif, textColor: color(0x1a1a1a))
drawText("real friendship.", x: 88, top: 362, width: 940, height: 92, font: serif, textColor: color(0x9b59b6))
drawText("VanChat: 3-9 friends. No feed. No followers. Canada-first.", x: 92, top: 500, width: 940, height: 54, font: sansMedium, textColor: color(0x3f3f3f))

image.unlockFocus()

guard
  let tiff = image.tiffRepresentation,
  let bitmap = NSBitmapImageRep(data: tiff),
  let png = bitmap.representation(using: .png, properties: [:])
else {
  fatalError("Could not render Open Graph image")
}

try png.write(to: URL(fileURLWithPath: "assets/og-image.png"))
