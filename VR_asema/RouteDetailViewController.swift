//
//  RouteDetailViewController.swift
//  VR_asema
//
//  Created by Matti Saarela on 09/02/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import UIKit

class RouteDetailViewController: UIViewController, UITableViewDataSource {
    
    //Toisesta näkymästä tulevat muuttujat
    var timeTableRaw = [TimeTableRow]() //Valitun aikataulun data
    var stations = [Station]() //asemataulukko asemien nimien esitykseen
    var navTitle: String? = nil //navBarin otsikko
    
    private static let fromDate: DateFormatter = {
        //Siistimpään päivämääräesitykseen tehdään oma dateformatter
        let fromDate = DateFormatter()
        fromDate.dateFormat = "HH:mm"
        return fromDate
    }()
    


    @IBOutlet weak var routeTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        if navTitle != nil {
            navigationItem.title = navTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTableRaw.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "routeProto") as? RouteTableViewCell
            else{return UITableViewCell()}
        
        //Jos aikaeroa aikatauluun verrattuna. Kerrotaan siitä käyttäjälle
        if let difference = timeTableRaw[indexPath.row].differenceInMinutes {
            if difference > 0 {
                cell.additional_label.text = String(difference) + " min myöhässä"
            }
            else if difference > 0 {
                cell.additional_label.text = String(difference * -1) + " min ajoissa"
            }
            else { cell.additional_label.text = "" }
        }
        else { cell.additional_label.text = "" }
        
        if timeTableRaw[indexPath.row].type == "DEPARTURE" {
            cell.time_label.isHidden = false
            cell.timetext_label.isHidden = false
            cell.timetext_label.text = "Lähtöaika:"
            //Oletusarvoisesti koetetaan löytää actualTime, mutta jos sitä ei ole niin liveEstimate ja viimeisenä vasta haetaan aikataulun mukainen aika scheduledTime
            if timeTableRaw[indexPath.row].actualTime != nil {
                cell.time_label.text = RouteDetailViewController.fromDate.string(from: timeTableRaw[indexPath.row].actualTime!)
            }
            else if timeTableRaw[indexPath.row].liveEstimateTime != nil {
                cell.time_label.text = RouteDetailViewController.fromDate.string(from: timeTableRaw[indexPath.row].liveEstimateTime!)
            }
            else {
                cell.time_label.text = RouteDetailViewController.fromDate.string(from: timeTableRaw[indexPath.row].scheduledTime)
            }
        }
            
        else if timeTableRaw[indexPath.row].type == "ARRIVAL" {
            cell.time_label.isHidden = false
            cell.timetext_label.isHidden = false
            cell.timetext_label.text = "Saapumisaika:"
            if timeTableRaw[indexPath.row].actualTime != nil {
                cell.time_label.text = RouteDetailViewController.fromDate.string(from: timeTableRaw[indexPath.row].actualTime!)
            }
            else if timeTableRaw[indexPath.row].liveEstimateTime != nil {
                cell.time_label.text = RouteDetailViewController.fromDate.string(from: timeTableRaw[indexPath.row].liveEstimateTime!)
            }
            else {
                cell.time_label.text = RouteDetailViewController.fromDate.string(from: timeTableRaw[indexPath.row].scheduledTime)
            }
        }
        else {
            cell.timetext_label.isHidden = true
            cell.time_label.isHidden = true
        }
        
        let stationIndex = stations.index(where:{ (station) -> Bool in
            station.stationShortCode == timeTableRaw[indexPath.row].stationShortCode
        })

        if stationIndex != nil {
        cell.station_label.text = stations[stationIndex!].stationName
        }
        
        return cell
    }

}
