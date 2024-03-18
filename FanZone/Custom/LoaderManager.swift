//
//  LoaderManager.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 18/03/2024.
//

import Foundation
import UIKit
import Lottie

class LoaderManager {
    static let shared = LoaderManager()

    internal var ballLoader: LottieAnimationView!

    private init() {}

    func setUpBallLoader(in view: UIView) {
        ballLoader = LottieAnimationView(name: "playerLoader")
        ballLoader.translatesAutoresizingMaskIntoConstraints = false
        ballLoader.contentMode = .scaleAspectFit
        ballLoader.loopMode = .loop
        ballLoader.animationSpeed = 0.9
        ballLoader.alpha = 0 // Initially hide the ball loader
        view.addSubview(ballLoader)

        NSLayoutConstraint.activate([
            ballLoader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ballLoader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ballLoader.widthAnchor.constraint(equalToConstant: 100), // Set your desired width
            ballLoader.heightAnchor.constraint(equalToConstant: 100) // Set your desired height
        ])
    }

    func showBallLoader() {
        ballLoader.alpha = 1
        ballLoader.play()
    }

    func hideBallLoader() {
        ballLoader.alpha = 0
        ballLoader.stop()
    }
}

