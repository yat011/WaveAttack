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
    static var team:[Int]=[0,0,0,0,0]
    static var characters:[Character]?
    static func parse(res:String){
        var name="characters"
        if let dict = JSONHelper.loadJSON(name){
/*
            //JSONHelper testing
            print(dict)
            let c=JSONHelper.getArrayItem(dict, key: "characters", index: 0)
            print(c["wave"])
            let w=JSONHelper.getArrayItem(c, key: "wave", index: 1)
            print(w)
            let s=JSONHelper.getValue(w, key: "length")
            let i=s.integerValue
            print(i)
*/
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
                
                character.ID=JSONHelper.getValue(c, key: "characterID").integerValue
                character.name=JSONHelper.getValue(c, key: "name").description
                character.lore=JSONHelper.getValue(c, key: "lore").description
                character.str=JSONHelper.getValue(c, key: "strength").integerValue
                character.wave=wave
                
                characters?.append(character)
            }
        }
    }
    static func getCharacterByID(ID:Int)->Character?{
        if (characters == nil) {return nil}
        for c in characters!{
            if (c.ID==ID) {return c}
        }
        return nil
    }
    static func getCharacterByName(name:String)->Character?{
        if (characters == nil) {return nil}
        for c in characters!{
            if (c.name==name) {return c}
        }
        return nil
    }
    static func sortByID(){
        
    }
    static func sortBySTR(){
        
    }
    static func sortByName(){
        
    }
}