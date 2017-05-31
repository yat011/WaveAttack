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
    
    static func createARGBBitmapContext(inImage: CGImage) -> CGContext {
        var bitmapByteCount = 0
        var bitmapBytesPerRow = 0
        
        //Get image width, height
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        bitmapBytesPerRow = Int(pixelsWide) * 4
        bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc(Int(bitmapByteCount))
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, CGImageAlphaInfo.Last.rawValue)
       //  CGBIT
        
        // Make sure and release colorspace before returning
       // CGColorSpaceRelease(colorSpace)
        
        return context!
    }
    
    static func getPixelColorAtLocationArray(inImage:CGImageRef) -> UnsafePointer<UInt8> {
        // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
        let context = TextureTools.createARGBBitmapContext(inImage)
        
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
        
        //Clear the context
        CGContextClearRect(context, rect)
        
        // Draw the image to the bitmap context. Once we draw, the memory
        // allocated for the context for rendering will then contain the
        // raw image data in the specified color space.
        CGContextDrawImage(context, rect, inImage)
        
        // Now we can get a pointer to the image data associated with the bitmap
        // context.
        let data = CGBitmapContextGetData(context)
        let dataType = UnsafePointer<UInt8>(data)
       /*
        let offset = 4*((Int(pixelsWide) * Int(point.y)) + Int(point.x))
        let alpha = dataType[offset]
        let red = dataType[offset+1]
        let green = dataType[offset+2]
        let blue = dataType[offset+3]
        let color = UIColor(red: Float(red)/255.0, green: Float(green)/255.0, blue: Float(blue)/255.0, alpha: Float(alpha)/255.0)
        */
        print(dataType[0])
        // When finished, release the context
      //  CGContextRelease(context);
        // Free image data memory for the context
        //free(data)
        return dataType 
    }
    
}