//
//  ViewController.swift
//  AGSMapViewTouchTest
//
//  Created by Worth Sparks on 2/21/19.
//  Copyright © 2019 Bluefield GIS. All rights reserved.
//

import UIKit
import ArcGIS

class ViewController: UIViewController {

    @IBOutlet weak var mapView: AGSMapView!
    @IBOutlet weak var interactionDisabledButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.map = AGSMap()
        mapView.map?.basemap = AGSBasemap.topographic()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTwoTouchPan()
        interaction(isEnabled: true)

        let strokeGestureRecognizer =
            StrokeGestureRecognizer(target: self,
                                    action: #selector(strokeUpdated(_:)),
                                    coordinateSpaceView: mapView)
        mapView.addGestureRecognizer(strokeGestureRecognizer)
    }

    func setTwoTouchPan() {
        guard let gestureRecognizers = mapView.gestureRecognizers else { return }
        for gestureRecognizer in gestureRecognizers {
            if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
                panGestureRecognizer.minimumNumberOfTouches = 2
            }
        }
    }

    func interaction(isEnabled: Bool) {
        mapView.interactionOptions.isEnabled = isEnabled
        interactionDisabledButton.isHidden = isEnabled
        // if isEnabled {
        //     mapView.interactionOptions.isEnabled = true
        //     interactionDisabledButton.setTitle("Interaction Enabled", for: .normal)
        //     interactionDisabledButton.setTitleColor(UIColor.white, for: .normal)
        //     interactionDisabledButton.backgroundColor = UIColor.green
        // } else {
        //     mapView.interactionOptions.isEnabled = false
        //     interactionDisabledButton.setTitle("Interaction Disabled", for: .normal)
        //     interactionDisabledButton.setTitleColor(UIColor.white, for: .normal)
        //     interactionDisabledButton.backgroundColor = UIColor.red
        // }
    }
}


extension ViewController: UIGestureRecognizerDelegate {

    @objc func strokeUpdated(_ strokeRecognizer: StrokeGestureRecognizer) {
        switch strokeRecognizer.state {
        case .began:
            // Start accumulating samples for a new stroke.
            interaction(isEnabled: false)
        case .ended:
            // Finish and record the stroke.
            interaction(isEnabled: true) //
        case .cancelled:
            // Discard any samples we may have accumulated and cancel the stroke.
            interaction(isEnabled: true)
        case .changed: break
            // print(".changed")
        case .possible:
            print("unexpected strokeRecognizer state: .possible")
        case .failed:
            print("unexpected strokeRecognizer state: .failed")
        }
    }

    // Since our gesture recognizer is beginning immediately, we do the hit test
    // ambiguation here instead of adding failure requirements to the gesture
    // for minimizing the delay to the first action sent and therefore the first
    // strokes drawn.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }

    // We want this gesture recognizer to be exclussive.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

}
