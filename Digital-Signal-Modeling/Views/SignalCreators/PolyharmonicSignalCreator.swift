//
//  PolyharmonicSignalCreator.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

fileprivate struct SheetView: View {
    @Binding var isPresented: Bool
    @Binding var signal: PolyharmonicSignal
    
    @State private var harmonicSignal: HarmonicSignal = HarmonicSignal.createDefault()

    var body: some View {
        VStack {
            HStack {
                Button {
                    isPresented.toggle()
                    NSApp.mainWindow?.endSheet(NSApp.keyWindow!)
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(width: 20, height: 20, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()
                
                Text("Add signal")
                    .font(.headline)
                
                Spacer()
               
                Button {
                    signal.signals.append(harmonicSignal)
                    isPresented.toggle()
                    NSApp.mainWindow?.endSheet(NSApp.keyWindow!)
                } label: {
                    Image(systemName: "checkmark")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .frame(width: 20, height: 20, alignment: .trailing)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Divider()
            
            HarmonicSignalCreator(signal: $harmonicSignal)
                .padding(.top, 10)
            
            SignalChart(signal: harmonicSignal)
                .padding(.top, 10)
            
        }
        .padding()
        .frame(minWidth: 500)
    }
}

struct PolyharmonicSignalCreator: View {
    
    @State private var showingSheet = false
    
    @Binding var signal: PolyharmonicSignal
    
    var body: some View {
        Button {
            showingSheet.toggle()
        } label: {
            Text("+")
        }
        .sheet(isPresented: $showingSheet) {
            SheetView(isPresented: $showingSheet, signal: $signal)
        }
    }
}
