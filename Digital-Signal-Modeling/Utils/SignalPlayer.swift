//
//  SignalPlayer.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 25.09.2021.
//

import AppKit
import AVFoundation

class SignalPlayer {
    
    let sampleRate = 44100
    
    let signal: Signal
    
    let audioEngine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()
    
    var prepared = false
    
    init(signal: Signal) {
        self.signal = signal
    }
    
    func prepare() {
        let fvalues: [Float] = signal.getValuesF(sampleRate)
        
        let mainMixer = audioEngine.mainMixerNode
        let output = audioEngine.outputNode
        let layout = AVAudioChannelLayout(layoutTag: kAudioChannelLayoutTag_Mono)!
        let outputFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: Double(sampleRate), interleaved: false, channelLayout: layout)
        // Use output format for input but reduce channel count to 1
        let inputFormat = AVAudioFormat(commonFormat: outputFormat.commonFormat,
                                        sampleRate: outputFormat.sampleRate,
                                        channels: 1,
                                        interleaved: outputFormat.isInterleaved)

        audioEngine.attach(playerNode)

        audioEngine.connect(playerNode, to: mainMixer, format: inputFormat)
        audioEngine.connect(mainMixer, to: output, format: outputFormat)
        
        let buffer: AVAudioPCMBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: AVAudioFrameCount(fvalues.count))!
        buffer.frameLength = buffer.frameCapacity
        
        fvalues.withUnsafeBufferPointer { p in
            buffer.floatChannelData!.pointee.assign(from: p.baseAddress!, count: fvalues.count)
        }
        
        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        
        do {
            try audioEngine.start()
        } catch {
            print("Could not start engine: \(error)")
        }
        
        prepared = true
    }
    
    func play() {
        if !prepared {
            prepare()
        }
        
        playerNode.play()
    }
    
    func stop() {
        playerNode.pause()
    }
    
    func save() {
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "signal.wav"
        savePanel.directoryURL = URL(string: (NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true) as [String]).first!)
        savePanel.showsTagField = false
        savePanel.begin { (result) in
            if result == .OK {
                let file = savePanel.url!
                
                if let format = AVAudioFormat(
                    commonFormat: .pcmFormatFloat32,
                    sampleRate: Double(self.sampleRate),
                    channels: 1,
                    interleaved: false
                ) {
                    let fvalues: [Float] = self.signal.getValuesF(self.sampleRate)
                    
                    let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(fvalues.count))!
                    buffer.frameLength = buffer.frameCapacity
                    
                    fvalues.withUnsafeBufferPointer { p in
                        buffer.floatChannelData!.pointee.assign(from: p.baseAddress!, count: fvalues.count)
                    }
                    
                    do {
                        let audioFile = try AVAudioFile(forWriting: file, settings: format.settings)
                        try audioFile.write(from: buffer)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
