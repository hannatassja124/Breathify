//
//  SettingViewController.swift
//  Breathify
//
//  Created by Hannatassja Hardjadinata on 30/04/21.
//

import UIKit

class SettingViewController: UITableViewController {


    let defaults = UserDefaults.standard
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var soundSwitcher: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.object(forKey: "soundSwitch") != nil {
            soundSwitcher.isOn =  defaults.bool(forKey: "soundSwitch")
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func notificationSwitch(_ sender: Any) {
        //notifSwitcher.isOn = !notifSwitcher.isOn
    }
    
    @IBAction func soundNotification(_ sender: Any) {

    }
    
    @IBAction func doneButton(_ sender: Any) {
        defaults.setValue(soundSwitcher.isOn, forKey: "soundSwitch")
        

        print("set setting", defaults.object(forKey: "soundSwitch"))
        self.dismiss(animated: true)
    }
    
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            let mainViewController = self.presentingViewController as? ViewController
            super.dismiss(animated: flag) {
                mainViewController?.viewWillAppear(true)
        }
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
