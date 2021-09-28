//
//  SingleVoiceSignalCreator.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

struct SingleVoiceSignalCreator: View {
    
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
    
    @Binding var signal: SingleVoiceSignal
    
    let compact: Bool
    
    init(signal: Binding<SingleVoiceSignal>, compact: Bool = false) {
        self._signal = signal
        self.compact = compact
        
        if _signal.wrappedValue.type != .def {
            selectedSignalType = _signal.wrappedValue.type
            amplitude = _signal.wrappedValue.amplitude ?? SingleVoiceSignalCreator.defaultAmplitude
            startPhase = _signal.wrappedValue.startPhase ?? SingleVoiceSignalCreator.defaultStartPhase
            frequency = _signal.wrappedValue.frequency ?? SingleVoiceSignalCreator.defaultFrequency
            
            if _signal.wrappedValue.duty != nil {
                dutyPercentage = _signal.wrappedValue.duty! / (2 * Double.pi)
            } else {
                dutyPercentage = SingleVoiceSignalCreator.defaultDutyPercentage
            }
        } else {
            amplitude = SingleVoiceSignalCreator.defaultAmplitude
            startPhase = SingleVoiceSignalCreator.defaultStartPhase
            frequency = SingleVoiceSignalCreator.defaultFrequency
            dutyPercentage = SingleVoiceSignalCreator.defaultDutyPercentage
            
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
        return selectedSignalType != .pulse
    }
    
    func updateSignal() {
        switch selectedSignalType {
        case .sine:
            signal = SingleVoiceSignal.createSine(amplitude: amplitude, startPhase: startPhase, frequency: frequency)
        case .pulse:
            signal = SingleVoiceSignal.createImpulse(amplitude: amplitude, startPhase: startPhase, frequency: frequency, duty: dutyPercentage)
        case .triangle:
            signal = SingleVoiceSignal.createTriangle(amplitude: amplitude, startPhase: startPhase, frequency: frequency)
        case .saw:
            signal = SingleVoiceSignal.createSaw(amplitude: amplitude, startPhase: startPhase, frequency: frequency)
        case .noise:
            signal = SingleVoiceSignal.createNoise(amplitude: amplitude)
        case .def:
            fatalError()
            break
        }
    }
    
    var amplitudeSlider: some View {
        HStack {
            Text("Amplitude")
                .frame(minWidth: SingleVoiceSignalCreator.minParamLabelWidth, alignment: .leading)
            Slider(value: $amplitude, in: 0...10)
                .onChange(of: amplitude) { _ in
                    updateSignal()
                }
            Text("\(amplitude, specifier: "%.1f")")
                .onTapGesture {
                    amplitude = SingleVoiceSignalCreator.defaultAmplitude
                }
        }
        .disabled(shouldDisableAmplitude())
        .foregroundColor(shouldDisableAmplitude() ? Color.secondary.opacity(0.5) : Color.primary)
    }
    
    var frequencySlider: some View {
        HStack {
            Text("Frequency")
                .frame(minWidth: SingleVoiceSignalCreator.minParamLabelWidth, alignment: .leading)
            Slider(value: $frequency, in: 0...440)
                .onChange(of: frequency) { _ in
                    self.frequency.round()
                    updateSignal()
                }
            Text("\(frequency, specifier: "%.1f")")
                .onTapGesture {
                    frequency = SingleVoiceSignalCreator.defaultFrequency
                }
        }
        .disabled(shouldDisableFrequency())
        .foregroundColor(shouldDisableFrequency() ? Color.secondary.opacity(0.5) : Color.primary)
    }
    
    var startPhaseSlider: some View {
        HStack {
            Text("Phase")
                .frame(minWidth: SingleVoiceSignalCreator.minParamLabelWidth, alignment: .leading)
            Slider(value: $startPhase, in: 0...2*Double.pi*2)
                .onChange(of: startPhase) { _ in
                    updateSignal()
                }
            Text("\(startPhase, specifier: "%.1f")")
                .onTapGesture {
                    startPhase = SingleVoiceSignalCreator.defaultStartPhase
                }
        }
        .disabled(shouldDisablePhase())
        .foregroundColor(shouldDisablePhase() ? Color.secondary.opacity(0.5) : Color.primary)
    }
    
    var dutySlider: some View {
        HStack {
            Text("Duty")
                .frame(minWidth: SingleVoiceSignalCreator.minParamLabelWidth, alignment: .leading)
            Slider(value: $dutyPercentage, in: 0...1)
                .onChange(of: dutyPercentage) { _ in
                    updateSignal()
                }
            Text("\(dutyPercentage, specifier: "%.1f")")
                .onTapGesture {
                    dutyPercentage = SingleVoiceSignalCreator.defaultDutyPercentage
                }
        }
        .disabled(shouldDisableDuty())
        .foregroundColor(shouldDisableDuty() ? Color.secondary.opacity(0.5) : Color.primary)
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
            
            
            if compact {
                HStack(spacing: 20) {
                    VStack {
                        amplitudeSlider
                        frequencySlider
                    }
                    VStack {
                        startPhaseSlider
                        dutySlider
                    }
                }
            } else {
                VStack(spacing: 4) {
                    amplitudeSlider
                    frequencySlider
                    startPhaseSlider
                    dutySlider
                }
            }
        }
        .onAppear {
            updateSignal()
        }
    }
}
