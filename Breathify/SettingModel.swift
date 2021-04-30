//
//  SettingModel.swift
//  Breathify
//
//  Created by Hannatassja Hardjadinata on 30/04/21.
//

import Foundation

import Foundation

class Setting: NSObject, NSCoding
{
    //Set Key Value
    func encode(with coder: NSCoder) {
        coder.encode(isNotification, forKey: "notification")
        coder.encode(isSound, forKey: "sound")
    }
    
    required convenience init?(coder: NSCoder) {
        
        //Pastikan data tidak kosong
        guard let isNotification = coder.decodeBool(forKey: "notification") as? Bool,
                    let isSound = coder.decodeBool(forKey: "sound") as? Bool

            else { return nil }

            //convert data jadi strings
            self.init(
                isNotification: isNotification,
                isSound: isSound
            )
    }
    
    var isNotification: Bool
    var isSound: Bool

    
    init(isNotification: Bool, isSound: Bool)
    {
        self.isNotification = isNotification
        self.isSound = isSound
        
    }

}
