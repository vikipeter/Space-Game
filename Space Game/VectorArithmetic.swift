//
//  VectorArithmetic.swift
//  Space Game
//
//  Created by Vigneshkumar G on 05/12/16.
//  Copyright © 2016 Vigneshkumar G. All rights reserved.
//

import UIKit

class VectorArithmetic
{
    class func vectorAdd(a:CGPoint,b:CGPoint) -> CGPoint
    {
        return CGPoint(x: a.x + b.x, y: a.y + b.y)
    }
    
    class func vectorSubtract(a:CGPoint,b:CGPoint) -> CGPoint
    {
        return CGPoint(x: a.x - b.x, y: a.y - b.y)
    }
    
    class func vectorMultiplay(a:CGPoint,b:CGFloat) -> CGPoint
    {
        return CGPoint(x: a.x * b, y: a.y * b)
    }
    
    class func vectorLength(a:CGPoint) -> CGFloat
    {
        return CGFloat(sqrt(CFloat(a.x) * CFloat(a.x) + CFloat(a.y) * CFloat(a.y)))
    }
    
    class func vectorNormalize(a:CGPoint) -> CGPoint
    {
        let length = vectorLength(a: a)
        return CGPoint(x: a.x/length, y: a.y/length)
    }
}
