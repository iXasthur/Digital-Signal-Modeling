//
//  SignalChartEx.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 26.10.2021.
//

import SwiftUI

fileprivate struct FilteredSheetBody: View {
    static private let minLeadingParamLabelWidth: CGFloat = 52
    static private let minTrailingParamLabelWidth: CGFloat = 62
    
    private let count: Int
    
    @State private var signal: FilteredSignal
    
    init(signal: BaseSignal, count: Int) {
        self.count = count
        self._signal = State(initialValue: FilteredSignal(signal: signal))
    }
    
    var body: some View {
        VStack {
            SignalChartEx(signal: signal, title: "Filtered", disableSound: true, count: count)
                .padding(.top, 10)
            
            HStack {
                Text("L Bound")
                    .frame(minWidth: FilteredSheetBody.minLeadingParamLabelWidth, alignment: .leading)
                Slider(value: $signal.leftBound, in: 0...440)
                Text("\(signal.leftBound, specifier: "%.1f") Hz")
                    .onTapGesture {
                        signal.leftBound = 0
                    }
                    .frame(minWidth: FilteredSheetBody.minTrailingParamLabelWidth, alignment: .leading)
            }
            
            HStack {
                Text("R Bound")
                    .frame(minWidth: FilteredSheetBody.minLeadingParamLabelWidth, alignment: .leading)
                Slider(value: $signal.rightBound, in: 0...440)
                Text("\(signal.rightBound, specifier: "%.1f") Hz")
                    .onTapGesture {
                        signal.rightBound = 440
                    }
                    .frame(minWidth: FilteredSheetBody.minTrailingParamLabelWidth, alignment: .leading)
            }
        }
    }
}

fileprivate struct SpectrumSheetBody: View {
    private let count: Int
    
    private let fourierDataDFT: FourierData
    private let fourierDataFFT: FourierData
    
    init(signal: BaseSignal, count: Int) {
        self.count = count
        
        self.fourierDataDFT = FourierDataDFT(signalValues: signal.getValues(count))
        self.fourierDataFFT = FourierDataFFT(signalValues: signal.getValues(count))
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
    #if DEBUG
    private let fourierDataValuesCount = 256
    private let filteredDataValuesCount = 256
    #else
    private let fourierDataValuesCount = 4096
    private let filteredDataValuesCount = 4096
    #endif
    
    let count: Int
    let signal: BaseSignal
    let title: String?
    let compact: Bool
    let hideLabels: Bool
    let additionalButtons: [[HoldableButton]]
    let disableSound: Bool
    
    private let player: SignalPlayer
    
    @State private var isSpectrumSheetShown = false
    @State private var isFilteredSheetShown = false
    
    init(signal: BaseSignal, title: String?, compact: Bool = false, hideLabels: Bool = false, additionalButtons: [[HoldableButton]] = [], disableSound: Bool = false, count: Int = 4096) {
        self.count = count
        self.signal = signal
        self.title = title
        self.disableSound = disableSound
        self.compact = compact
        self.hideLabels = hideLabels
        self.additionalButtons = additionalButtons
        self.player = SignalPlayer(signal: signal)
    }
    
    var buttons: [HoldableButton] {
        var b: [HoldableButton] = []
        
        if !disableSound {
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
        }
        
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
                icon0: "sun.max",
                icon1: "sun.max.fill",
                onTap: {
                    
                }, onRelease: {
                    isFilteredSheetShown.toggle()
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
    
    var buttonsF: [[HoldableButton]] {
        var b = [buttons]
        additionalButtons.forEach { ab in
            b.append(ab)
        }
        return b
    }
    
    var body: some View {
        SignalChart(signal: signal, title: title, compact: compact, hideLabels: hideLabels, buttons: buttonsF, count: count)
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
            .sheet(isPresented: $isFilteredSheetShown) {
                SheetView(
                    isPresented: $isFilteredSheetShown,
                    title: "Filtered (\(filteredDataValuesCount))",
                    view: AnyView(FilteredSheetBody(signal: signal, count: filteredDataValuesCount)),
                    onCancel: nil,
                    onAccept: {},
                    idealWidth: nil,
                    idealHeight: nil
                )
            }
    }
}
