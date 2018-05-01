//
//  ABCalendarView.swift
//  ABCalendar
//
//  Created by AB on 14/04/18.
//  Copyright © 2018 AB. All rights reserved.
//

import UIKit


public struct ABCalendarViewAppearance {
    var calendar: Calendar = Calendar.current
    var startDate: Date? = nil
    var endDate: Date? = nil
    
    public init(
        startDate: Date? = nil,
        endDate: Date? = nil,
        calendar: Calendar = Calendar.current) {
        self.calendar = calendar
        self.startDate = startDate ?? calendar.date(byAdding: .year, value: -1, to: Date())!
        self.endDate = endDate ?? calendar.date(byAdding: .year, value: 1, to: Date())!
    }
}

@IBDesignable class ABCalendarView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var calendarViewHeightConstraints: NSLayoutConstraint?
    
    
    public weak var monthDelegate: ABCalendarMonthDelegate?
    weak var delegate: ABCalendarViewDelegate? = nil

    var view: UIView!
    
    private var monthViews = [ABMonthView]()
    var months = [ABMonth]()
    var isLayoutupdated: Bool = false // set this false if you will reload whole calendar
    var selectedDays = [ABDay]()
    var weekHeight: CGFloat = 50.0
    
    public var appearance = ABCalendarViewAppearance()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    override func layoutSubviews() {
        if isLayoutupdated == false {
            isLayoutupdated = true
            setupUI()
        }
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
    
    func setup() {
        setupData()
        setupUI()
    }
    
    func setupUI() {
        clean()
        self.scrollView.contentSize.width = self.frame.width * CGFloat(months.count)
        setupMonths()
        scrollToStartDate()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ABCalendarView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func clean() {
        monthViews.forEach { monthView in
            monthView.subviews.forEach{ $0.removeFromSuperview() }
        }
        monthViews = []
        self.scrollView.subviews.forEach { $0.removeFromSuperview() }
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
    func setupData() {
        let startDate = appearance.startDate ?? appearance.calendar.date(byAdding: .year, value: -1, to: Date())!
        let endDate = appearance.endDate ?? appearance.calendar.date(byAdding: .year, value: 1, to: Date())!
        months = generateMonths(from: startDate, endDate: endDate)
    }
    
    private func generateMonths(from startDate: Date, endDate: Date) -> [ABMonth] {
        let startComponents = appearance.calendar.dateComponents([.year, .month], from: startDate)
        let endComponents = appearance.calendar.dateComponents([.year, .month], from: endDate)
        var startDate = appearance.calendar.date(from: startComponents)!
        let endDate = appearance.calendar.date(from: endComponents)!
        var months = [ABMonth]()
        
        repeat {
            let date = startDate
            let month = ABMonth(month: date, calendar: appearance.calendar)
            month.selectedDays = selectedDays//.filter { appearance.calendar.isDate($0.date, equalTo: startDate, toGranularity: .month) }
            months.append(month)
            startDate = appearance.calendar.date(byAdding: .month, value: 1, to: date)!
        } while !appearance.calendar.isDate(startDate, inSameDayAs: endDate)
        return months
    }
    
    private func setupMonths() {
        monthViews = months.map { ABMonthView(month: $0, weekHeight: self.weekHeight, weekWidth: self.frame.width) }
        
        monthViews.enumerated().forEach { index, monthView in
                let x = index == 0 ? 0 : monthViews[index - 1].frame.maxX
                monthView.frame = CGRect(x: x, y: 0, width: self.frame.width, height: self.frame.height)
                monthView.delegate = self
                self.scrollView.addSubview(monthView)
        }
    }
    
    private func scrollToStartDate() {
        let startMonth = monthViews.first(where: { $0.month.dateInThisMonth(Date()) })

        if let startMonth = startMonth {
            self.scrollView.setContentOffset(startMonth.frame.origin, animated: false)
        } else {
            self.scrollView.setContentOffset(.zero, animated: false)
        }
        drawVisibleMonth(with: self.scrollView.contentOffset)
    }
    
    private func drawVisibleMonth(with offset: CGPoint) {
        let first: ((offset: Int, element: ABMonthView)) -> Bool = { $0.element.frame.midX >= offset.x }
        guard let currentIndex = monthViews.enumerated().first(where: first)?.offset else { return }
        
        monthViews.enumerated().forEach { index, month in
            if index == currentIndex || index + 1 == currentIndex || index - 1 == currentIndex {
                month.drawWeeksView()
            } else {
                month.clean()
            }
        }
    }
    
    func calculateViewHeight(_ monthView: ABMonthView){
        let height = CGFloat(monthView.month.weeks.count)*self.weekHeight
        self.calendarViewHeightConstraints?.constant = height;
    }
    
    private func getMonthView(with offset: CGPoint) -> ABMonthView? {
        return monthViews.first(where: { $0.frame.midX >= offset.x })
    }
    
    public func nextMonth() {
        let x = self.scrollView.contentOffset.x + self.frame.width
        guard x < self.scrollView.contentSize.width else { return }
        
        self.scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        drawVisibleMonth(with: self.scrollView.contentOffset)
    }
    
    public func previousMonth() {
        let x = self.scrollView.contentOffset.x - self.frame.width
        guard x >= 0 else { return }
        
        self.scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        drawVisibleMonth(with: self.scrollView.contentOffset)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension ABCalendarView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let monthView = getMonthView(with: scrollView.contentOffset) else { return }
        monthDelegate?.monthDidChange(monthView.month.date)
        self.calculateViewHeight(monthView)
        drawVisibleMonth(with: scrollView.contentOffset)
    }
}

extension ABCalendarView: ABMonthViewDelegate {
    func didSelectDateinMonth(_ date: ABDay?) {
        delegate?.didSelectDay(date)
    }
}
