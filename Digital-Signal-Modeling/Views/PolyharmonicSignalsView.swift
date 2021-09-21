//
//  PolyharmonicSignalsView.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

struct PolyharmonicSignalsView: View {
    @State private var isSinChecked = true
    @State private var isImpulseChecked = false
    @State private var isTriangleChecked = false
    @State private var isSawChecked = false
    @State private var isNoiseChecked = false
    
    @State private var signal: HarmonicSignal = HarmonicSignal.createDefault()
    
    func updateSignal() {
        print("Updating signal")
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Toggle(isOn: $isSinChecked) {
                    Text("Sin")
                }
                .onChange(of: isSinChecked) { value in
                    updateSignal()
                }

                Toggle(isOn: $isImpulseChecked) {
                    Text("Impulse")
                }
                .onChange(of: isImpulseChecked) { value in
                    updateSignal()
                }


                Toggle(isOn: $isTriangleChecked) {
                    Text("Triangle")
                }
                .onChange(of: isTriangleChecked) { value in
                    updateSignal()
                }

                Toggle(isOn: $isSawChecked) {
                    Text("Saw")
                }
                .onChange(of: isSawChecked) { value in
                    updateSignal()
                }

                Toggle(isOn: $isNoiseChecked) {
                    Text("Noise")
                }
                .onChange(of: isNoiseChecked) { value in
                    updateSignal()
                }

                Spacer()
            }
            .toggleStyle(CheckboxToggleStyle())
            .frame(maxHeight: .infinity)
            .padding()

            SignalChart(signal: signal)
                .frame(maxWidth: .infinity)
                .padding()
        }
    }
}
