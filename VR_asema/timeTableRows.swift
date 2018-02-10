//
//  timeTableRows.swift
//  VR_asema
//
//  Created by Matti Saarela on 07/02/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import UIKit

class Causes: Codable {
    let categoryCodeId: String // Info Yleisen syyluokan yksilöivä tunnus. Lista syyluokista löytyy osoitteesta metadata/cause-category-codes
    let categoryCode: String // Info Yleisen syyluokan koodi. Huom. ei yksilöivä.
    let detailedCategoryCodeId: String? // Info Tarkemman syykoodin yksilöivä tunnus. Lista syykoodeista löytyy osoitteesta täältä
    let detailedCategoryCode: String? // Info Tarkempi syykoodin koodi. Huom. ei yksilöivä
    let thirdCategoryCodeId: String? // Info Kolmannen tason syykoodin tunnus.
    let thirdCategoryCode: String? // Info Kolmannen tason syykoodin koodi. Huom. ei yksilöivä
    
    init (categoryCodeId: String, categoryCode: String, detailedCategoryCodeId: String?, detailedCategoryCode: String?, thirdCategoryCodeId: String?, thirdCategoryCode: String? ){
        self.categoryCodeId = categoryCodeId
        self.categoryCode = categoryCode
        self.detailedCategoryCodeId = detailedCategoryCodeId
        self.detailedCategoryCode = detailedCategoryCode
        self.thirdCategoryCodeId = thirdCategoryCodeId
        self.thirdCategoryCode = thirdCategoryCode
    }
    
}

class TrainReady: Codable {
    let source: String // Info Tapa, jolla lähtövalmiusilmoitus on tehty.
    let accepted: Bool // Info Onko lähtövalmiusilmoitus hyväksytty.
    let timestamp: String // Info Aika jolloin lähtövalmiusilmoitus on päätetty.
    
    init(source: String,accepted: Bool,timestamp: String){
        self.source = source
        self.accepted = accepted
        self.timestamp = timestamp
    }

}


class TimeTableRows: Codable {
    let trainStopping: String // true,false Info Pysähtyykö juna liikennepaikalla
    let stationShortCode: String // Info Aseman lyhennekoodi
    let stationUICCode: NSInteger // 1-9999 Info Aseman UIC-koodi
    let countryCode: String // “FI”, “RU”
    let type: String // “ARRIVAL” tai “DEPARTURE” Info Pysähdyksen tyyppi
    let commercialStop: String? // boolean Info Onko pysähdys kaupallinen. Annettu vain pysähdyksille, ei läpiajoille. Mikäli junalla on osaväliperumisia, saattaa viimeinen perumista edeltävä pysähdys jäädä virheellisesti ei-kaupalliseksi.
    let commercialTrack: String? // Info Suunniteltu raidenumero, jolla juna pysähtyy tai jolta se lähtee. Raidenumeroa ei saada junille, joiden lähtöön on vielä yli 10 päivää. Operatiivisissa häiriötilanteissa raide voi olla muu.
    let cancelled: Bool // true/false Info Totta, jos lähtö tai saapuminen on peruttu
    let scheduledTime: String // datetime Info Aikataulun mukainen pysähtymis- tai lähtöaika
    let liveEstimateTime: String? // Info Ennuste. Tyhjä jos juna ei ole matkalla
    let estimateSource: String? // datetime Info Ennusteen lähde. Lisätietoa lähteistä täältä.
    let actualTime: String? // datetime Info Aika jolloin juna saapui tai lähti asemalta
    let differenceInMinutes: Int? // integer Info Vertaa aikataulun mukaista aikaa ennusteeseen tai toteutuneeseen aikaan ja kertoo erotuksen minuutteina

    let causes: [Causes] // Info Syytiedot. Kuvaavat syitä miksi juna oli myöhässä tai etuajassa pysähdyksellä. Kaikkia syyluokkia ja -tietoja ei julkaista.
    let trainReady: TrainReady?   // Info Junan lähtövalmius. Operaattorin tulee tehdä lähtövalmiusilmoitus liikenteenohjaajalle aina kun junan kokoonpanovaihtuu tai se lähtee ensimmäiseltä pysäkiltään.

 
    
    init (trainStopping: String, stationShortCode: String, stationUICCode: NSInteger, countryCode: String, type: String, commercialStop: String?, commercialTrack: String?, cancelled: Bool, scheduledTime: String, liveEstimateTime: String?, estimateSource: String?, actualTime: String?, differenceInMinutes: Int?, causes: [Causes], trainReady: TrainReady? ){
        self.trainStopping = trainStopping
        self.stationShortCode = stationShortCode
        self.stationUICCode = stationUICCode
        self.countryCode = countryCode
        self.type = type
        self.commercialStop = commercialStop
        self.commercialTrack = commercialTrack
        self.cancelled = cancelled
        self.scheduledTime = scheduledTime
        self.liveEstimateTime = liveEstimateTime
        self.estimateSource = estimateSource
        self.actualTime = actualTime
        self.differenceInMinutes = differenceInMinutes
        self.causes = causes
        self.trainReady = trainReady
    }

    
}

