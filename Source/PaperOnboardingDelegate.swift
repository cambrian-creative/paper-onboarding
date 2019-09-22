//
//  PaperOnboardingDelegate.swift
//  PaperOnboardingDemo
//
//  Created by Abdurahim Jauzee on 05/06/2017.
//  Copyright © 2017 Alex K. All rights reserved.
//

import UIKit

/**
 *  The delegate of a PaperOnboarding object must adopt the PaperOnboardingDelegate protocol. Optional methods of the
 protocol allow the delegate to manage items, configure items, and perform other actions.
 */
public protocol PaperOnboardingDelegate: class {
    var enableTapsOnPageControl: Bool { get }

    func onboardingWillTransitonToIndex(_ index: Int)
    func animateUserInteractionElementsIn(forIndex index: Int, duration: Double)
    func animateUserInteractionElementsOut(forIndex index: Int, duration: Double)
    func onboardingWillTransitonToLeaving()
    func onboardingDidTransitonToIndex(_ index: Int)
    func onboardingItem(atIndex index: Int) -> OnboardingContentViewItem
    func onboardingItemBackgroundColor(atIndex index: Int) -> UIColor
}
