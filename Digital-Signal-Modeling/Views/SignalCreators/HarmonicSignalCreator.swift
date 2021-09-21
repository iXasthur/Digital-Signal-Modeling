//
//  HarmonicSignalCreator.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

fileprivate enum SignalType: String, CaseIterable, Identifiable {
    case sine
    case impulse
    case triangle
    case saw
    case noise

    var id: String { self.rawValue }
}

struct HarmonicSignalCreator: View {
    
    static let minParamLabelWidth: CGFloat = 72
    static let defaultAmplitude: Double = 1
    static let defaultStartPhase: Double = 0
    static let defaultFrequency: Double = 1
    static let defaultDutyPercentage: Double = 0.5
    
    @State private var amplitude: Double = defaultAmplitude
    @State private var startPhase: Double = defaultStartPhase
    @State private var frequency: Double = defaultFrequency
    @State private var dutyPercentage: Double = defaultDutyPercentage
    
    @State private var selectedSignalType = SignalType.sine
    
    @Binding var signal: HarmonicSignal
    
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
        print("Updating harmonic signal")
        
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
        }
    }
    
    var body: some View {
        VStack {
            Picker("Signal Type", selection: $selectedSignalType) {
                ForEach(SignalType.allCases) { type in
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
                    Slider(value: $frequency, in: 0...10)
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
                    Slider(value: $startPhase, in: 0...Double.pi*2)
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
