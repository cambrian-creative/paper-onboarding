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

    /**
     Tells the delegate that the paperOnbording start scrolling.

     - parameter index: An curretn index item
     */
    func onboardingWillTransitonToIndex(_ index: Int)

    /**
     Tells the delegate that the paperOnbording will try to transition to a screen after the last
     */
    func onboardingWillTransitonToLeaving()

    /**
     Tells the delegate that the specified item is now selected

     - parameter index: An curretn index item
     */
    func onboardingDidTransitonToIndex(_ index: Int)

    /**
     Should `PaperOnboarding` react to taps on `PageControl` view.
     If `true`, will scroll to tapped page.
     */
    var enableTapsOnPageControl: Bool { get }
    
    /**
     Provides the actual content for the specified index
     */
    func onboardingItem(atIndex index: Int) -> OnboardingContentViewItem
    
    /**
     Perform the entry animation
     */
    func animateIn(item: OnboardingContentViewItem, duration: Double)
    
    /**
     Perform the exit animation
     */
    func animateOut(item: OnboardingContentViewItem, duration: Double)
    
    /**
     Provides the actual content for the specified index
     */
    func onboardingItemBackgroundColor(atIndex index: Int) -> UIColor
}
