//
//  ViewController.swift
//  Custom-View-Button-Area
//
//  Created by kawaharadai on 2019/07/17.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak private var buttonAreaView: ButtonAreaView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let startButtonInfo = ButtonInfo(title: "Start", color: .blue) { print("Start") }
        let stopButtonInfo = ButtonInfo(title: "Stop", color: .red) { print("Stop") }
        let closeButtonInfo = ButtonInfo(title: "Close", color: .darkGray) { print("Close") }
        let reStartButtonInfo = ButtonInfo(title: "ReStart", color: .green) { print("ReStart") }
        let captureButtonInfo = ButtonInfo(title: "Capture", color: .orange) { print("Capture") }
        let anarizeButtonInfo = ButtonInfo(title: "Anarize", color: .purple) { print("Anarize") }
        let doneButtonInfo = ButtonInfo(title: "Done", color: .blue) { print("Done") }

        buttonAreaView.setup(prepareButtons: [startButtonInfo],
                             runButtons: [stopButtonInfo, closeButtonInfo],
                             waitButtons: [reStartButtonInfo],
                             completeButtons: [captureButtonInfo, anarizeButtonInfo, doneButtonInfo])
    }

    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        guard sender.selectedSegmentIndex < ButtonAreaState.allCases.count else { return }
        let newState = ButtonAreaState.allCases[sender.selectedSegmentIndex]
        buttonAreaView.changeViewState(newState)
    }
}

