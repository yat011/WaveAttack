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
    var texture:SKTexture?
    var icon:SKTexture?
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
        icon=SKTexture(noiseWithSmoothness: CGFloat(0.5), size: CGSize(width: 50, height: 50), grayscale: false)
    }
    
    func getWave()->Wave{
        return wave!
    }
    func getIcon()->SKTexture?{
        return icon
    }
    func getTexture()->SKTexture?{
        return texture
    }
}