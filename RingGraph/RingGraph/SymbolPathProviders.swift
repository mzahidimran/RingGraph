//
//  SymbolPathProviders.swift
//  RingGraph
//
//  Created by Kreft, Michal on 18.04.15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//  ImageProvider (c) Sebastien REMY (@iLandes on github) on 09.2016
//

import UIKit

let DefaultSymbolAnimationStart :Float = 0.3
let DefaultSymbolAnimationEnd :Float = 0.6

public protocol SymbolPathProvider {
    func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath
}

public class DefaultPathProvider {
    let animationHelper: RangeAnimationHelper = RangeAnimationHelper(animationStart: DefaultSymbolAnimationStart, animationEnd: DefaultSymbolAnimationEnd)
    let margin :CGFloat = 2
    
    public init() { }
    
    func defaultPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.lineCapStyle = CGLineCap.Round
        path.lineJoinStyle = CGLineJoin.Round
        path.lineWidth = 3
        
        return path
    }
    
    public func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        return UIBezierPath()
    }
    
    func normalizedProgress(progress :Float) -> CGFloat {
        return CGFloat(animationHelper.normalizedProgress(absoluteProgress: progress))
    }
}


public class ImageProvider : DefaultPathProvider, SymbolPathProvider {
    // Class Added by Sebastien REMY (@iLandes on github) on Sept' 2016
    
    private var image: UIImage?
    private let kTransparent =  UIColor(white: 1, alpha: 0)
    
    public init(image: UIImage?) {
        self.image = image
        super.init()
    }
    
    override public func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        let progress = normalizedProgress(animationProgress)
        
        if (progress == 0.0) {
            return super.path(inRect: rect, forAnimationProgress: animationProgress)
        }
        
        let path = UIBezierPath()
        
        
        // Draw a Rect path
        var points = [CGPoint]()
        let w = CGFloat(Int(CGRectGetMinX(rect)+CGRectGetMaxX(rect)))  // Use integer value (image size is non decimal)
        let h = CGFloat(Int(CGRectGetMinY(rect)+CGRectGetMaxY(rect)))  // Use integer value (image size is non decimal)
        let r = CGRect(x: 0, y: 0, width: w, height: h)
        
        points.append(CGPoint(x: 0, y: 0))
        points.append(CGPoint(x: w, y: 0))
        points.append(CGPoint(x: w, y: h))
        points.append(CGPoint(x: 0, y: h))
        
        path.lineWidth = 0
        path.moveToPoint(points[0])
        path.addLineToPoint(points[1])
        path.addLineToPoint(points[2])
        path.addLineToPoint(points[3])
        path.closePath()
        
        
        // Fill path
        if let i = image {

            // Resizing Image
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1)
            i.drawInRect(r)
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Fill with Resized Image
             UIColor(patternImage: resizedImage).setFill()
            
        } else {
            // Fill Transparent
            kTransparent.setFill()
        }
        
        path.fill()
        
        return path
    }
}

public class RightArrowPathProvider : DefaultPathProvider, SymbolPathProvider {
    
    override public func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        let progress = normalizedProgress(animationProgress)
        
        if (progress == 0.0) {
            return super.path(inRect: rect, forAnimationProgress: animationProgress)
        }
        
        var points = [CGPoint]()
        
        let middleEndPoint = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMidY(rect))
        
        var intermediatePoint1 = middleEndPoint
        intermediatePoint1.x = middleEndPoint.x * progress
        
        var intermediatePoint2 = middleEndPoint
        intermediatePoint2.x = CGRectGetMidX(rect) + middleEndPoint.x * progress / 2
        
        points.append(intermediatePoint1)
        points.append(CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMidY(rect)))
        
        points.append(intermediatePoint2)
        points.append(CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMinY(rect)))
        points.append(CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMaxY(rect)))
        
        let path = defaultPath()
        
        path.moveToPoint(points[0])
        path.addLineToPoint(points[1])
        path.moveToPoint(points[2])
        path.addLineToPoint(points[3])
        path.moveToPoint(points[2])
        path.addLineToPoint(points[4])
        path.closePath()
        
        return path
    }
    
}

public class UpArrowPathProvider : RightArrowPathProvider {
    
    override public func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        let path = super.path(inRect: rect, forAnimationProgress: animationProgress)
        
        let center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        let radians = CGFloat(-90 * M_PI / 180)
        
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, center.x, center.y)
        transform = CGAffineTransformRotate(transform, radians)
        transform = CGAffineTransformTranslate(transform, -center.x, -center.y)
        
        path.applyTransform(transform)
        
        return path
    }
    
}

private let intermediateAnimationPoint :Float = DefaultSymbolAnimationEnd - 0.1

public class DoubleRightArrowPathProvider : DefaultPathProvider, SymbolPathProvider {
    
    let leftAnimationHelper: RangeAnimationHelper = RangeAnimationHelper(animationStart: DefaultSymbolAnimationStart, animationEnd: intermediateAnimationPoint)
    let rightAnimationHelper: RangeAnimationHelper = RangeAnimationHelper(animationStart: intermediateAnimationPoint, animationEnd: DefaultSymbolAnimationEnd)
    let arrowSpacing :CGFloat = 6
    
    override public func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        let progress = normalizedProgress(animationProgress)
        
        if (progress == 0.0) {
            return super.path(inRect: rect, forAnimationProgress: animationProgress)
        }
        
        let leftProgress = CGFloat(leftAnimationHelper.normalizedProgress(absoluteProgress: animationProgress))
        let rightProgress = CGFloat(rightAnimationHelper.normalizedProgress(absoluteProgress: animationProgress))
        
        var points = [CGPoint]()
        
        let middleEndPoint = CGPoint(x: CGRectGetMaxX(rect) - arrowSpacing, y: CGRectGetMidY(rect))
        let rightEndPoint = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMidY(rect))
        
        var intermediatePoint1 = middleEndPoint
        intermediatePoint1.x = middleEndPoint.x * leftProgress
        
        points.append(intermediatePoint1)
        points.append(CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMidY(rect)))
        points.append(CGPoint(x: CGRectGetMidX(rect) - arrowSpacing, y: CGRectGetMinY(rect)))
        points.append(CGPoint(x: CGRectGetMidX(rect) - arrowSpacing, y: CGRectGetMaxY(rect)))
        
        if (rightProgress > 0) {
            let delta = arrowSpacing * (1 - rightProgress)
            var intermediateEndPoint2 = rightEndPoint
            intermediateEndPoint2.x -= delta
            
            points.append(intermediateEndPoint2)
            points.append(CGPoint(x: CGRectGetMidX(rect) - delta, y: CGRectGetMinY(rect)))
            points.append(CGPoint(x: CGRectGetMidX(rect) - delta, y: CGRectGetMaxY(rect)))
        }
        
        return pathFromPoints(points)
    }
    
    func pathFromPoints(points :[CGPoint]) -> UIBezierPath {
        let path = defaultPath()
        
        path.moveToPoint(points[0])
        path.addLineToPoint(points[1])
        path.moveToPoint(points[0])
        path.addLineToPoint(points[2])
        path.moveToPoint(points[0])
        path.addLineToPoint(points[3])
        
        if (points.count > 4) {
            path.moveToPoint(points[4])
            path.addLineToPoint(points[5])
            path.moveToPoint(points[4])
            path.addLineToPoint(points[6])
        }
        
        path.closePath()
        
        return path
    }
    
}

internal class NilPathProvider : SymbolPathProvider {
    func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        return UIBezierPath()
    }
}
