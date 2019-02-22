//
//  StrokeGestureRecognizer.swift
//  AGSMapViewTouchTest
//
//  Created by Worth Sparks on 2/21/19.
//  Copyright © 2019 Bluefield GIS. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class StrokeGestureRecognizer: UIGestureRecognizer {
    // Configuration.
    let coordinateSpaceView: UIView

    // State.
    private var mainTouch: UITouch? // nil or first touch in finger-down
    private var initialTimestamp: TimeInterval?
    private var fingerStartTimer: Timer?
    private var cancellationTimeInterval: TimeInterval = 0.1

    init(target: Any?, action: Selector?, coordinateSpaceView: UIView) {
        self.coordinateSpaceView = coordinateSpaceView
        super.init(target: target, action: action)
        self.delegate = target as? UIGestureRecognizerDelegate
        self.cancellationTimeInterval = TimeInterval(0.1)
        self.cancelsTouchesInView = false
        self.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
    }

    private func append(touches: Set<UITouch>, event: UIEvent?) -> Bool {
        guard let mainTouch = mainTouch else { return false }

        // Cancel the stroke recognition if we get a second touch during cancellation period.
        for touch in touches
            where touch !== mainTouch &&
                  touch.timestamp - initialTimestamp! < cancellationTimeInterval {
            if state == .possible {
                state = .failed
            } else {
                state = .cancelled
            }
            return false
        }

        // See if those touches contain our main touch. If not, ignore gracefully.
        guard touches.contains(mainTouch) else { return false }

        // use mainTouch samples here

        return true
    }

    // MARK: Touch handling methods.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mainTouch == nil {
            mainTouch = touches.first
            initialTimestamp = mainTouch?.timestamp
            fingerStartTimer = Timer.scheduledTimer(timeInterval: cancellationTimeInterval,
                                                    target:       self,
                                                    selector:     #selector(beginIfNeeded(_:)),
                                                    userInfo:     nil,
                                                    repeats:      false)
        }
        let _ = append(touches: touches, event: event)
    }

    // If not for pencil we give other gestures (pan, pinch) a chance by delaying our begin just a little.
    @objc private func beginIfNeeded(_ timer: Timer) {
        if state == .possible {
            state = .began
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if append(touches: touches, event: event) {
            if state == .began {
                state = .changed
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if append(touches: touches, event: event) {
            state = .ended
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if append(touches: touches, event: event) {
            state = .failed
        }
    }

    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        // update estimated samples here
    }

    override func reset() {
        mainTouch = nil
        if let timer = fingerStartTimer {
            timer.invalidate()
            fingerStartTimer = nil
        }
        super.reset()
    }
}
