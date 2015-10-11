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
    var wave:Wave
    var str:Int
    var texture:SKTexture
    var skill:String?
    init(res:String){
        CharacterParser.parse(res)
        //.
        //.
        //.
        wave=Wave()
        str=0
        texture=SKTexture()
    }
    
    func getWave()->Wave{
        return wave
    }
}