//
//  ViewController.swift
//  VR_asema
//
//  Created by Matti Saarela on 07/02/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UISearchResultsUpdating, settingsProtocol {

    @IBOutlet weak var stationTableView: UITableView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    var settings = Settings()
    final let stationDataURL = URL(string: "https://rata.digitraffic.fi/api/v1/metadata/stations") //Osoite josta haetaan asemien data
    var asematFull = [Station]() //Suodattamaton asemataulukko
    var asemat = [Station]()    //listaan käytetty asemataulukko
    var asematFiltered = [Station]()    //hakutoiminnon rajoittama asemataulukko
    var rowSelection: Int? = nil    
    var segueSelectedAction: String? = nil
    let searchController = UISearchController(searchResultsController: nil)
 
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Pysäkit"
        settingsButton.isEnabled = false
        settingsButton.isEnabled = true
        downloadStationData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        stationTableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadStationData(){
        //Lataa listan asemista
        guard let downloadURL = stationDataURL else{return} //Tarkistetaan että osoite on toimiva
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil else { //Tarkistetaan että data on oikeasti olemassa
                //Näytetään käyttäjälle ilmoitus virheestä
                let alert = UIAlertController(title: "Latausvirhe!", message: "Tietojen lataus epäonnistui.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    NSLog("Download error occured while downloading stationdata! :" + error.debugDescription)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            //Suoritetaan JSonin dekoodaaminen
            do{
                let decoder = JSONDecoder()
                let decoded_stationData = try decoder.decode([Station].self, from: data)
                if self.settings.showCommercialStationsOnly == true {
                    self.asemat = decoded_stationData.filter({$0.passengerTraffic == true})
                }
                else {
                    self.asemat = decoded_stationData
                }
                self.asematFull = decoded_stationData
                DispatchQueue.main.async {
                    //Taulukon päivittäminen täytyy suorittaa pääsäikeessä
                    self.asematFiltered = self.asemat
                    self.stationTableView.reloadData()
                }
            }catch{
                let alert = UIAlertController(title: "Virhe!", message: "Virhe tietoja käsitellessä.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    NSLog("Decoding Error occured! :" + error.localizedDescription)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            }.resume()
    }
    
    //Lähettää TableView:n valitun rivin tiedon toiselle ViewControllerille
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue"{
            let SettingsViewController = segue.destination as! SettingsViewController
            SettingsViewController.delegate = self
            SettingsViewController.settings = settings
        }
        else {
            if  rowSelection != nil && segueSelectedAction != nil {
                let StationListViewController = segue.destination as! StationListViewController
                StationListViewController.selectedStation = asematFiltered[rowSelection!].stationShortCode
                StationListViewController.selectedAction = segueSelectedAction!
                StationListViewController.stations = asematFull //Lähetetään lista kaikista asemista shortcoden vertausta varten
                if segueSelectedAction == "ARRIVAL" {
                    StationListViewController.navTitle = "Saapuvat, " + asematFiltered[rowSelection!].stationName
                }
                else if segueSelectedAction == "DEPARTURE" {
                    StationListViewController.navTitle = "Lähtevät, " + asematFiltered[rowSelection!].stationName
                }
                StationListViewController.settings = settings
            }
        }
    }
    
    //Painikkeiden toimintakoodit
    @IBAction func Incoming_ButtonPressed(_ sender: UIButton) {
        if rowSelection != nil {
            segueSelectedAction = "ARRIVAL"
            performSegue(withIdentifier: "stationSelectSegue", sender: self)
        }
    }
    
    @IBAction func Outgoing_ButtonPressed(_ sender: UIButton) {
        if rowSelection != nil {
            segueSelectedAction = "DEPARTURE"
            performSegue(withIdentifier: "stationSelectSegue", sender: self)
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    //Päivittää suodatetun taulukon kun hakutoimintoa käytetään
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            asematFiltered = asemat
        }
        else {
            asematFiltered = asemat.filter({$0.stationName.lowercased().contains(searchController.searchBar.text!.lowercased())})
        }
        stationTableView.reloadData()
    }
    
    func setSettings(settings: Settings) {
        self.settings = settings
    }
}

extension ViewController: UITableViewDataSource {
    //Taulukkonäkymän luomiseen tarvittavat funktiot
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asematFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StationTableProto") as? StationTableViewCell
            else {return UITableViewCell()}
        cell.station_label.text = asematFiltered[indexPath.row].stationName
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    //Valinnan tapahtuessa suoritettava funktio
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Suoritetaan kun kohde valitaan TableView-näkymässä
        rowSelection = indexPath.row
    }
}

