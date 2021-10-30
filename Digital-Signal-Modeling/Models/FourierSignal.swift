//
//  FourierSignal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 28.10.2021.
//

import Foundation

protocol FourierSignal {
    func getFourierData() -> FourierData
//    func getSinAmplitudeSpectre(signalValuesCount: Int) -> SignalSpectre
//    func getCosAmplitudeSpectre(signalValuesCount: Int) -> SignalSpectre
}

extension FourierSignal {
//    func getAmplitudeSpectre(signalValuesCount: Int) -> SignalSpectre {
//        let s = getSinAmplitudeSpectre(signalValuesCount: signalValuesCount);
//        let c = getCosAmplitudeSpectre(signalValuesCount: signalValuesCount);
//
//        var spectreValues: [Double] = []
//        for i in 0..<s.values.count {
//            spectreValues.append(sqrt(pow(s.values[i], 2) + pow(c.values[i], 2)))
//        }
//
//        return SignalSpectre(values: spectreValues)
//    }
//
//    func getPhaseSpectre(signalValuesCount: Int) -> SignalSpectre {
//        let s = getSinAmplitudeSpectre(signalValuesCount: signalValuesCount);
//        let c = getCosAmplitudeSpectre(signalValuesCount: signalValuesCount);
//
//        var spectreValues: [Double] = []
//        for i in 0..<s.values.count {
//            spectreValues.append(atan(s.values[i] / c.values[i]))
//        }
//
//        return SignalSpectre(values: spectreValues)
//    }
}
