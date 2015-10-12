//
//  CharacterParser.swift
//  WaveAttack
//
//  Created by James on 8/10/15.
//
//

import Foundation
import SpriteKit

class CharacterManager{
    static var characters:[Character]?
    static func parse(res:String){
        var name="characters"
        if let dict = JSONHelper.loadJSON(name){
            //JSONHelper testing
            print(dict)
            let c=JSONHelper.getArrayItem(dict, key: "characters", index: 0)
            print(c["wave"])
            let w=JSONHelper.getArrayItem(c, key: "wave", index: 1)
            print(w)
            let s=JSONHelper.getValue(w, key: "length")
            let i=s.integerValue
            print(i)
            
            //parse to Character
            characters=[Character]()
            for i in 0...JSONHelper.getArrayCount(dict, key: "characters")-1{
                let c=JSONHelper.getArrayItem(dict, key: "characters", index: i)
                
                let character=Character()
                let wave=Wave()
                for i in 0...JSONHelper.getArrayCount(c, key: "wave")-1{
                    let w=JSONHelper.getArrayItem(c, key: "wave", index: i)
                    
                    wave.componentList.append(Wave.waveComponent(type: JSONHelper.getValue(w, key: "type").description, length: JSONHelper.getValue(w, key: "length").integerValue, height: CGFloat(JSONHelper.getValue(w, key: "height").integerValue)))
                }
                character.wave=wave
                characters?.append(character)
            }
        }
    }
}