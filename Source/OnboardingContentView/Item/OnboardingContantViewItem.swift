//
//  OnboardingContentViewItem.swift
//  AnimatedPageView
//
//  Created by Alex K. on 21/04/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

public class OnboardingContentViewItem: UIView {
    public var imageView: UIImageView?
    public var titleLabel: UILabel?
    public var descriptionLabel: UILabel?

    public init() {
        super.init(frame: CGRect.zero)
    }
    
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
