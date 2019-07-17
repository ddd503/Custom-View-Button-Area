//
//  ButtonAreaView.swift
//  Custom-View-Button-Area
//
//  Created by kawaharadai on 2019/07/17.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

final class ButtonAreaView: UIView {

    private let buttonFrame = CGRect(origin: .zero, size: CGSize(width: 80, height: 80))
    private let maxButtonCount = 3
    private var buttons = [UIButton]()

    var state: ButtonAreaStatus? {
        didSet {
            guard let state = state else { return }
            updateState(state)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 配置調整
        adjustButtonsPosition()
    }

    private func setup() {
        // 初期配置
        let button = UIButton(frame: buttonFrame)
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
        buttons.append(button)
        addSubview(button)

        let button2 = UIButton(frame: buttonFrame)
        button2.setTitle("Stop", for: .normal)
        button2.backgroundColor = .red
        button2.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
        buttons.append(button2)
        addSubview(button2)

        let button3 = UIButton(frame: buttonFrame)
        button3.setTitle("Done", for: .normal)
        button3.backgroundColor = .orange
        button3.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
        buttons.append(button3)
        addSubview(button3)
    }

    private func adjustButtonsPosition() {
        let centerY = frame.height / 2
        var points = [CGPoint]()
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
        }
    }

    @objc func tapped(sender: UIButton) {

    }

    private func updateState(_ state: ButtonAreaStatus) {
        removeSubviews()
        // ボタンの再配置（問題はアクションの割り当てができない）
    }

    private func removeSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
