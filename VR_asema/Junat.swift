//
//  Junat.swift
//  VR_asema
//
//  Created by Matti Saarela on 07/02/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import UIKit

// Tietotyyppi aikataulutaulukkoa varten
struct RouteRow {
    var station: String
    var arrivalTime: Date?
    var departingTime: Date?
    var cancelled: Bool
}

// TimeTableRows- tietotyyppi
struct TimeTableRow: Codable {  // Info Kuvaa saapumisia ja lähtöjä liikennepaikoilta. Järjestetty reitin mukaiseen järjestykseen.
    let trainStopping: Bool // true,false Info Pysähtyykö juna liikennepaikalla
    let stationShortCode: String // Info Aseman lyhennekoodi
    let stationUICCode: NSInteger // 1-9999 Info Aseman UIC-koodi
    let countryCode: String // “FI”, “RU”
    let type: String // “ARRIVAL” tai “DEPARTURE” Info Pysähdyksen tyyppi
    let commercialStop: Bool? // boolean Info Onko pysähdys kaupallinen. Annettu vain pysähdyksille, ei läpiajoille. Mikäli junalla on osaväliperumisia, saattaa viimeinen perumista edeltävä pysähdys jäädä virheellisesti ei-kaupalliseksi.
    let commercialTrack: String? // Info Suunniteltu raidenumero, jolla juna pysähtyy tai jolta se lähtee. Raidenumeroa ei saada junille, joiden lähtöön on vielä yli 10 päivää. Operatiivisissa häiriötilanteissa raide voi olla muu.
    let cancelled: Bool // true/false Info Totta, jos lähtö tai saapuminen on peruttu
    let scheduledTime: Date // datetime Info Aikataulun mukainen pysähtymis- tai lähtöaika
    let liveEstimateTime: Date? // Info Ennuste. Tyhjä jos juna ei ole matkalla
    let estimateSource: String? // datetime Info Ennusteen lähde. Lisätietoa lähteistä täältä.
    let actualTime: Date? // datetime Info Aika jolloin juna saapui tai lähti asemalta
    let differenceInMinutes: Int? // integer Info Vertaa aikataulun mukaista aikaa ennusteeseen tai toteutuneeseen aikaan ja kertoo erotuksen minuutteina

    
    struct causes: Codable {// Info Syytiedot. Kuvaavat syitä miksi juna oli myöhässä tai etuajassa pysähdyksellä. Kaikkia syyluokkia ja -tietoja ei julkaista.
        let categoryCodeId: String // Info Yleisen syyluokan yksilöivä tunnus. Lista syyluokista löytyy osoitteesta metadata/cause-category-codes
        let categoryCode: String // Info Yleisen syyluokan koodi. Huom. ei yksilöivä.
        let detailedCategoryCodeId: String? // Info Tarkemman syykoodin yksilöivä tunnus. Lista syykoodeista löytyy osoitteesta täältä
        let detailedCategoryCode: String? // Info Tarkempi syykoodin koodi. Huom. ei yksilöivä
        let thirdCategoryCodeId: String? // Info Kolmannen tason syykoodin tunnus.
        let thirdCategoryCode: String? // Info Kolmannen tason syykoodin koodi. Huom. ei yksilöivä
        
       
    }
    
    struct trainReady: Codable {   // Info Junan lähtövalmius. Operaattorin tulee tehdä lähtövalmiusilmoitus liikenteenohjaajalle aina kun junan kokoonpanovaihtuu tai se lähtee ensimmäiseltä pysäkiltään.
        let source: String? // Info Tapa, jolla lähtövalmiusilmoitus on tehty.
        let accepted: Bool? // Info Onko lähtövalmiusilmoitus hyväksytty.
        let timestamp: String? // Info Aika jolloin lähtövalmiusilmoitus on päätetty.
    }
 
}


//Junat -tietotyyppi
struct Junat: Codable {
    
    let trainNumber : NSInteger // 1-99999 Info Junan numero. Esim junan “IC 59” junanumero on 59
    let departureDate: Date //  date Info Junan ensimmäisen lähdön päivämäärä
    let operatorUICCode: NSInteger // 1-9999 Info Junan operoiman operaattorin UIC-koodi
    let operatorShortCode: String  //vr-track, destia, … Info Lista operaattoreista löytyy täältä.
    let trainType: String // IC, P, S, …
    let trainCategory: String // lähiliikenne, kaukoliikenne, tavaraliikenne, …
    let commuterLineID: String? //Z, K, N….
    let runningCurrently: Bool //  true/false Info Onko juna tällä hetkellä kulussa
    let cancelled: Bool // true/false Info Totta, jos junan peruminen on tehty 10 vuorokauden sisällä. Yli 10 vuorokautta sitten peruttuja junia ei palauteta rajapinnassa laisinkaan.
    let version: Int // positive integer Info Versionumero, jossa juna on viimeksi muuttunut
    let timetableType: String // REGULAR tai ADHOC. Info Kertoo onko junan aikataulu haettu säännöllisenä (REGULAR) vai kiireellisenä yksittäistä päivää koskevana (ADHOC).
    let timetableAcceptanceDate: Date // datetime. Info Ajanhetki jolloin viranomainen on hyväksynyt junan aikataulun.
    let deleted: Bool? // true,false Info Vain /trains/version -rajapinnassa käytetty attribuutti, joka kertoo onko juna poistettu eli peruttu yli kymmenen päivää ennen lähtöä.
    var timeTableRows: [TimeTableRow]
    
   
}
// Asema -tietotyyppi
struct Station: Codable {
    let passengerTraffic: Bool // Info Onko liikennepaikalla kaupallista matkustajaliikennettä
    let countryCode: String // Info Liikennepaikan maatunnus
    let stationName: String // Info Liikennepaikan nimi
    let stationShortCode: String // Info Liikennepaikan lyhenne
    let stationUICCode: NSInteger // 1-9999 Info Liikennepaikan maakohtainen UIC-koodi
    let latitude: Double // Info Liikennepaikan latitude “WGS 84”-muodossa
    let longitude: Double // Info Liikennepaikan longitudi “WGS 84”-muodossa
    let type: String // Info Liikennepaikan tyyppi. STATION = asema, STOPPING_POINT = seisake, TURNOUT_IN_THE_OPEN_LINE = linjavaihde

}

