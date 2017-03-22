//
//  myTrendsViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 1/25/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit
import Charts

class myTrendsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var subjectGradeData = [Int]()
        var xAxisValues = [String]()
        
        
        //this is still highly in development, not functional at all
        if let user = AppStatus.loggedInUser {
            let assessments = user.assessments
            
            //let subjectSnapshots = user.subjectGradeSnapshots.filter { $0.subject == .BusinessManagement }
            
            /*
            for snapshot in subjectSnapshots {
                
                subjectGradeData.append(snapshot.grade)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM"
                
                xAxisValues.append(dateFormatter.string(from: snapshot.date))
                
            }
            */
            
        }
        
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
