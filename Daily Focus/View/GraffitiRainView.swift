import UIKit

class GraffitiRainView: UIView {
    
    private let emitterLayer = CAEmitterLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmitter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.height + 20)
        emitterLayer.emitterSize = CGSize(width: 80, height: 1)
    }
    
    private func setupEmitter() {
        let cells: [CAEmitterCell] = [
            createSplatterCell(),
            createDripCell(),
            createSprayDotCell(),
            createBrushStrokeCell()
        ]
        
        emitterLayer.emitterCells = cells
        emitterLayer.emitterShape = .line
        emitterLayer.renderMode = .additive  // blends colors nicely
        layer.addSublayer(emitterLayer)
    }
    
    private func createSplatterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 15
        cell.lifetime = 4
        cell.velocity = -140
        cell.velocityRange = 80
        cell.emissionLongitude = -.pi / 2
        cell.emissionRange = .pi * 0.55
        cell.yAcceleration = 60
        cell.scale = 0.2
        cell.scaleRange = 0.15
        cell.spin = 2
        cell.spinRange = 4
        cell.alphaSpeed = -0.2
        cell.contents = createSplatterImage()?.cgImage
        cell.color = randomGraffitiColor().cgColor
        return cell
    }
    
    private func createDripCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 8
        cell.lifetime = 5
        cell.velocity = -100
        cell.velocityRange = 50
        cell.emissionLongitude = -.pi / 2
        cell.emissionRange = .pi / 6
        cell.yAcceleration = 40
        cell.scale = 0.25
        cell.scaleRange = 0.1
        cell.alphaSpeed = -0.15
        cell.contents = createDripImage()?.cgImage
        cell.color = randomGraffitiColor().cgColor
        return cell
    }
    
    private func createSprayDotCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 25
        cell.lifetime = 3
        cell.velocity = -180
        cell.velocityRange = 100
        cell.emissionLongitude = -.pi / 2
        cell.emissionRange = .pi * 0.7
        cell.yAcceleration = 100
        cell.scale = 0.08
        cell.scaleRange = 0.06
        cell.alphaSpeed = -0.25
        cell.contents = createSprayDotImage()?.cgImage
        cell.color = randomGraffitiColor().cgColor
        return cell
    }
    
    private func createBrushStrokeCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 6
        cell.lifetime = 4.5
        cell.velocity = -110
        cell.velocityRange = 60
        cell.emissionLongitude = -.pi / 2
        cell.emissionRange = .pi * 0.5
        cell.yAcceleration = 50
        cell.scale = 0.18
        cell.scaleRange = 0.12
        cell.spin = -1
        cell.spinRange = 2
        cell.alphaSpeed = -0.18
        cell.contents = createBrushStrokeImage()?.cgImage
        cell.color = randomGraffitiColor().cgColor
        return cell
    }
    
    private func randomGraffitiColor() -> UIColor {
        let colors: [UIColor] = [
            UIColor(red: 0.0, green: 1.0, blue: 0.55, alpha: 1.0),   // neon green
            UIColor(red: 1.0, green: 0.2, blue: 0.6, alpha: 1.0),     // hot pink
            UIColor(red: 0.0, green: 0.6, blue: 1.0, alpha: 1.0),      // electric blue
            UIColor(red: 1.0, green: 0.85, blue: 0.0, alpha: 1.0),     // spray yellow
            UIColor(red: 1.0, green: 0.45, blue: 0.0, alpha: 1.0),    // orange
            UIColor(red: 0.6, green: 0.0, blue: 1.0, alpha: 1.0),      // purple
            UIColor(red: 0.0, green: 1.0, blue: 0.8, alpha: 1.0),      // cyan
            UIColor(red: 1.0, green: 0.3, blue: 0.2, alpha: 1.0)      // red-orange
        ]
        return colors.randomElement() ?? .white
    }
    
    // Irregular spray splatter - organic blob
    private func createSplatterImage() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let cg = ctx.cgContext
            cg.setFillColor(UIColor.white.cgColor)
            // Irregular shape: overlapping circles for splatter effect
            let centers = [(20,20), (14,18), (26,16), (18,26), (24,22)]
            let radii: [CGFloat] = [12, 8, 6, 10, 5]
            for (i, (x, y)) in centers.enumerated() {
                cg.fillEllipse(in: CGRect(x: CGFloat(x) - radii[i], y: CGFloat(y) - radii[i],
                                         width: radii[i]*2, height: radii[i]*2))
            }
        }
    }
    
    // Paint drip - elongated teardrop
    private func createDripImage() -> UIImage? {
        let size = CGSize(width: 24, height: 48)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 12, y: 4))
            path.addCurve(to: CGPoint(x: 12, y: 44),
                         controlPoint1: CGPoint(x: 22, y: 20),
                         controlPoint2: CGPoint(x: 20, y: 44))
            path.addCurve(to: CGPoint(x: 12, y: 4),
                         controlPoint1: CGPoint(x: 4, y: 44),
                         controlPoint2: CGPoint(x: 2, y: 20))
            path.close()
            UIColor.white.setFill()
            path.fill()
        }
    }
    
    // Fine spray dots - varied opacity
    private func createSprayDotImage() -> UIImage? {
        let size = CGSize(width: 16, height: 16)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let cg = ctx.cgContext
            cg.setFillColor(UIColor(white: 1, alpha: 0.9).cgColor)
            cg.fillEllipse(in: CGRect(x: 4, y: 4, width: 8, height: 8))
        }
    }
    
    // Brush stroke - elongated oval
    private func createBrushStrokeImage() -> UIImage? {
        let size = CGSize(width: 48, height: 16)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let cg = ctx.cgContext
            cg.setFillColor(UIColor.white.cgColor)
            cg.fillEllipse(in: CGRect(x: 2, y: 2, width: 44, height: 12))
        }
    }
    
    func startRain() {
        emitterLayer.birthRate = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.emitterLayer.birthRate = 0
        }
    }
    
    func stopRain() {
        emitterLayer.birthRate = 0
    }
}
