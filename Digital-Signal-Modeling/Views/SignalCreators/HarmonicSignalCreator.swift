//
//  HarmonicSignalCreator.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

struct HarmonicSignalCreator: View {
    
    static let minParamLabelWidth: CGFloat = 72
    static let defaultAmplitude: Double = 1
    static let defaultStartPhase: Double = 0
    static let defaultFrequency: Double = 1
    static let defaultDutyPercentage: Double = 0.5
    
    @State private var amplitude: Double
    @State private var startPhase: Double
    @State private var frequency: Double
    @State private var dutyPercentage: Double
    
    @State private var selectedSignalType: SignalType
    
    @Binding var signal: HarmonicSignal
    
    init(signal: Binding<HarmonicSignal>) {
        self._signal = signal
        
        if _signal.wrappedValue.type != .def {
            selectedSignalType = _signal.wrappedValue.type
            amplitude = _signal.wrappedValue.amplitude ?? HarmonicSignalCreator.defaultAmplitude
            startPhase = _signal.wrappedValue.startPhase ?? HarmonicSignalCreator.defaultStartPhase
            frequency = _signal.wrappedValue.frequency ?? HarmonicSignalCreator.defaultFrequency
            
            if _signal.wrappedValue.duty != nil {
                dutyPercentage = _signal.wrappedValue.duty! / (2 * Double.pi)
            } else {
                dutyPercentage = HarmonicSignalCreator.defaultDutyPercentage
            }
        } else {
            amplitude = HarmonicSignalCreator.defaultAmplitude
            startPhase = HarmonicSignalCreator.defaultStartPhase
            frequency = HarmonicSignalCreator.defaultFrequency
            dutyPercentage = HarmonicSignalCreator.defaultDutyPercentage
            
            selectedSignalType = SignalType.sine
        }
    }
    
    func shouldDisableAmplitude() -> Bool {
        return false
    }
    
    func shouldDisablePhase() -> Bool {
        return selectedSignalType == .noise
    }
    
    func shouldDisableFrequency() -> Bool {
        return selectedSignalType == .noise
    }
    
    func shouldDisableDuty() -> Bool {
        return selectedSignalType != .impulse
    }
    
    func updateSignal() {
        switch selectedSignalType {
        case .sine:
            signal = HarmonicSignal.createSine(amplitude: amplitude, startPhase: startPhase, frequency: frequency)
        case .impulse:
            signal = HarmonicSignal.createImpulse(amplitude: amplitude, startPhase: startPhase, frequency: frequency, duty: dutyPercentage)
        case .triangle:
            signal = HarmonicSignal.createTriangle(amplitude: amplitude, startPhase: startPhase, frequency: frequency)
        case .saw:
            signal = HarmonicSignal.createSaw(amplitude: amplitude, startPhase: startPhase, frequency: frequency)
        case .noise:
            signal = HarmonicSignal.createNoise(amplitude: amplitude)
        case .def:
            fatalError()
            break
        }
    }
    
    var body: some View {
        VStack {
            Picker("Signal type", selection: $selectedSignalType) {
                ForEach(SignalType.allCases.filter({ t in
                    t != .def
                })) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedSignalType) { _ in
                updateSignal()
            }
            
            VStack {
                HStack {
                    Text("Amplitude")
                        .frame(minWidth: HarmonicSignalCreator.minParamLabelWidth, alignment: .leading)
                    Slider(value: $amplitude, in: 0...10)
                        .onChange(of: amplitude) { _ in
                            updateSignal()
                        }
                    Text("\(amplitude, specifier: "%.1f")")
                        .onTapGesture {
                            amplitude = HarmonicSignalCreator.defaultAmplitude
                        }
                }
                .disabled(shouldDisableAmplitude())
                .foregroundColor(shouldDisableAmplitude() ? Color.secondary.opacity(0.5) : Color.primary)
                
                HStack {
                    Text("Frequency")
                        .frame(minWidth: HarmonicSignalCreator.minParamLabelWidth, alignment: .leading)
                    Slider(value: $frequency, in: 0...32)
                        .onChange(of: frequency) { _ in
                            updateSignal()
                        }
                    Text("\(frequency, specifier: "%.1f")")
                        .onTapGesture {
                            frequency = HarmonicSignalCreator.defaultFrequency
                        }
                }
                .disabled(shouldDisableFrequency())
                .foregroundColor(shouldDisableFrequency() ? Color.secondary.opacity(0.5) : Color.primary)
                
                HStack {
                    Text("Phase")
                        .frame(minWidth: HarmonicSignalCreator.minParamLabelWidth, alignment: .leading)
                    Slider(value: $startPhase, in: 0...2*Double.pi*2)
                        .onChange(of: startPhase) { _ in
                            updateSignal()
                        }
                    Text("\(startPhase, specifier: "%.1f")")
                        .onTapGesture {
                            startPhase = HarmonicSignalCreator.defaultStartPhase
                        }
                }
                .disabled(shouldDisablePhase())
                .foregroundColor(shouldDisablePhase() ? Color.secondary.opacity(0.5) : Color.primary)
                
                HStack {
                    Text("Duty")
                        .frame(minWidth: HarmonicSignalCreator.minParamLabelWidth, alignment: .leading)
                    Slider(value: $dutyPercentage, in: 0...1)
                        .onChange(of: dutyPercentage) { _ in
                            updateSignal()
                        }
                    Text("\(dutyPercentage, specifier: "%.1f")")
                        .onTapGesture {
                            dutyPercentage = HarmonicSignalCreator.defaultDutyPercentage
                        }
                }
                .disabled(shouldDisableDuty())
                .foregroundColor(shouldDisableDuty() ? Color.secondary.opacity(0.5) : Color.primary)
            }
        }
        .onAppear {
            updateSignal()
        }
    }
}
