//
//  ABWeekDayView.swift
//  ABCalendar
//
//  Created by AB on 14/04/18.
//  Copyright © 2018 AB. All rights reserved.
//

import UIKit

public enum ABWeekDaysSymbolsType {
    case short, veryShort
    
    func names(from calendar: Calendar) -> [String] {
        switch self {
        case .short:
            return calendar.shortWeekdaySymbols
        case .veryShort:
            return calendar.veryShortWeekdaySymbols
        }
    }
}

public struct ABWeekDayAppearance {
    let symbolsType: ABWeekDaysSymbolsType
    let calendar: Calendar
    
    public init(
        symbolsType: ABWeekDaysSymbolsType = .short,
        calendar: Calendar = Calendar.current) {
        self.symbolsType = symbolsType
        self.calendar = calendar
    }
}

@IBDesignable class ABWeekDayView: UIView {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fivthLabel: UILabel!
    @IBOutlet weak var sixthLabel: UILabel!
    @IBOutlet weak var seventhLabel: UILabel!
    // Our custom view from the XIB file
    var view: UIView!
    
    public var appearance = ABWeekDayAppearance() {
        didSet {
            setupData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        setupData()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ABWeekDayView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    func setupData() {
        let names = getWeekdayNames()
        names.enumerated().forEach {index, name in
            switch index {
            case 0:
                self.firstLabel.text = name
            case 1:
                self.secondLabel.text = name
            case 2:
                self.thirdLabel.text = name
            case 3:
                self.fourthLabel.text = name
            case 4:
                self.fivthLabel.text = name
            case 5:
                self.sixthLabel.text = name
            case 6:
                self.seventhLabel.text = name
            default:
                self.firstLabel.text = ""
                self.secondLabel.text = ""
                self.thirdLabel.text = ""
                self.fourthLabel.text = ""
                self.fivthLabel.text = ""
                self.sixthLabel.text = ""
                self.seventhLabel.text = ""
            }
        }
        
    }
    
    private func getWeekdayNames() -> [String] {
        let symbols = appearance.symbolsType.names(from: appearance.calendar)
        
        if appearance.calendar.firstWeekday == 1 {
            return symbols
        } else {
            let allDaysWihoutFirst = Array(symbols[appearance.calendar.firstWeekday - 1..<symbols.count])
            return allDaysWihoutFirst + symbols[0..<appearance.calendar.firstWeekday - 1]
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
