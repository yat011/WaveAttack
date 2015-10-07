//
//  TextureTools.swift
//  WaveAttack
//
//  Created by yat on 8/10/2015.
//
//

import Foundation
import SpriteKit


class TextureTools {
    
    static func createTiledTexture(fileName: String, tiledSize : CGSize, targetSize: CGSize) -> UIImage{
        var texture = UIImage(named: fileName)
        UIGraphicsBeginImageContext(targetSize)
        var context =  UIGraphicsGetCurrentContext()
        CGContextDrawTiledImage(context, CGRect(origin: CGPoint(), size: tiledSize), texture!.CGImage)
        var tiledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tiledImage

    }
    
    
}