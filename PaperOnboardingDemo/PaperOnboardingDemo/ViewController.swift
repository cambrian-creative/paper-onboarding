//
//  ViewController.swift
//  AnimatedPageView
//
//  Created by Alex K. on 12/04/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var skipButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        skipButton.isHidden = true

        setupPaperOnboardingView()

        view.bringSubviewToFront(skipButton)
    }

    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)

        // Add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
}

// MARK: Actions

extension ViewController {

    @IBAction func skipButtonTapped(_: UIButton) {
        print(#function)
    }
}

// MARK: PaperOnboardingDelegate

extension ViewController: PaperOnboardingDelegate {
    func onboardingItem(atIndex index: Int) -> OnboardingContentViewItem {
        return OnboardingItem()
    }
    
    func animateIn(item: OnboardingContentViewItem, duration: Double) {
        item.alpha = 0
        item.transform = item.transform.translatedBy(x: 0, y: 50)
        UIView.animate(withDuration: duration) {
            item.alpha = 1
            item.transform = item.transform.translatedBy(x: 0, y: -50)
        }
    }
    
    func animateOut(item: OnboardingContentViewItem, duration: Double) {
        item.alpha = 1
        item.transform = item.transform.translatedBy(x: 0, y: -20)
        UIView.animate(withDuration: duration) {
            item.alpha = 0
            item.transform = item.transform.translatedBy(x: 0, y: 20)
        }
    }
    
    func onboardingWillTransitonToLeaving() {
        // NOOP
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        // NOOP
    }
    
    var enableTapsOnPageControl: Bool {
        return true
    }
    
    func onboardingItemBackgroundColor(atIndex index: Int) -> UIColor {
        return [UIColor.blue, UIColor.red, UIColor.green][index]
    }

    func onboardingWillTransitonToIndex(_ index: Int) {
        skipButton.isHidden = index == 2 ? false : true
    }
}

// MARK: PaperOnboardingDataSource

extension ViewController: PaperOnboardingDataSource {

    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardinPageItemRadius() -> CGFloat {
        return 8
    }
    
    func onboardingPageItemSelectedRadius() -> CGFloat {
        return 22
    }
    
    func onboardingPageItemColor(at index: Int) -> UIColor {
        return .white
    }
}

//MARK: Constants
private extension ViewController {
    
    static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
}

class OnboardingItem : OnboardingContentViewItem {
    let exampleLabel = UILabel()
    
    override init() {
        super.init()
        
        translatesAutoresizingMaskIntoConstraints = false
        exampleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        exampleLabel.text = "I'm a custom label"
        exampleLabel.textColor = .gray
        exampleLabel.font = ViewController.titleFont
        exampleLabel.textAlignment = .center
        
        addSubview(exampleLabel)
        
        NSLayoutConstraint.activate([
            exampleLabel.topAnchor.constraint(equalTo: topAnchor),
            exampleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            exampleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            exampleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
