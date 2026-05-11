import AppKit

let size = NSSize(width: 1200, height: 630)
guard let bitmap = NSBitmapImageRep(
  bitmapDataPlanes: nil,
  pixelsWide: Int(size.width),
  pixelsHigh: Int(size.height),
  bitsPerSample: 8,
  samplesPerPixel: 4,
  hasAlpha: true,
  isPlanar: false,
  colorSpaceName: .deviceRGB,
  bytesPerRow: 0,
  bitsPerPixel: 0
) else {
  fatalError("Could not create bitmap")
}

bitmap.size = size

func color(_ hex: UInt32, alpha: CGFloat = 1) -> NSColor {
  let red = CGFloat((hex >> 16) & 0xff) / 255
  let green = CGFloat((hex >> 8) & 0xff) / 255
  let blue = CGFloat(hex & 0xff) / 255
  return NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
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

NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)

color(0xf7f5f1).setFill()
NSRect(origin: .zero, size: size).fill()

color(0xffffff, alpha: 0.28).setFill()
NSBezierPath(ovalIn: NSRect(x: 920, y: 374, width: 320, height: 320)).fill()
color(0xffffff, alpha: 0.22).setFill()
NSBezierPath(ovalIn: NSRect(x: 782, y: -140, width: 440, height: 440)).fill()

color(0x141516, alpha: 0.08).setStroke()
let mark = NSBezierPath(ovalIn: NSRect(x: 56, y: 514, width: 56, height: 56))
mark.lineWidth = 1
mark.stroke()
color(0x3f5d4c).setFill()
NSBezierPath(ovalIn: NSRect(x: 74, y: 532, width: 20, height: 20)).fill()

color(0x141516, alpha: 0.08).setFill()
NSRect(x: 76, y: 469, width: 1050, height: 1).fill()
NSRect(x: 76, y: 111, width: 1050, height: 1).fill()

let sansBold = NSFont.systemFont(ofSize: 22, weight: .bold)
let sansMedium = NSFont.systemFont(ofSize: 28, weight: .medium)
let serifTitle = NSFont(name: "Georgia", size: 34) ?? NSFont.systemFont(ofSize: 34, weight: .regular)
let serifHero = NSFont(name: "Georgia", size: 76) ?? NSFont.systemFont(ofSize: 76, weight: .regular)

drawText("Prosocial Design Inc.", x: 132, top: 66, width: 600, height: 50, font: serifTitle, textColor: color(0x141516))
drawText("A DESIGN LAB FOR HEALTHIER SOCIAL SPACES", x: 76, top: 226, width: 900, height: 34, font: sansBold, textColor: color(0x5b6b7a), kern: 3)
drawText("Technology can bring", x: 76, top: 290, width: 980, height: 90, font: serifHero, textColor: color(0x141516))
drawText("out the best in us.", x: 76, top: 380, width: 980, height: 90, font: serifHero, textColor: color(0x141516))
drawText("Vancouver, Canada · Independent, research-first · Est. 2026", x: 78, top: 540, width: 1000, height: 40, font: sansMedium, textColor: color(0x5b6b7a))

NSGraphicsContext.restoreGraphicsState()

guard let png = bitmap.representation(using: .png, properties: [:]) else {
  fatalError("Could not render Open Graph image")
}

try png.write(to: URL(fileURLWithPath: "assets/og-image.png"))
