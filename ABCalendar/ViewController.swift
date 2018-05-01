//
//  ViewController.swift
//  ABCalendar
//
//  Created by AB on 14/04/18.
//  Copyright © 2018 AB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var monthlyHeaderView: ABMonthHeaderView!
    
    @IBOutlet weak var weekDayView: ABWeekDayView! {
        didSet {
            let appereance = ABWeekDayAppearance(symbolsType: .short, calendar: defaultCalendar)
            weekDayView.appearance = appereance
        }
    }
    
    @IBOutlet weak var calendarView: ABCalendarView! {
        didSet {
            let appereance = ABCalendarViewAppearance(startDate: nil, endDate: nil, calendar: defaultCalendar)
            calendarView.appearance = appereance
        }
    }

    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subView.clipsToBounds = true
        subView.layer.cornerRadius = 10.0
        subView.layer.borderWidth = 1.0
        subView.layer.borderColor = UIColor.lightGray.cgColor
        subView.layer.shadowColor = UIColor.darkGray.cgColor
        subView.layer.shadowOpacity = 0.9
        subView.layer.shadowRadius = 5.0
        subView.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        
        if UIDevice.current.model.hasPrefix("iPad") {
            calendarView.weekHeight = 80.0
        }
        calendarView.monthDelegate = monthlyHeaderView;
        calendarView.delegate = self
        monthlyHeaderView.delegate = self
        let day = ABDay(date: Date(), state: .Event)
        calendarView.selectedDays = [day]
        calendarView.isLayoutupdated = false
        calendarView.setup()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: ABCalendarViewDelegate {
    func didSelectDay(_ date: ABDay?) {
        print(date?.date)
    }
}

extension ViewController: ABMonthHeaderViewDelegate {
    func didTapNextMonth() {
       calendarView.nextMonth()
    }
    
    func didTapPreviousMonth() {
        calendarView.previousMonth()
    }
}


