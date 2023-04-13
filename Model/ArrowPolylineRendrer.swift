//
//  ArrowPolylineRendrer.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 17/03/23.
//

import Foundation
import MapKit


//context.setStrokeColor(self.strokeColor?.cgColor ?? .init(gray: 5, alpha: 1))

class ArrowPolylineRenderer: MKPolylineRenderer {

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let lineWidth: CGFloat = 5.0
        self.lineWidth = lineWidth
        self.strokeColor = .blue

        super.draw(mapRect, zoomScale: zoomScale, in: context)

        let arrowSize: CGFloat = 10.0

        guard let path = self.path else {
            return
        }

        context.saveGState()

        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setStrokeColor(self.strokeColor?.cgColor ?? .init(gray: 5, alpha: 1))

        var previousPoint: CGPoint?
        let stepSize: CGFloat = 50.0 // Change this value to control the spacing between arrows
        var distance: CGFloat = 0

        path.applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            if element.type == .addLineToPoint {
                guard let startPoint = previousPoint else { return }
                let endPoint = element.points[0]

                let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)

                let arrowPath = CGMutablePath()
                arrowPath.move(to: endPoint)
                arrowPath.addLine(to: CGPoint(x: endPoint.x - arrowSize * cos(angle + .pi / 6),
                                              y: endPoint.y - arrowSize * sin(angle + .pi / 6)))
                arrowPath.addLine(to: CGPoint(x: endPoint.x - arrowSize * cos(angle - .pi / 6),
                                              y: endPoint.y - arrowSize * sin(angle - .pi / 6)))
                arrowPath.closeSubpath()

                context.addPath(arrowPath)
                context.strokePath()

                distance += stepSize
            }
            previousPoint = element.points[0]
        }

        context.restoreGState()
    }
}
