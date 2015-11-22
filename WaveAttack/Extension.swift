//
//  Extension.swift
//  WaveAttack
//
//  Created by yat on 14/9/2015.
//
//

import Foundation
import SpriteKit
import CoreData

extension CGVector {
    
    mutating func normalize()->(){
        let len = sqrt( self.dx * self.dx + self.dy * self.dy)
        self.dx /= len
        self.dy /= len
    
    }
    
    func dot(b: CGVector) -> CGFloat{
       return self.dx * b.dx + self.dy * b.dy
    }
    
    var length: CGFloat { get{return sqrt( self.dx * self.dx + self.dy * self.dy) }}
    
}

public func *(lhs : CGFloat, rhs: CGVector) -> CGVector{
    return CGVector(dx: lhs * rhs.dx, dy: lhs * rhs.dy)
}

public func + (lhs: CGVector, rhs: CGVector) -> CGVector{
    return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

public func - (lhs: CGVector, rhs: CGVector) -> CGVector{
    return lhs + ( -1 * rhs)
}

public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint{
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func + (lhs: CGPoint, rhs: CGVector) -> CGPoint{
    return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}


public func == (lhs: CGPoint, rhs: CGPoint) -> Bool{
    return (lhs.x == rhs.x && lhs.y == rhs.y)
}

public func - (lhs: CGPoint, rhs: CGPoint) -> CGVector{
    return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
}

public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint{
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}
extension Int {
    var f: CGFloat { return CGFloat(self) }
}

extension Float {
    var f: CGFloat { return CGFloat(self) }
}

extension Double {
    var f: CGFloat { return CGFloat(self) }
}

extension CGFloat {
    var swf: Float { return Float(self) }
}


extension Dictionary {
    static func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        var res : Dictionary<String, AnyObject>? = nil
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
            
            do{
                let data = try NSData(contentsOfFile: path, options: NSDataReadingOptions())
                
                
                
                
                let dictionary = try NSJSONSerialization.JSONObjectWithData(data,options: NSJSONReadingOptions())
                //print (dictionary)
                res = dictionary  as! Dictionary<String, AnyObject>
                return res
                
                
                
            }
            catch {
                print("Could not load level file: \(filename) ")
                return nil
            }
        } else {
            print("Could not find level file: \(filename)")
            return nil
        }
        return nil
    }
    
}
extension Array{
    mutating func removeObject(obj :AnyObject) -> Element?{
        for var i = 0 ; i < self.count ; i++ {
            if obj === (self[i] as! AnyObject){
               return self.removeAtIndex(i)
            }
        }
        return nil
    }
}


class Weak<T: AnyObject> : Hashable, Equatable {
    public var hashValue: Int { get {
        if (value != nil){
           return unsafeAddressOf(value!).hashValue
        }
        return unsafeAddressOf(self).hashValue
        
        } }
    weak var value : T?
    init (_ value: T) {
        self.value = value
    }
  
}

func ==<T:AnyObject>(lhs: Weak<T>, rhs: Weak<T>) -> Bool {
    guard lhs.value != nil && rhs.value != nil else {return false}
    if lhs.value! === rhs.value!{
        return true
    }
    return false
}

