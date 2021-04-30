//
//  SettingViewController.swift
//  Breathify
//
//  Created by Hannatassja Hardjadinata on 30/04/21.
//

import UIKit

class SettingViewController: UITableViewController {

    
    var settings : [Setting] = []
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var notifSwitcher: UISwitch!
    @IBOutlet weak var soundSwitcher: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func notificationSwitch(_ sender: Any) {
        //notifSwitcher.isOn = !notifSwitcher.isOn
        defaults.setValue(notifSwitcher.isOn, forKey: "notifSwitch")
        print("notif", UserDefaults.standard.string(forKey: "notifSwitch") ?? "0")
    }
    
    @IBAction func soundNotification(_ sender: Any) {
        defaults.setValue(soundSwitcher.isOn, forKey: "soundSwitch")
        print("sound", UserDefaults.standard.string(forKey: "soundSwitch") ?? "1")
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
