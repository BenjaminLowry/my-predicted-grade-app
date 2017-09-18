//
//  myTrendsViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 1/25/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit
import Charts

class myTrendsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var bodyView: UIView!
    
    @IBOutlet weak var overallTimeframeTextField: UITextField!
    
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var subjectTimeframeTextField: UITextField!
    
    @IBOutlet weak var subjectGradesLabel: UILabel!
    @IBOutlet weak var averagePercentagesLabel: UILabel!
    
    @IBOutlet weak var insufficientDataLabel1: UILabel!
    @IBOutlet weak var insufficientDataLabel2: UILabel!
    @IBOutlet weak var insufficientDataLabel3: UILabel!
    
    var overallTimeframePickerView = UIPickerView()
    
    var subjectPickerView = UIPickerView()
    var subjectTimeframePickerView = UIPickerView()
    
    var overallGraph: BarChartView?
    
    var subjectGradesGraph: BarChartView?
    var averagePercentagesGraph: BarChartView?
    
    var timeframePickerData = ["Daily", "Monthly"]
    
    var subjectPickerData = [String]()
    
    var maxDataPoints = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializePickerViewToolBar()
        
        // Populate subject picker data
        if subjectPickerData.isEmpty {
            for subject in AppStatus.user.subjects {
                subjectPickerData.append(subject.toString())
            }
        }
        
        updateOverallGraph(gradeData: [], timeData: [])
        updateSubjectGraph(subjectGradeData: [], averagePercentageData: [], timeData: [], subject: .init(subject: .Default, isHL: false))
        
        if UIScreen.main.bounds.width == 320 { // iPhone 5, 5s, SE
            maxDataPoints = 7
        } else if UIScreen.main.bounds.width == 375 { // iPhone 6, 6s, 7
            maxDataPoints = 9
        } else if UIScreen.main.bounds.width == 414 { // iPhone 6 Plus, 7 Plus
            maxDataPoints = 10
        }
        
        overallTimeframePickerView.delegate = self
        overallTimeframePickerView.dataSource = self
        
        subjectPickerView.delegate = self
        subjectPickerView.dataSource = self
        
        subjectTimeframePickerView.delegate = self
        subjectTimeframePickerView.dataSource = self
        
        overallTimeframeTextField.inputView = overallTimeframePickerView
        
        subjectTextField.inputView = subjectPickerView
        subjectTimeframeTextField.inputView = subjectTimeframePickerView
        
        overallTimeframeTextField.delegate = self
        
        subjectTextField.delegate = self
        subjectTimeframeTextField.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Fit the content to the screen
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1200)
        bodyView.frame.size.width = UIScreen.main.bounds.width
        
        // Update graphs upon reappear
        if subjectTextField.text != "" && subjectTimeframeTextField.text != "" {
            
            let (subjectGradeData, averagePercentageData, timeData, subject) = sendSubjectInfoToGraphs()
            
            updateSubjectGraph(subjectGradeData: subjectGradeData, averagePercentageData: averagePercentageData, timeData: timeData, subject: subject)
            
        }
        
        if overallTimeframeTextField.text != "" {
            
            let (overallGradeData, timeData) = sendOverallInfoToGraph(fromRow: 0)
            
            updateOverallGraph(gradeData: overallGradeData, timeData: timeData)
            
        }
        
    }
    
    // MARK: - UIPickerView Delegate Funcs
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        if pickerView == subjectPickerView { // Should return a list of subjects
            return subjectPickerData.count
        } else { // Both the subject and overall time frame pickers have same data
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
            
            insufficientDataLabel1.isHidden = true
            
            overallTimeframeTextField.text = timeframePickerData[row]
            
            let (overallGradeData, timeData) = sendOverallInfoToGraph(fromRow: row)
            
            updateOverallGraph(gradeData: overallGradeData, timeData: timeData)
            
        } else {
            
            insufficientDataLabel2.isHidden = true
            insufficientDataLabel3.isHidden = true
            
            if pickerView == subjectTimeframePickerView {
                subjectTimeframeTextField.text = timeframePickerData[row]
            } else if pickerView == subjectPickerView {
                subjectTextField.text = subjectPickerData[row]
            }
            
            if subjectTextField.text != "" && subjectTimeframeTextField.text != "" {
                
                let (subjectGradeData, averagePercentageData, timeData, subject) = sendSubjectInfoToGraphs()
                
                updateSubjectGraph(subjectGradeData: subjectGradeData, averagePercentageData: averagePercentageData, timeData: timeData, subject: subject)
                
            }
            
        }
        
    }
    
    // MARK: - UITextField Delegate Funcs
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == overallTimeframeTextField {
            if textField.text != "" {
                if textField.text == "Daily" {
                    overallTimeframePickerView.selectRow(0, inComponent: 0, animated: true)
                } else if textField.text == "Monthly" {
                    overallTimeframePickerView.selectRow(1, inComponent: 0, animated: true)
                }
            } else {
                textField.text = timeframePickerData[0]
            }
            
            let (overallGradeData, timeData) = sendOverallInfoToGraph(fromRow: 0)
            
            updateOverallGraph(gradeData: overallGradeData, timeData: timeData)
            
        } else if textField == subjectTimeframeTextField {
            
            if textField.text != "" {
                if textField.text == "Daily" {
                    subjectTimeframePickerView.selectRow(0, inComponent: 0, animated: true)
                } else if textField.text == "Monthly" {
                    subjectTimeframePickerView.selectRow(1, inComponent: 0, animated: true)
                }
            } else {
                textField.text = timeframePickerData[0]
            }
            
            if subjectTextField.text != "" && subjectTimeframeTextField.text != "" {
                
                let (subjectGradeData, averagePercentageData, timeData, subject) = sendSubjectInfoToGraphs()
                
                updateSubjectGraph(subjectGradeData: subjectGradeData, averagePercentageData: averagePercentageData, timeData: timeData, subject: subject)
                
            }
            
        } else { // Subject text field
            
            if textField.text == "" {
                textField.text = subjectPickerData[0]
            } else {
                for subject in AppStatus.user.subjects {
                    
                    if subject.toString() == textField.text {
                        subjectPickerView.selectRow(subjectPickerData.index(of: textField.text!)!, inComponent: 0, animated: true)
                    }
                    
                }
            }
            
            if subjectTextField.text != "" && subjectTimeframeTextField.text != "" {
                
                let (subjectGradeData, averagePercentageData, timeData, subject) = sendSubjectInfoToGraphs()
                
                updateSubjectGraph(subjectGradeData: subjectGradeData, averagePercentageData: averagePercentageData, timeData: timeData, subject: subject)
                
            }
        }
        
    }
    
    // MARK: - Graph Updating Funcs
    
    func sendOverallInfoToGraph(fromRow row: Int) -> ([Int], [String]){
        
        var overallGradeData = [Int]()
        var timeData = [String]()
        
        if timeframePickerData[row] == "Monthly" {
            let data = createOverallDataList(timeframe: .monthly)
            if data.0.count < 2 {
                insufficientDataLabel1.isHidden = false
            }
            overallGradeData = data.0
            timeData = data.1
        } else if timeframePickerData[row] == "Daily" {
            let data = createOverallDataList(timeframe: .daily)
            if data.0.count < 2 {
                insufficientDataLabel1.isHidden = false
            }
            overallGradeData = data.0
            timeData = data.1
        }

        return (overallGradeData, timeData)
    }
    
    func sendSubjectInfoToGraphs() -> ([Int], [Int], [String], SubjectObject) {
        
        var subject = SubjectObject(subject: .Default, isHL: false)
        
        for userSubject in AppStatus.user.subjects {
            
            if userSubject.toString() == subjectTextField.text {
                subject = userSubject
            }
            
        }
        
        var subjectGradeData = [Int]()
        var averagePercentageData = [Int]()
        var timeData = [String]()
        
        if subjectTimeframeTextField.text == "Monthly" {
            let data = createSubjectDataList(timeframe: .monthly, subject: subject)
            if data.0[0].count < 2 {
                insufficientDataLabel2.isHidden = false
                insufficientDataLabel3.isHidden = false
            }
            subjectGradeData = data.0[0]
            averagePercentageData = data.0[1]
            timeData = data.1
        } else if subjectTimeframeTextField.text == "Daily" {
            let data = createSubjectDataList(timeframe: .daily, subject: subject)
            if data.0[0].count < 2 {
                insufficientDataLabel2.isHidden = false
                insufficientDataLabel3.isHidden = false
            }
            subjectGradeData = data.0[0]
            averagePercentageData = data.0[1]
            timeData = data.1
        }
        
        return (subjectGradeData, averagePercentageData, timeData, subject)
        
    }
    
    func updateOverallGraph(gradeData: [Int], timeData: [String]) {
        
        if let graph = overallGraph {
            graph.removeFromSuperview()
        }
        
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
        barChart.frame = CGRect(x: 10, y: 125, width: self.view.frame.width - 20, height: 240)
        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.setLabelCount(gradeData.count, force: false)
        xAxis.avoidFirstLastClippingEnabled = false
        
        var entries = [BarChartDataEntry]()
        
        // If the label is up, create an empty frame graph
        if insufficientDataLabel1.isHidden == true {
            for i in 0..<gradeData.count {
                let chartDataEntry = BarChartDataEntry(x: Double(i), y: Double(gradeData[i]))
                entries.append(chartDataEntry)
            }
        }
        
        let dataSet = BarChartDataSet(values: entries, label: "Set 1")
        let color = UIColor(red: 230/255, green: 0, blue: 4/255, alpha: 0.75)
        dataSet.setColor(NSUIColor(cgColor: color.cgColor))
        
        let data = BarChartData(dataSet: dataSet)
        data.setValueFont(NSUIFont(name: "AvenirNext", size: 14))
        let formatter = MyValueFormatter()
        data.setValueFormatter(formatter)
        barChart.data = data
        
        overallGraph = barChart
        
        bodyView.addSubview(overallGraph!)

    }
    
    func updateSubjectGraph(subjectGradeData: [Int], averagePercentageData: [Int], timeData: [String], subject: SubjectObject) {
        
        /* Subject Grades */
        
        if let graph = subjectGradesGraph {
            graph.removeFromSuperview()
        }
        
        let barChartSG = BarChartView()
        barChartSG.legend.enabled = false
        barChartSG.chartDescription?.enabled = false
        barChartSG.drawGridBackgroundEnabled = false
        barChartSG.highlightPerTapEnabled = false
        barChartSG.highlightPerDragEnabled = false
        
        let axisFormatter = MyAxisFormatter()
        axisFormatter.changeAxisValues(to: timeData)
        
        barChartSG.xAxis.drawGridLinesEnabled = false
        barChartSG.xAxis.valueFormatter = axisFormatter
        
        if subject.subject == .TheoryOfKnowledge || subject.subject == .ExtendedEssay {
            let yAxisFormatter = MyTOKEEAxisFormatter()
            barChartSG.leftAxis.valueFormatter = yAxisFormatter
            barChartSG.leftAxis.axisMaximum = 5.4
            barChartSG.leftAxis.axisMinimum = 0.6
            barChartSG.leftAxis.setLabelCount(5, force: false)
        } else {
            
            barChartSG.leftAxis.axisMaximum = 7.5
            barChartSG.leftAxis.axisMinimum = 0.0
            
        }
        
        barChartSG.rightYAxisRenderer.axis?.drawLabelsEnabled = false
        barChartSG.rightYAxisRenderer.axis?.drawGridLinesEnabled = false
        barChartSG.leftYAxisRenderer.axis?.drawGridLinesEnabled = false
        barChartSG.scaleXEnabled = false
        barChartSG.scaleYEnabled = false
        barChartSG.frame = CGRect(x: 10, y: 581, width: self.view.frame.width - 20, height: 240)
        let xAxisSG = barChartSG.xAxis
        xAxisSG.labelPosition = .bottom
        xAxisSG.setLabelCount(subjectGradeData.count, force: false)
        
        var entriesSG = [BarChartDataEntry]()
        
        if insufficientDataLabel2.isHidden == true {
            // Adjust data to work for TOK and EE
            if subject.subject == .TheoryOfKnowledge || subject.subject == .ExtendedEssay {
                for i in 0..<subjectGradeData.count {
                    let chartDataEntry = BarChartDataEntry(x: Double(i), y: Double(subjectGradeData[i]))
                    entriesSG.append(chartDataEntry)
                }
            } else {
                for i in 0..<subjectGradeData.count {
                    let chartDataEntry = BarChartDataEntry(x: Double(i), y: Double(subjectGradeData[i]))
                    entriesSG.append(chartDataEntry)
                }
                
            }
        }
        
        let dataSetSG = BarChartDataSet(values: entriesSG, label: "Set 1")
        var color = UIColor(red: 230/255, green: 0, blue: 4/255, alpha: 0.75)
        
        if let subjectColor = AppStatus.user.colorPreferences[subject] {
            color = subjectColor
        }
        
        dataSetSG.setColor(NSUIColor(cgColor: color.cgColor))
        subjectGradesLabel.textColor = color
        
        let dataSG = BarChartData(dataSet: dataSetSG)
        dataSG.setValueFont(NSUIFont(name: "AvenirNext", size: 14))
        
        if subject.subject == .TheoryOfKnowledge || subject.subject == .ExtendedEssay {
            let formatter = MyTOKEEValueFormatter()
            dataSG.setValueFormatter(formatter)
        } else {
            let formatter = MyValueFormatter()
            dataSG.setValueFormatter(formatter)
        }
        
        barChartSG.data = dataSG
        
        subjectGradesGraph = barChartSG
        
        bodyView.addSubview(subjectGradesGraph!)
        
        /* Average Percentage Marks */
        
        if let graph = averagePercentagesGraph {
            graph.removeFromSuperview()
        }
        
        let barChartAP = BarChartView()
        barChartAP.legend.enabled = false
        barChartAP.chartDescription?.enabled = false
        barChartAP.drawGridBackgroundEnabled = false
        barChartAP.highlightPerTapEnabled = false
        barChartAP.highlightPerDragEnabled = false
        
        barChartAP.xAxis.drawGridLinesEnabled = false
        barChartAP.xAxis.valueFormatter = axisFormatter // axisFormatter taken from above
        
        barChartAP.leftAxis.axisMaximum = 105.0
        barChartAP.leftAxis.axisMinimum = 0.0
        barChartAP.rightYAxisRenderer.axis?.drawLabelsEnabled = false
        barChartAP.rightYAxisRenderer.axis?.drawGridLinesEnabled = false
        barChartAP.leftYAxisRenderer.axis?.drawGridLinesEnabled = false
        barChartAP.scaleXEnabled = false
        barChartAP.scaleYEnabled = false
        barChartAP.frame = CGRect(x: 10, y: 902, width: self.view.frame.width - 20, height: 240)
        let xAxisAP = barChartAP.xAxis
        xAxisAP.labelPosition = .bottom
        xAxisAP.setLabelCount(averagePercentageData.count, force: false)
        
        var entriesAP = [BarChartDataEntry]()
        
        if insufficientDataLabel3.isHidden == true {
            for i in 0..<averagePercentageData.count {
                let chartDataEntry = BarChartDataEntry(x: Double(i), y: Double(averagePercentageData[i]))
                entriesAP.append(chartDataEntry)
            }
        }
        
        let dataSetAP = BarChartDataSet(values: entriesAP, label: "Set 1")
        dataSetAP.setColor(NSUIColor(cgColor: color.cgColor)) // Color taken from above
        averagePercentagesLabel.textColor = color
        
        let dataAP = BarChartData(dataSet: dataSetAP)
        dataAP.setValueFont(NSUIFont(name: "AvenirNext", size: 14))
        let formatter = MyValueFormatter()
        dataAP.setValueFormatter(formatter)
        barChartAP.data = dataAP
        
        averagePercentagesGraph = barChartAP
        
        bodyView.addSubview(averagePercentagesGraph!)
        
    }
    
    enum DataTimeframe {
        case daily
        case monthly
    }
    
    // MARK: - Data Creation Funcs
    
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
            dateFormatter.dateFormat = "MMMYY"
            
            for snapshot in sortedSnapshots {
                
                let monthString = dateFormatter.string(from: snapshot.date)
                
                if !months.contains(monthString) {
                    months.append(monthString)
                    
                    subjectGradeData.append(snapshot.grade)
                    subjectPercentageData.append(snapshot.averagePercentageMarks)
                }
                
                // For the scale of the graph
                if months.count == maxDataPoints {
                    break
                }
                
            }
            
            timeData = months
            
        } else if timeframe == .daily {
            
            var days = [String]()
            
            let snapshotsForSubject = subjectSnapshots.filter { $0.subjectObject == subject }
            
            let sortedSnapshots = snapshotsForSubject.sorted { $0.date > $1.date }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMdd"
            
            for snapshot in sortedSnapshots {
                
                var dayString = dateFormatter.string(from: snapshot.date)
                
                // If string is like "Sep02", make it "Sep2"
                if dayString[3] == "0" {
                    if let index = dayString.characters.index(of: "0") {
                        dayString.remove(at: index)
                    }
                }
                
                if !days.contains(dayString) {
                    days.append(dayString)
                    
                    subjectGradeData.append(snapshot.grade)
                    subjectPercentageData.append(snapshot.averagePercentageMarks)
                }
                
                // For the scale of the graph
                if days.count == maxDataPoints {
                    break
                }
                
            }
            
            timeData = days
            
        }
        
        return ([subjectGradeData.reversed(), subjectPercentageData.reversed()], timeData.reversed())
        
    }
    
    func createOverallDataList(timeframe: DataTimeframe) -> ([Int], [String]) {
        
        let overallSnapshots = AppStatus.user.getOverallGradeSnapshots()
        
        var overallGradeData = [Int]()
        
        var timeData = [String]()
        
        if timeframe == .monthly {
            
            var months = [String]()
            
            let sortedSnapshots = overallSnapshots.sorted { $0.date > $1.date }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMYY"
            
            for snapshot in sortedSnapshots {
                
                // Data points under 24 will not be displayed
                if snapshot.grade < 24 {
                    continue
                }
                
                let monthString = dateFormatter.string(from: snapshot.date)
                
                if !months.contains(monthString) {
                    months.append(monthString)
                    
                    overallGradeData.append(snapshot.grade)
                }
                
                // For the scale of the graph
                if months.count == maxDataPoints {
                    break
                }
                
            }
            
            timeData = months
            
        } else if timeframe == .daily {
            
            var days = [String]()
            
            let sortedSnapshots = overallSnapshots.sorted { $0.date > $1.date }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMdd"
            
            for snapshot in sortedSnapshots {
                
                // Data points under 24 will not be displayed
                if snapshot.grade < 24 {
                    continue
                }
                
                var dayString = dateFormatter.string(from: snapshot.date)
                
                // If string is like "Sep02", make it "Sep2"
                if dayString[3] == "0" {
                    if let index = dayString.characters.index(of: "0") {
                        dayString.remove(at: index)
                    }
                }
                
                if !days.contains(dayString) {
                    days.append(dayString)
                    
                    overallGradeData.append(snapshot.grade)
                }
                
                // For the scale of the graph
                if days.count == maxDataPoints {
                    break
                }
                
            }
            
            timeData = days
            
        }
        
        return (overallGradeData.reversed(), timeData.reversed())
        
    }
    
    // MARK: - UI Setup
    
    func initializePickerViewToolBar(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = .default
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        doneButton.tintColor = AppStatus.themeColor
        
        toolBar.setItems([flexSpace,doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        overallTimeframeTextField.inputAccessoryView = toolBar
        
        subjectTextField.inputAccessoryView = toolBar
        subjectTimeframeTextField.inputAccessoryView = toolBar
        
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
