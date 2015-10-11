//
//  PointerHelper.swift
//  WaveAttack
//
//  Created by James on 5/10/15.
//
//

import Foundation


class PointerHelper{
    static func toPointer<T>(p: UnsafePointer<T>)->UnsafePointer<T>{
        return p
    }
}