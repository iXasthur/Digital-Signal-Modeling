//
//  SignalPlayer.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 25.09.2021.
//

import Foundation
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
        var fvalues: [Float] = []
        signal.getValues(sampleRate).forEach { v in
            fvalues.append(Float(v))
        }
        
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

        mainMixer.outputVolume = 0.5
        
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
    
}
