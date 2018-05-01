//
//  ABMonthView.swift
//  ABCalendar
//
//  Created by AB on 14/04/18.
//  Copyright © 2018 AB. All rights reserved.
//

import UIKit

@IBDesignable class ABMonthView: UIView {
    
    let month: ABMonth
    private let weekHeight: CGFloat
    private var weekViews = [ABWeekView]()
    private let weekWidth: CGFloat
    
    weak var delegate: ABMonthViewDelegate? = nil
    
    var isDrawn: Bool {
        return !weekViews.isEmpty
    }
    
    init(month: ABMonth, weekHeight: CGFloat, weekWidth: CGFloat){
        self.month = month
        self.weekHeight = weekHeight
        self.weekWidth = weekWidth
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func drawWeeksView() {
        guard isDrawn == false else { return }
        
        var y: CGFloat = 0.0
        
        self.weekViews = []
        
        month.weeks.enumerated().forEach { index, week in
            let weekView = ABWeekView(week: week, weekHeight: weekHeight, weekWidth: weekWidth)
            weekView.frame = CGRect(x: 0, y: y, width: self.weekWidth, height: self.weekHeight)
            y = weekView.frame.maxY
            self.addSubview(weekView)
            weekView.delegate = self
            self.weekViews.append(weekView)
            weekView.setupDates()
        }
    }
    
    func clean() {
        weekViews.forEach { weekView  in
            weekView.subviews.forEach{ $0.removeFromSuperview() }
        }
        weekViews = []
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension ABMonthView: ABWeekViewDelegate {
    func didSelectDate(_ date: ABDay?) {
        delegate?.didSelectDateinMonth(date)
    }
}

