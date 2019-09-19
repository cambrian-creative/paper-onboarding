//
//  OnboardingContentViewItem.swift
//  AnimatedPageView
//
//  Created by Alex K. on 21/04/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

public protocol OnboardingContentViewItem: UIView {
    func animateIn(duration: Double)
    func animateOut(duration: Double)
}
