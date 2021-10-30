//
//  SignalChartEx.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 26.10.2021.
//

import SwiftUI

fileprivate struct SpectrumSheetBody: View {
    private let fourierData: FourierData
    
    init(signal: BaseSignal, count: Int) {
        fourierData = FourierData(signalValues: signal.getValues(count))
    }
    
    var amplitudeValues: [Double] {
        return fourierData.getAmplitudeSpectrum()
    }
    
    var phaseValues: [Double] {
        return fourierData.getPhaseSpectrum()
    }
    
    var restoredSignalValues: [Double] {
        return fourierData.getRestoredSignal()
    }
    
    var restoredSignalValuesIgnoringPhase: [Double] {
        return fourierData.getRestoredSignalIgnoringPhase()
    }
    
    var body: some View {
        VStack {
            ChartLineView(values: amplitudeValues, title: "Amplitude Spectrum", compact: true)
                .padding(.top, 10)
            
            ChartLineView(values: phaseValues, title: "Phase Spectrum", compact: true)
                .padding(.top, 10)
            
            ChartLineView(values: restoredSignalValues, title: "Restored Signal", compact: true)
                .padding(.top, 10)
            
            ChartLineView(values: restoredSignalValuesIgnoringPhase, title: "Restored Signal (w/o phase)", compact: true)
                .padding(.top, 10)
        }
    }
}

struct SignalChartEx: View {
    private let fourierDataValuesCount = 256
    
    let signal: BaseSignal
    let title: String?
    let compact: Bool
    
    private let player: SignalPlayer
    
    @State private var isSpectrumSheetShown = false
    
    init(signal: BaseSignal, title: String?, compact: Bool = false) {
        self.signal = signal
        self.title = title
        self.compact = compact
        self.player = SignalPlayer(signal: signal)
    }
    
    var buttons: [HoldableButton] {
        var b: [HoldableButton] = []
        
        b.append(
            HoldableButton(
                icon0: "play",
                icon1: "play.fill",
                onTap: {
                    player.play()
                },
                onRelease: {
                    player.stop()
                })
        )
        
        b.append(
            HoldableButton(
                icon0: "square.stack.3d.up",
                icon1: "square.stack.3d.up.fill",
                onTap: {
                    
                }, onRelease: {
                    isSpectrumSheetShown.toggle()
                })
        )
        
        b.append(
            HoldableButton(
                icon0: "square.and.arrow.up",
                icon1: "square.and.arrow.up.fill",
                onTap: {
                    
                },
                onRelease: {
                    player.save()
                })
        )
        
        return b
    }
    
    var body: some View {
        SignalChart(signal: signal, title: title, compact: compact, buttons: buttons)
            .sheet(isPresented: $isSpectrumSheetShown) {
                SheetView(
                    isPresented: $isSpectrumSheetShown,
                    title: "Fourier Data (\(fourierDataValuesCount))",
                    view: AnyView(SpectrumSheetBody(signal: signal, count: fourierDataValuesCount)),
                    onCancel: nil,
                    onAccept: {}
                )
            }
    }
}
