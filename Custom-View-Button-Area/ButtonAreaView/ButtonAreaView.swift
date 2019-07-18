//
//  ButtonAreaView.swift
//  Custom-View-Button-Area
//
//  Created by kawaharadai on 2019/07/17.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

// Viewの状態を表すenum
enum ButtonAreaState: CaseIterable {
    case prepare
    case run
    case wait
    case complete
}

final class ButtonAreaView: UIView {
    private let buttonFrame = CGRect(origin: .zero, size: CGSize(width: 80, height: 80))
    private let maxButtonCount = 3
    private var buttons = [UIButton]()

    // ステータス毎の配置ボタン情報
    private var prepareButtons = [ButtonInfo]()
    private var runButtons = [ButtonInfo]()
    private var waitButtons = [ButtonInfo]()
    private var completeButtons = [ButtonInfo]()

    private var state: ButtonAreaState? {
        didSet {
            guard let state = state else { return }
            updateState(state)
        }
    }

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Viewのlayoutが確定後、ボタンを置いていく
        setButtons()
    }

    // MARK: - Internal

    func setup(prepareButtons: [ButtonInfo], runButtons: [ButtonInfo],
               waitButtons: [ButtonInfo], completeButtons: [ButtonInfo]) {
        self.prepareButtons = prepareButtons
        self.runButtons = runButtons
        self.waitButtons = waitButtons
        self.completeButtons = completeButtons

        changeViewState(.prepare)
    }

    func changeViewState(_ state: ButtonAreaState) {
        self.state = state
    }

    // MARK: - Private

    private func setButtons() {
        let centerY = frame.height / 2
        var points = [CGPoint]()
        // 最大表示ボタン数は3としている（配列の前から３つを表示）
        let displayButtons = buttons.enumerated().compactMap { $0.offset < maxButtonCount ? $0.element : nil}

        (0 ..< displayButtons.count).forEach { [weak self] (buttonCount) in
            guard let self = self else { return }
            points.removeAll()
            let centerXArray: [CGFloat] = (0 ... buttonCount).map { (pointNumber) in
                let length = self.frame.width / CGFloat(buttonCount + 1)
                return (length / 2) + (length * CGFloat(pointNumber))
            }
            points = centerXArray.map { CGPoint(x: $0, y: centerY) }
        }

        displayButtons.enumerated().forEach { (offset, button) in
            guard offset < points.count else { return }
            button.center = points[offset]
            addSubview(button)
        }
    }

    private func updateState(_ state: ButtonAreaState) {
        removeSubviews()

        switch state {
        case .prepare:
            createButtons(info: prepareButtons)
        case .run:
            createButtons(info: runButtons)
        case .wait:
            createButtons(info: waitButtons)
        case .complete:
            createButtons(info: completeButtons)
        }
    }

    private func createButtons(info: [ButtonInfo]) {
        buttons.removeAll()

        info.enumerated().forEach {
            let button = UIButton(frame: buttonFrame)
            button.setTitle($0.element.title, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
            button.backgroundColor = $0.element.color
            button.tag = $0.offset + 1
            button.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(shrinkAnimation(sender:)), for: .touchDown)
            button.addTarget(self, action: #selector(restoreAnimation(sender:)), for: [.touchUpInside, .touchDragOutside])
            buttons.append(button)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = buttonFrame.width / 2
        }

        // viewのlayoutを更新
        setNeedsLayout()
        layoutIfNeeded()
    }

    @objc private func tapped(sender: UIButton) {
        guard let state = state else { return }

        switch state {
        case .prepare:
            guard sender.tag <= prepareButtons.count else { return }
            prepareButtons[sender.tag - 1].action()
        case .run:
            guard sender.tag <= runButtons.count else { return }
            runButtons[sender.tag - 1].action()
        case .wait:
            guard sender.tag <= waitButtons.count else { return }
            waitButtons[sender.tag - 1].action()
        case .complete:
            guard sender.tag <= completeButtons.count else { return }
            completeButtons[sender.tag - 1].action()
        }
    }

    @objc private func shrinkAnimation(sender: UIButton) {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        })
    }

    @objc private func restoreAnimation(sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            sender.transform = .identity
        })
    }

    private func removeSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
