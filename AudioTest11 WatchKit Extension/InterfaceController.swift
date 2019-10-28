//
//  InterfaceController.swift
//  AudioTest11 WatchKit Extension
//
//  Created by Peter Dubec on 28/10/2019.
//  Copyright © 2019 HealthMode. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation

class InterfaceController: WKInterfaceController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordBtn: WKInterfaceButton!
    @IBOutlet weak var infoLabel: WKInterfaceLabel!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var isRecordingRunning: Bool = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.configureAudioRecordingSession()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    private func getDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private func configureAudioRecordingSession() {
            print("configureAudioRecordingSession")
            recordingSession = AVAudioSession.sharedInstance()
            
            do {
                try recordingSession.setCategory(AVAudioSession.Category.playAndRecord)
                try recordingSession.setActive(true)
                print("Recording session activated")
            } catch {
                print("Couldn't set Audio session category or activate session. Error: \(error.localizedDescription)")
            }
            
    //        recordingSession.requestRecordPermission { [unowned self] (granted) in
    //            print("requestRecordPermission: \(granted)")
    //            if granted {
    //                do {
    //                    try self.recordingSession.setCategory(AVAudioSession.Category.playAndRecord)
    //                    try self.recordingSession.setActive(true)
    //                    print("Recording session activated")
    //                }
    //                catch {
    //                    print("Couldn't set Audio session category")
    //                }
    //            }
    //        }
    }
    
    private func startAudioRecording() {
        if audioRecorder == nil {
            let audioFileURL = getDirectory().appendingPathComponent("recording.m4a")
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 16000,
                AVEncoderBitDepthHintKey: 16,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
            ]
            
            // Start audio recording
            do {
                audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.prepareToRecord()
                audioRecorder.record()
                self.isRecordingRunning = true
                self.infoLabel.setText("Recording running")
                self.recordBtn.setTitle("Stop recording")
                print("Recording started")
            } catch {
                print("Recording failed to start with error \(error.localizedDescription)")
            }
        }
    }
    
    private func stopAudioRecording() {
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
            self.isRecordingRunning = false
            self.infoLabel.setText("Recording stopped")
            self.recordBtn.setTitle("Start recording")
        }
    }
    
    @IBAction func recordBtnTapped() {
        isRecordingRunning ? self.stopAudioRecording() : self.startAudioRecording()
    }
    
    @IBAction func playBtnTapped() {
        print("playBtnTapped")
        let audioFileURL = getDirectory().appendingPathComponent("recording.m4a")
        presentMediaPlayerController(with: audioFileURL, options: nil, completion: {_,_,_ in })
    }
    
}
