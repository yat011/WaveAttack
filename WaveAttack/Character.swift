//
//  Character.swift
//  WaveAttack
//
//  Created by James on 8/10/15.
//
//

import Foundation
import SpriteKit

class Character{
    var wave:Wave?
    var str:Int
    var texture:SKTexture
    var skill:Skill?
    var ID:Int
    var name:String
    var lore:String
    
    init(){
        //.
        //.
        //.
        str=0
        ID=0
        name=""
        lore=""
        texture=SKTexture()
    }
    
    func getWave()->Wave{
        return wave!
    }
}