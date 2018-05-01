//
//  ABCalendarDelegate.swift
//  ABCalendar
//
//  Created by AB on 15/04/18.
//  Copyright © 2018 AB. All rights reserved.
//

import Foundation

public protocol ABMonthHeaderViewDelegate: class {
    func didTapNextMonth()
    func didTapPreviousMonth()
}

public protocol ABCalendarMonthDelegate: class {
    func monthDidChange(_ currentMonth: Date)
}

protocol ABWeekViewDelegate: class {
    func didSelectDate(_ date: ABDay?)
}

protocol ABMonthViewDelegate: class {
    func didSelectDateinMonth(_ date: ABDay?)
}

protocol ABCalendarViewDelegate: class {
    func didSelectDay(_ date: ABDay?)
}
