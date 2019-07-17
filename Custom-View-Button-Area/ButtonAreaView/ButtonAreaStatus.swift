//
//  ButtonAreaStatus.swift
//  Custom-View-Button-Area
//
//  Created by kawaharadai on 2019/07/17.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

enum ButtonAreaStatus {
    case prepare(start: () -> ())
    case run(stop: () -> (), end: () -> ())
    case wait(restart: () -> ())
    case complete(close: () -> (), retry: () -> (), analize: () -> ())

    var buttonColors: [UIColor] {
        switch self {
        case .prepare:
            return [.blue]
        case .run:
            return [.red, .darkGray]
        case .wait:
            return [.blue]
        case .complete:
            return [.red, .blue, .orange]
        }
    }

    var buttonTitles: [String] {
        switch self {
        case .prepare:
            return ["Start"]
        case .run:
            return ["Stop", "End"]
        case .wait:
            return ["Restart"]
        case .complete:
            return ["Close", "Retry", "Analize"]
        }
    }
}
