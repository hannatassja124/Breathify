//
//  InstructionModel.swift
//  Breathify
//
//  Created by Hannatassja Hardjadinata on 30/04/21.
//

import Foundation
import AVFoundation

class Instruction {
    var instructionText : String?
    var instructionDuration : Int?
    
    init(instructionText: String, instructionDuration:Int){
        self.instructionText = instructionText
        self.instructionDuration = instructionDuration
    }
    
    func setData(){
        
    }
}
