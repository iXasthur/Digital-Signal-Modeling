//
//  SignalChartEx.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 26.10.2021.
//

import SwiftUI

fileprivate struct SpectrumSheetBody: View {
    private let fourierDataDFT: FourierData
    private let fourierDataFFT: FourierData
    
    init(signal: BaseSignal, count: Int) {
        fourierDataDFT = FourierDataDFT(signalValues: signal.getValues(count))
        fourierDataFFT = FourierDataFFT(signalValues: signal.getValues(count))
    }
    
    var body: some View {
        HStack {
            VStack {
                Text("DFT")
                    .font(.headline)
                    .padding(.top, 10)
                
                Divider()
                
                ChartLineView(values: fourierDataDFT.getAmplitudeSpectrum(), title: "Amplitude Spectrum", compact: true)
                    .padding(.top, 10)
                
                ChartLineView(values: fourierDataDFT.getPhaseSpectrum(), title: "Phase Spectrum", compact: true)
                    .padding(.top, 10)
                
                ChartLineView(values: fourierDataDFT.getRestoredSignal(), title: "Restored Signal", compact: true)
                    .padding(.top, 10)
                
                ChartLineView(values: fourierDataDFT.getRestoredSignalIgnoringPhase(), title: "Restored Signal (w/o phase)", compact: true)
                    .padding(.top, 10)
            }
            
            Spacer(minLength: 15)
            
            VStack {
                Text("FFT")
                    .font(.headline)
                    .padding(.top, 10)
                    
                Divider()
                
                ChartLineView(values: fourierDataFFT.getAmplitudeSpectrum(), title: "Amplitude Spectrum", compact: true)
                    .padding(.top, 10)
                
                ChartLineView(values: fourierDataFFT.getPhaseSpectrum(), title: "Phase Spectrum", compact: true)
                    .padding(.top, 10)
                
                ChartLineView(values: fourierDataFFT.getRestoredSignal(), title: "Restored Signal", compact: true)
                    .padding(.top, 10)
                
                ChartLineView(values: fourierDataFFT.getRestoredSignalIgnoringPhase(), title: "Restored Signal (w/o phase)", compact: true)
                    .padding(.top, 10)
            }
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
                    onAccept: {},
                    idealWidth: 800,
                    idealHeight: 500
                )
            }
    }
}
