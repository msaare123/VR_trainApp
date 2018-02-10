//
//  StationListViewController.swift
//  VR_asema
//
//  Created by Matti Saarela on 07/02/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import UIKit

class StationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let categoryTranslation: [String:String] = ["Commuter":"Lähijuna",
                                            "Locomotive":"Veturi",
                                            "Shunting":"Vaihtotyö",
                                            "Long-distance":"Kaukoliikenne",
                                            "Cargo":"Tavarajuna",
                                            "On-track machines":"Radalla kulkeva kone",
                                            "Test drive":"Koeajo"]
    
    //Muuttujat jotka tuodaan seguella toisesta näkymästä
    var selectedStation: String? = nil
    var selectedAction: String? = nil
    var selectedRow: Int? = nil
    var stations = [Station]()
    var navTitle: String? = nil
    var settings = Settings()
    
    //IF Outlets
    @IBOutlet weak var tableActivity: UIActivityIndicatorView!
    @IBOutlet weak var TrainTableView: UITableView!
    
    var junat = [Junat]() //Kaikki aseman ladatut tiedot
    
    override func viewWillAppear(_ animated: Bool) {
        if navTitle != nil {
            navigationItem.title = navTitle
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableActivity.startAnimating()
        downloadTrainJSON()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func urlConvertScandi(string: String) -> String{
        
        //Joidenkin asemapaikkojen tunnisteissa käytetään skandeja, jotka täytyy muuttaa urlissa toimiviksi
        var converted: String = ""
        for i in string {
            if i == "Ä" || i == "ä" {
                converted.append("%C3%84")
            }
            else if i == "Ö" || i == "ö"{
                converted.append("%C3%96")
            }
            else { converted.append(i) }
        }
        return converted
    }
    
    
    func downloadTrainJSON(){
        //Funktio joka lataa JSON-taulukon junat-muuttujaan
        
        var departing_trains = 0
        var arriving_trains = 0
        
        if selectedAction == "DEPARTURE" {
            departing_trains = 60 * settings.hoursShowed
        }
        else if selectedAction == "ARRIVAL" {
            arriving_trains = 60 * settings.hoursShowed
        }
        
        //Osoite josta haetaan junadata
        let mainDataURL = URL(string: "https://rata.digitraffic.fi/api/v1//live-trains/station/" + urlConvertScandi(string: selectedStation!) + "?minutes_before_departure=" + String(departing_trains)+"&minutes_after_departure=0&minutes_before_arrival=" + String(arriving_trains)+"&minutes_after_arrival=0")
        
        guard let downloadURL = mainDataURL else{return} //Tarkistetaan, että url on toimiva
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil else { //Tarkistetaan että data on saatu
                //Käyttäjälle näytetään ilmoitus virheestä
                let alert = UIAlertController(title: "Latausvirhe!", message: "Tietojen lataus epäonnistui!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    NSLog("Download alert occured while downloading traindata!" + error.debugDescription)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            print ("Downloaded successfully!")
            
            //JSON Dekoodaus
            do{
                // virheenkäsittely mukautetulle päivämäärädekoodaukselle
                enum DateError: String, Error {
                    case invalidDate
                }
                
                let decoder = JSONDecoder()
                
                // Määritellään mukautettu päivämäärän dekoodaus
                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateStr = try container.decode(String.self)
                    let formatter = DateFormatter()
                    
                    //Yleisin muoto datassa
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                    if let date = formatter.date(from: dateStr) {
                        return date
                    }
                    
                    //Varmuuden vuoksi standardin mukainen päivämäärä.
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
                    if let date = formatter.date(from: dateStr) {
                        return date
                    }
                    
                    //Toiseksi yleisin datassa
                    formatter.dateFormat = "yyyy-MM-dd"
                    if let date = formatter.date(from: dateStr) {
                        return date
                    }
                    throw DateError.invalidDate
                })
                let decoded_mainData = try decoder.decode([Junat].self, from: data)
                if self.settings.showCargo == false {
                    self.junat = decoded_mainData.filter({$0.trainCategory != "Locomotive" && $0.trainCategory != "Shunting" && $0.trainCategory != "Test drive" && $0.trainCategory != "Cargo" && $0.trainCategory != "On-track machines"})
                }
                else if self.settings.showCargo == true {
                    self.junat = decoded_mainData
                }

                print("decoding successful")
                DispatchQueue.main.async { //Kutsutaan pääsäije
                    //Järjestetään taulu ajankohdan mukaan.

                    self.junat.sort(by: { (i0, i1) -> Bool in
                        if i0.timeTableRows.filter({$0.stationShortCode == self.selectedStation && $0.type == self.selectedAction})[0].liveEstimateTime != nil{
                            if i1.timeTableRows.filter({$0.stationShortCode == self.selectedStation && $0.type == self.selectedAction})[0].liveEstimateTime != nil{
                                return i0.timeTableRows.filter({$0.stationShortCode == self.selectedStation && $0.type == self.selectedAction})[0].liveEstimateTime! < i1.timeTableRows.filter({$0.stationShortCode == self.selectedStation && $0.type == self.selectedAction})[0].liveEstimateTime!
                            }
                            else{
                                return i0.timeTableRows.filter({$0.stationShortCode == self.selectedStation && $0.type == self.selectedAction})[0].liveEstimateTime! < i1.timeTableRows.filter({$0.stationShortCode == self.selectedStation && $0.type == self.selectedAction})[0].scheduledTime
                            }
                        }
                        else if i1.timeTableRows.filter({$0.stationShortCode == self.selectedStation && $0.type == self.selectedAction})[0].liveEstimateTime != nil {
                                return i0.timeTableRows.filter({$0.stationShortCode == self.selectedStation && $0.type == self.selectedAction})[0].scheduledTime < i1.timeTableRows.filter({$0.stationShortCode == self.selectedStation && $0.type == self.selectedAction})[0].liveEstimateTime!
                        }
                        return i0.timeTableRows.filter({$0.stationShortCode == self.selectedStation && $0.type == self.selectedAction})[0].scheduledTime < i1.timeTableRows.filter({$0.stationShortCode == self.selectedStation && $0.type == self.selectedAction})[0].scheduledTime
                    })
                    
                    self.TrainTableView.reloadData()
                    self.tableActivity.stopAnimating()
                }
            }catch{
                let alert = UIAlertController(title: "Virhe!", message: "Tapahtui virhe tietoja käsitellessä.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    NSLog("Download error occured while downloading stationdata! :" + error.localizedDescription)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "routeDetailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return junat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrainTableProto") as? TrainTableViewCell
            else {return UITableViewCell()}
        
        
        //Suodatetaan aikataulusta halutun aseman data
        let filteredStationRow = junat[indexPath.row].timeTableRows.filter{$0.stationShortCode == selectedStation && $0.type == selectedAction}
        
        //Siistimpään päivämääräesitykseen tehdään oma dateformatter
        let fromDate: DateFormatter = DateFormatter()
        fromDate.dateFormat = "dd.MM.yyyy HH:mm"
        
        //Asetetaan labelien sisällöt
        if (filteredStationRow.count > 0) {
            if filteredStationRow[0].liveEstimateTime != nil {
                if selectedAction == "DEPARTURE" {
                    cell.timeLabel.text = fromDate.string(from: filteredStationRow[0].liveEstimateTime!)
                }
                else if selectedAction == "ARRIVAL" {
                    cell.timeLabel.text = fromDate.string(from: filteredStationRow[0].liveEstimateTime!)
                }
            }
            else {
                if selectedAction == "DEPARTURE" {
                    cell.timeLabel.text = fromDate.string(from: filteredStationRow[0].scheduledTime)}
                else if selectedAction == "ARRIVAL" {
                    cell.timeLabel.text = fromDate.string(from: filteredStationRow[0].scheduledTime)}
            }
        }
        cell.trainNumberLabel.text = String(junat[indexPath.row].trainType) + String(junat[indexPath.row].trainNumber)
        cell.category_label.text = categoryTranslation[junat[indexPath.row].trainCategory]
        let firstStationIndex = stations.index(where:{ (station) -> Bool in
            station.stationShortCode == junat[indexPath.row].timeTableRows[0].stationShortCode
        })
        let lastStationIndex = stations.index(where: {(station) -> Bool in
            station.stationShortCode == junat[indexPath.row].timeTableRows[junat[indexPath.row].timeTableRows.count - 1].stationShortCode
        })
        if firstStationIndex != nil && lastStationIndex != nil {
        cell.trailLabel.text = stations[firstStationIndex!].stationName + " - " + stations[lastStationIndex!].stationName
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Lähetys seuraavaan näkymään seguen kautta
        let RouteDetailViewController = segue.destination as! RouteDetailViewController
        if selectedRow != nil {
            
            //Suodatetaan pois asemat jossa ei pysähdytä
            RouteDetailViewController.timeTableRaw = junat[selectedRow!].timeTableRows.filter({$0.trainStopping == true})
            
            //Asemalista myös seuraavaan näkymään
            RouteDetailViewController.stations = stations
            
            //Seuraavan näkymän otsikko
            if let filteredFirstStation = stations.index(where: {(station) -> Bool in
                station.stationShortCode == junat[selectedRow!].timeTableRows[0].stationShortCode}), let filteredLastStation = stations.index(where: {(station) -> Bool in
                station.stationShortCode == junat[selectedRow!].timeTableRows[junat[selectedRow!].timeTableRows.count - 1].stationShortCode}){
                RouteDetailViewController.title = stations[filteredFirstStation].stationName + " - " + stations[filteredLastStation].stationName
            }
        }
    }
}
