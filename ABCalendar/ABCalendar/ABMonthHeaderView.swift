//
//  ABMonthHeaderView.swift
//  ABCalendar
//
//  Created by AB on 14/04/18.
//  Copyright © 2018 AB. All rights reserved.
//

import UIKit

@IBDesignable class ABMonthHeaderView: UIView {
    
     @IBOutlet weak var monthLabel: UILabel!
     @IBOutlet weak var nextButton: UIButton!
     @IBOutlet weak var previousButton: UIButton!
    
    // Our custom view from the XIB file
    var view: UIView!
    
    public weak var delegate: ABMonthHeaderViewDelegate?
  
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        return formatter
    }()
    
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
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ABMonthHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    //MARK: - Button Action
    
    @IBAction func onClickNextButtonAction(sender: UIButton?){
        delegate?.didTapNextMonth()
    }
    
    @IBAction func onClickPreviousButtonAction(sender: UIButton?){
        delegate?.didTapPreviousMonth()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension ABMonthHeaderView: ABCalendarMonthDelegate {
    
    public func monthDidChange(_ currentMonth: Date) {
        monthLabel.text = formatter.string(from: currentMonth)
    }
}
