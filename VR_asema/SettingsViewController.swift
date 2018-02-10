//
//  SettingsViewController.swift
//  VR_asema
//
//  Created by Matti Saarela on 10/02/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//



import UIKit

struct Settings {
    var hoursShowed: Int = 12
    var showCommercialStationsOnly: Bool = false
    var showCargo: Bool = true
    
    
}

protocol settingsProtocol {
    func setSettings(settings: Settings )
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var hourSlider: UISlider!
    @IBOutlet weak var commercialStationsOnlySwitch: UISwitch!
    @IBOutlet weak var cargoSwitch: UISwitch!
    @IBOutlet weak var hourLabel: UILabel!
    
    var settings = Settings()
    var delegate: settingsProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourLabel.text = "Näytä junat seuraavan " + String(settings.hoursShowed) + " tunnin ajalta."
        hourSlider.value = Float(settings.hoursShowed)
        commercialStationsOnlySwitch.isOn = settings.showCommercialStationsOnly
        cargoSwitch.isOn = !settings.showCargo

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  //Painikefunktiot
    @IBAction func hourSliderValueChanged(_ sender: UISlider) {
        settings.hoursShowed = Int(sender.value)
        delegate?.setSettings(settings: settings)
        hourLabel.text = "Näytä junat seuraavan " + String(settings.hoursShowed) + " tunnin ajalta."
    }
    
    
    @IBAction func commercialStationsOnlySwitchValueChanged(_ sender: UISwitch) {
        settings.showCommercialStationsOnly = sender.isOn
        delegate?.setSettings(settings: settings)
    }
    
    @IBAction func cargoSwitchValueChanged(_ sender: UISwitch) {
        settings.showCargo = !sender.isOn
        delegate?.setSettings(settings: settings)
    }

}
