//
//  ViewController.swift
//  CIAudioProblemRepro
//
//  Created by Ariel Elkin on 07/06/2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let engine = AVAudioEngine()
    let player = AVAudioPlayerNode()

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = Bundle.main.url(forResource: "audiofile", withExtension: "wav")!

        let file = try! AVAudioFile(forReading: url)

        let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: UInt32(file.length))!
        try! file.read(into: buffer)

        let effectNode = AVAudioUnitReverb()

        engine.attach(player)
        engine.attach(effectNode)

        engine.connect(player, to: effectNode, format: file.processingFormat)
        engine.connect(effectNode, to: engine.mainMixerNode, format: file.processingFormat)

        player.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)

        try! engine.start()
        player.play()
    }
}
