//
//  RingGraph.swift
//  RingMeter
//
//  Created by Michał Kreft on 29/03/15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import Foundation
import UIKit

public struct RingGraph {
    let meters: [RingMeter]
    
    public init?(meters: [RingMeter]) {
        self.meters = meters
        
        if (meters.count == 0) {
            return nil
        }
    }
    
    public init?(meter: RingMeter) {
        self.init(meters: [meter])
    }
}

private let defaultColor = UIColor.lightGray

public struct RingMeter {
    let title: String
    let value: Float
    let maxValue: Float
    let colors: [UIColor]
    let symbolProvider: SymbolPathProvider
    
    internal let normalizedValue: Float
    let backgroundColor: UIColor
    let descriptionLabelColor: UIColor
    let titleColor: UIColor
    let titleFont: UIFont
    let descriptionFont: UIFont

    
    public init(title: String,
                value: Float,
                maxValue: Float,
                colors: [UIColor],
                symbolProvider: SymbolPathProvider,
                backgroundColor: UIColor = .white,
                descriptionLabelColor: UIColor = .white,
                titleColor: UIColor = .white,
                titleFont: UIFont = UIFont.boldSystemFont(ofSize: 17),
                descriptionFont: UIFont = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)) {
        
        self.title = title
        self.value = value
        self.maxValue = maxValue
        self.colors = colors.count > 0 ? colors : [defaultColor]
        self.symbolProvider = symbolProvider
        
        normalizedValue = value <= maxValue ? Float(value) / Float(maxValue) : 1.0
        
        self.backgroundColor = backgroundColor
        self.descriptionLabelColor = descriptionLabelColor
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.descriptionFont = descriptionFont
    }
    
    public init(title: String,
                value: Float,
                maxValue: Float,
                colors: [UIColor],
                backgroundColor: UIColor = .gray,
                descriptionLabelColor: UIColor = .black,
                titleColor: UIColor = .black,
                titleFont: UIFont = UIFont.boldSystemFont(ofSize: 17),
                descriptionFont: UIFont = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)) {
        let pathProvider = NilPathProvider()
        self.init(title: title, value: value, maxValue: maxValue, colors: colors, symbolProvider: pathProvider, backgroundColor: backgroundColor, descriptionLabelColor: descriptionLabelColor, titleColor: titleColor, titleFont: titleFont, descriptionFont: descriptionFont)
        
    }
}

