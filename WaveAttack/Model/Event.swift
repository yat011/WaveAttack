//
//  Event.swift
//  WaveAttack
//
//  Created by yat on 3/10/2015.
//
//

import Foundation

enum GameEvent : String{
    case HpChanged = "hpchanged",
    RoundChanged = "roundchanged",
    Dead = "dead",
    SkillReady = "skillready",
    SKillPending = "skillpending",
    SKillUsed = "skillused",
    PlayerDead = "playerdead",
    EarthquakeStart = "earthquakestart",
    EarthquakeEnd = "earthquakeend",
    Scored = "scored"
    
}