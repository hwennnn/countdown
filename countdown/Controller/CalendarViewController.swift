//
//  CalendarViewController.swift
//  countdown
//
//  Created by zachary on 12/1/21.
//

import UIKit
import CVCalendar
import Foundation
import SideMenu

class CalendarViewController : UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet var eventTable: UITableView!
    
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    private var randomNumberOfDotMarkersForDay = [Int]()
    private var shouldShowDaysOut = true
    private var animationFinished = true
    private var selectedDay: DayView!
    private var currentCalendar: Calendar?
    var formatter = DateFormatter()
    
    // Controller
    let eventController = EventController()
    
    // Data structures
    var datesDictionary = [String:[Event]]()
    var eventArr:[Event] = []
    
    @IBAction func didTapMenu(){
        present(appDelegate.menu!, animated: true, completion: nil)
    }
    
    func calculateCountDown(_ date:Date) -> Int{
        return Calendar.current.dateComponents([.day], from: Date(), to: date).day!
    }
    
    func dateFormat(_ date:Date) -> String{
        let dateFormatter = DateFormatter() // set to local date (Singapore)
        dateFormatter.locale = Locale(identifier: "en_SG") // set desired format, note a is AM and FM format
        dateFormatter.dateFormat = "dd MMM yyyy h:mm a" // convert date to String
        let datevalue = dateFormatter.string(from: date)
        
        return datevalue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.eventTable.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath)
        let event = eventArr[indexPath.row]
        cell.textLabel!.text = event.name
        cell.detailTextLabel!.text = "\(dateFormat(event.date)) \(calculateCountDown(event.date)) days left"
        return cell
        
    }
    
    func loadEventData() -> [String:[Event]]{
        //filling up dictionary (data)
        var dict = [String:[Event]]()
        
        for event in eventController.retrieveAllEvent(){
            let eventDate = formatter.string(from: event.date)
            let keyExists = dict[eventDate] != nil
            if (keyExists) {
                dict[eventDate]?.append(event)
            }else{
                dict[eventDate] = [event]
            }
        }
        
        return dict
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "dd MMMM, yyyy"
        formatter.locale = Locale(identifier: "en_SG")
        
        calendarView.calendarAppearanceDelegate = self
        calendarView.animatorDelegate = self
        calendarView.delegate = self
        menuView.delegate = self
        calendarView.appearance.dayLabelPresentWeekdaySelectedBackgroundColor = .colorFromCode(1)
        calendarView.appearance.dayLabelWeekdaySelectedBackgroundColor = .colorFromCode(2)
        self.navigationItem.title = "Calendar"
        
        eventTable.delegate = self
        eventTable.dataSource = self

        self.eventTable.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.datesDictionary = self.loadEventData()
        
        let date = selectedDay.date.convertedDate()!
        let formattedDateString:String = formatter.string(from: date)
        self.eventArr = self.datesDictionary[formattedDateString] ?? []

//        printing of the dictionary
//        for day in datesDictionary{
//            print(day.key)
//            for e in day.value as [Event]{
//                print(e.name, e.date)
//            }
//        }
        
        self.eventTable.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
        self.eventTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.eventTable.reloadData()
        // Dispose of any resources that can be recreated.
    }
}

extension CalendarViewController : CVCalendarMenuViewDelegate{
    
}

extension CalendarViewController : CVCalendarViewDelegate{
    func presentationMode() -> CalendarMode { return CalendarMode.monthView }
    func firstWeekday() -> Weekday { return Weekday.monday }
    
    func presentedDateUpdated(_ date: CVDate) {
            if monthLabel.text != date.globalDescription && self.animationFinished {
                let updatedMonthLabel = UILabel()
                updatedMonthLabel.textColor = monthLabel.textColor
                updatedMonthLabel.font = monthLabel.font
                updatedMonthLabel.textAlignment = .center
                updatedMonthLabel.text = date.globalDescription
                updatedMonthLabel.sizeToFit()
                updatedMonthLabel.alpha = 0
                updatedMonthLabel.center = self.monthLabel.center
                
                let offset = CGFloat(48)
                updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
                updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                
                UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseInOut , animations: {
                    self.animationFinished = false
                    self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                    self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                    self.monthLabel.alpha = 0
                    
                    updatedMonthLabel.alpha = 1
                    updatedMonthLabel.transform = CGAffineTransform.identity
                    
                }) { _ in
                    
                    self.animationFinished = true
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransform.identity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
                }
                
                self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
            }
        }
    
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool){
        selectedDay = dayView
        let formattedDateString:String = formatter.string(from: dayView.date.convertedDate()!)
        self.eventArr = self.datesDictionary[formattedDateString] ?? []

//        print(formattedDateString, self.eventArr)
    }
}

