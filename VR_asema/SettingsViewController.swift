//
//  SettingsViewController.swift
//  VR_asema
//
//  Created by Matti Saarela on 10/02/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//



import UIKit

struct Settings {
    //asetus-tietotyyppi. Sisältää samalla myös initial-asetukset
    var hoursShowed: Int = 12
    var showCommercialStationsOnly: Bool = false
    var showCargo: Bool = true
    var showLongDistance: Bool = true
    var showCommuter: Bool = true
}

protocol settingsProtocol {
    //Protokolla jolla asetukset välitetään takaisin päin
    func setSettings(settings: Settings )
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var hourSlider: UISlider!
    @IBOutlet weak var commercialStationsOnlySwitch: UISwitch!
    @IBOutlet weak var cargoSwitch: UISwitch!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var longDistanceSwitch: UISwitch!
    @IBOutlet weak var commuterSwitch: UISwitch!
    
    
    var settings = Settings()
    var delegate: settingsProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Asetetaan kytkimet ja kentät asetusten mukaisiksi
        hourLabel.text = "Näytä junat seuraavan " + String(settings.hoursShowed) + " tunnin ajalta."
        hourSlider.value = Float(settings.hoursShowed)
        commercialStationsOnlySwitch.isOn = settings.showCommercialStationsOnly
        cargoSwitch.isOn = settings.showCargo
        longDistanceSwitch.isOn = settings.showLongDistance
        commuterSwitch.isOn = settings.showCommuter
        

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
        settings.showCargo = sender.isOn
        delegate?.setSettings(settings: settings)
    }
    
    @IBAction func longDistanceSwitchValueChanged(_ sender: UISwitch) {
        settings.showLongDistance = sender.isOn
        delegate?.setSettings(settings: settings)
    }
    
    @IBAction func commuterSwitchValueChanged(_ sender: UISwitch) {
        settings.showCommuter = sender.isOn
        delegate?.setSettings(settings: settings)
    }
    
    

}
