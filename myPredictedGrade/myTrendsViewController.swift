//
//  myTrendsViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 1/25/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit
import Charts

class myTrendsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var overallTimeframeTextField: UITextField!
    
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var subjectTimeframeTextField: UITextField!
    
    var overallTimeframePickerView = UIPickerView()
    
    var subjectPickerView = UIPickerView()
    var subjectTimeframePickerView = UIPickerView()
    
    var timeframePickerData = ["Daily", "Monthly"]
    
    var subjectPickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate subject picker data
        for subject in AppStatus.user.subjects {
            subjectPickerData.append(subject.toString())
        }
        
        updateOverallGraph(gradeData: [34, 25, 34, 45, 26, 29, 43, 25, 24, 34], timeData: ["15/6", "18/6", "31/6", "2/7", "4/7", "5/7", "7/7", "10/7", "12/7", "15/7"])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*
        var subjectGradeData = [Int]()
        var xAxisValues = [String]()
        
        
        //this is still highly in development, not functional at all
        
        if let user = AppStatus.loggedInUser {
            let assessments = user.assessments
            
            let subjectSnapshots = user.getSubjectSnapshots().filter { $0.subjectObject.subject == .Physics }
            
            for snapshot in subjectSnapshots {
                
                subjectGradeData.append(snapshot.grade)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM"
                
                xAxisValues.append(dateFormatter.string(from: snapshot.date))
                
            }
            
        }
        
        print(xAxisValues)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let barChart = BarChartView()
        barChart.legend.enabled = false
        barChart.chartDescription?.enabled = false
        barChart.drawGridBackgroundEnabled = false
        barChart.highlightPerTapEnabled = false
        barChart.highlightPerDragEnabled = false
        
        let axisFormatter = MyAxisFormatter()
        
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.valueFormatter = axisFormatter
        
        barChart.leftAxis.axisMaximum = 45.0
        barChart.leftAxis.axisMinimum = 24.0
        barChart.rightYAxisRenderer.axis?.drawLabelsEnabled = false
        barChart.rightYAxisRenderer.axis?.drawGridLinesEnabled = false
        barChart.leftYAxisRenderer.axis?.drawGridLinesEnabled = false
        barChart.scaleXEnabled = false
        barChart.scaleYEnabled = false
        barChart.frame = CGRect(x: 10, y: 35, width: scrollView.frame.width - 20, height: 300)
        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bottom
        
        var entries = [BarChartDataEntry]()
        
        var rawData = [34, 36, 35, 39, 40, 40, 38, 32, 38]
        
        for i in 0..<rawData.count {
            let chartDataEntry = BarChartDataEntry(x: Double(i), y: Double(rawData[i]))
            entries.append(chartDataEntry)
        }
        
        let dataSet = BarChartDataSet(values: entries, label: "Set 1")
        let color = UIColor(red: 230/255, green: 0, blue: 4/255, alpha: 0.75)
        dataSet.setColor(NSUIColor(cgColor: color.cgColor))
        //dataSet.drawCirclesEnabled = false
        
        let data = BarChartData(dataSet: dataSet)
        data.setValueFont(NSUIFont(name: "AvenirNext", size: 14))
        let formatter = MyValueFormatter()
        data.setValueFormatter(formatter)
        barChart.data = data
        
        let label = UILabel()
        label.text = "My Graph"
        label.font = UIFont(name: "AvenirNext-Medium", size: 25)
        label.textAlignment = .center
        
        label.frame = CGRect(x: 10, y: 10, width: scrollView.frame.width - 20, height: 30)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * 3, height: scrollView.frame.height)
        
        let label2 = UILabel()
        label2.text = "My Graph 2"
        label2.font = UIFont(name: "AvenirNext-Medium", size: 25)
        label2.textAlignment = .center
        label2.frame = label.frame
        label2.frame.origin.x += scrollView.frame.width
        
        let label3 = UILabel()
        label3.text = "My Graph 3"
        label3.font = UIFont(name: "AvenirNext-Medium", size: 25)
        label3.textAlignment = .center
        label3.frame = label.frame
        label3.frame.origin.x += scrollView.frame.width * 2
        
        scrollView.addSubview(label2)
        scrollView.addSubview(label3)
        
        //scrollView.addSubview(view)
        
        scrollView.addSubview(barChart)
        scrollView.addSubview(label)
        */
        /*
        
        let label = UILabel()
        label.text = "Coming Soon!"
        label.frame = CGRect(x: self.view.frame.width / 2 - 100, y: self.view.frame.height / 2 - 25, width: 200, height: 50)
        label.font = UIFont(name: "AvenirNext-Medium", size: 30)
        self.view.addSubview(label)
        
        let imageView = UIImageView()
        let image = UIImage(named: "AppIcon")
        imageView.image = image
        imageView.frame = CGRect(x: self.view.frame.width / 2 - 50, y: self.view.frame.height / 2 + 50, width: 100, height: 100)
        self.view.addSubview(imageView)
        */
    }
    
    // MARK: - UIPickerView Delegate Funcs
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        if pickerView == subjectPickerView {
            return subjectPickerData.count
        } else {
            return timeframePickerData.count
        }
    
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == subjectPickerView {
            return subjectPickerData[row]
        } else {
            return timeframePickerData[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == overallTimeframePickerView {
            
            var overallGradeData = [Int]()
            var timeData = [String]()
            
            if timeframePickerData[row] == "Monthly" {
                let data = createOverallDataList(timeframe: .monthly)
                overallGradeData = data.0
                timeData = data.1
            } else if timeframePickerData[row] == "Daily" {
                let data = createOverallDataList(timeframe: .daily)
                overallGradeData = data.0
                timeData = data.1
            }
            
            updateOverallGraph(gradeData: overallGradeData, timeData: timeData)
            
        } else {
            
            if subjectTextField.text != "" && subjectTimeframeTextField.text != "" {
                
                var subject = SubjectObject(subject: .Default, isHL: false)
                
                for userSubject in AppStatus.user.subjects {
                    
                    if userSubject.toString() == subjectTextField.text {
                        subject = userSubject
                    }
                    
                }
                
                var subjectGradeData = [Int]()
                var averagePercentageData = [Int]()
                var timeData = [String]()
                
                if timeframePickerData[row] == "Monthly" {
                    let data = createSubjectDataList(timeframe: .monthly, subject: subject)
                    subjectGradeData = data.0[0]
                    averagePercentageData = data.0[1]
                    timeData = data.1
                } else if timeframePickerData[row] == "Daily" {
                    let data = createSubjectDataList(timeframe: .daily, subject: subject)
                    subjectGradeData = data.0[0]
                    averagePercentageData = data.0[1]
                    timeData = data.1
                }
                
                // TODO: - Update graph function
                // updateGraph()
                
            }
            
        }
        
    }
    
    func updateOverallGraph(gradeData: [Int], timeData: [String]) {
        
        let barChart = BarChartView()
        barChart.legend.enabled = false
        barChart.chartDescription?.enabled = false
        barChart.drawGridBackgroundEnabled = false
        barChart.highlightPerTapEnabled = false
        barChart.highlightPerDragEnabled = false
        
        let axisFormatter = MyAxisFormatter()
        axisFormatter.changeAxisValues(to: timeData)
        
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.valueFormatter = axisFormatter
        
        barChart.leftAxis.axisMaximum = 46.0
        barChart.leftAxis.axisMinimum = 22.0
        barChart.rightYAxisRenderer.axis?.drawLabelsEnabled = false
        barChart.rightYAxisRenderer.axis?.drawGridLinesEnabled = false
        barChart.leftYAxisRenderer.axis?.drawGridLinesEnabled = false
        barChart.scaleXEnabled = false
        barChart.scaleYEnabled = false
        barChart.frame = CGRect(x: 10, y: 120, width: self.view.frame.width - 20, height: 200)
        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.setLabelCount(10, force: false)
        
        var entries = [BarChartDataEntry]()
        
        for i in 0..<gradeData.count {
            let chartDataEntry = BarChartDataEntry(x: Double(i), y: Double(gradeData[i]))
            entries.append(chartDataEntry)
        }
        
        let dataSet = BarChartDataSet(values: entries, label: "Set 1")
        let color = UIColor(red: 230/255, green: 0, blue: 4/255, alpha: 0.75)
        dataSet.setColor(NSUIColor(cgColor: color.cgColor))
        //dataSet.drawCirclesEnabled = false
        
        let data = BarChartData(dataSet: dataSet)
        data.setValueFont(NSUIFont(name: "AvenirNext", size: 14))
        let formatter = MyValueFormatter()
        data.setValueFormatter(formatter)
        barChart.data = data
        
        self.view.addSubview(barChart)

    }
    
    func updateSubjectGraph() {
        
        
        
        
    }
    
    enum DataTimeframe {
        case daily
        case monthly
    }
    
    func createSubjectDataList(timeframe: DataTimeframe, subject: SubjectObject) -> ([[Int]], [String]) {
        
        let subjectSnapshots = AppStatus.user.getSubjectSnapshots()
        
        var subjectGradeData = [Int]()
        var subjectPercentageData = [Int]()
        
        var timeData = [String]()
        
        if timeframe == .monthly {
            
            var months = [String]()
            
            let snapshotsForSubject = subjectSnapshots.filter { $0.subjectObject == subject }
            
            let sortedSnapshots = snapshotsForSubject.sorted { $0.date > $1.date }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM YY"
            
            for snapshot in sortedSnapshots {
                
                let monthString = dateFormatter.string(from: snapshot.date)
                
                if !months.contains(monthString) {
                    months.append(monthString)
                    
                    subjectGradeData.append(snapshot.grade)
                    subjectPercentageData.append(snapshot.averagePercentageMarks)
                }
                
                // For the scale of the graph (adjust?)
                if months.count == 10 {
                    break
                }
                
            }
            
            timeData = months
            
        } else if timeframe == .daily {
            
            var days = [String]()
            
            let snapshotsForSubject = subjectSnapshots.filter { $0.subjectObject == subject }
            
            let sortedSnapshots = snapshotsForSubject.sorted { $0.date > $1.date }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "DD MMM"
            
            for snapshot in sortedSnapshots {
                
                let dayString = dateFormatter.string(from: snapshot.date)
                
                if !days.contains(dayString) {
                    days.append(dayString)
                    
                    subjectGradeData.append(snapshot.grade)
                    subjectPercentageData.append(snapshot.averagePercentageMarks)
                }
                
                // For the scale of the graph (adjust?)
                if days.count == 10 {
                    break
                }
                
            }
            
            timeData = days
            
        }
        
        return ([subjectGradeData, subjectPercentageData], timeData)
        
    }
    
    func createOverallDataList(timeframe: DataTimeframe) -> ([Int], [String]) {
        
        let overallSnapshots = AppStatus.user.getSubjectSnapshots()
        
        var overallGradeData = [Int]()
        
        var timeData = [String]()
        
        if timeframe == .monthly {
            
            var months = [String]()
            
            let sortedSnapshots = overallSnapshots.sorted { $0.date > $1.date }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM YY"
            
            for snapshot in sortedSnapshots {
                
                let monthString = dateFormatter.string(from: snapshot.date)
                
                if !months.contains(monthString) {
                    months.append(monthString)
                    
                    overallGradeData.append(snapshot.grade)
                }
                
                // For the scale of the graph (adjust?)
                if months.count == 10 {
                    break
                }
                
            }
            
            timeData = months
            
        } else if timeframe == .daily {
            
            var days = [String]()
            
            let sortedSnapshots = overallSnapshots.sorted { $0.date > $1.date }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "DD MMM"
            
            for snapshot in sortedSnapshots {
                
                let dayString = dateFormatter.string(from: snapshot.date)
                
                if !days.contains(dayString) {
                    days.append(dayString)
                    
                    overallGradeData.append(snapshot.grade)
                }
                
                // For the scale of the graph (adjust?)
                if days.count == 10 {
                    break
                }
                
            }
            
            timeData = days
            
        }
        
        return (overallGradeData, timeData)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
