//
//  GrowthCurveViewController.swift
//  BabyGrowth
//
//  Created by OCEO on 6/25/19.
//  Copyright © 2019 OCEO. All rights reserved.
//

import UIKit
import Charts
import FirebaseFirestore
import Firebase

class GrowthCurveViewController: UIViewController {
    
    @IBOutlet weak var growthCurveLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var graphView: LineChartView!

    var user = User()
    
    var numbers : [Double] = [] //This is where we are going to store all the numbers. This can be a set of numbers that come from a Realm database, Core data, External API's or where ever else

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData(user: user)
        setUIToView()
        
    }
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        //here is the for loop
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
            
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Weight (LB)") //Here we convert lineChartEntry to a LineChartDataSet
        
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
        
        
        let data = LineChartData() //This is the object that will be added to the chart
        
        data.addDataSet(line1) //Adds the line to the dataSet
        
        
        graphView.data = data //finally - it adds the chart data to the chart and causes an update
        
        graphView.chartDescription?.text = "Baby Growth Graph" // Here we set the description for the graph
        
    }

    func getData(user: User){
        let userFilePath = helper.getUserFilePath(userName:  user.name!, userLastDigit: user.lastDigit!)

        let cloudRef =  Firestore.firestore().collection("growthTrackerData").document("\(userFilePath)").collection("Dates")

        cloudRef.getDocuments { (querySnapshot, err) in
            if let err = err{
                print("error: \(err.localizedDescription)")
            }else{
                for document in querySnapshot!.documents {
                    
                    print("\(document.documentID) => \(document.data())")
//
                    let myData = document.data()
                    let babyWeight = myData["Baby_Weight_(LB)"] as? String ?? ""
                    let insert = Double(babyWeight)
                    self.numbers.append(insert!)
                    
                }
                self.updateGraph()
            }
        }
        
    }
    /* Function: set all the UIs to the View */
    func setUIToView() {
        
        /* set the button (Login Button) to have a round border with the pink color.
         * Also, set its text color to the white color */
        homeButton.layer.cornerRadius = 10
        homeButton.backgroundColor = helper.buttonEnabledColorToPurple()
        homeButton.setTitleColor(UIColor.white, for: .normal)

    }
    
    /* Function: if the user clicks the home button, then the user would go the login view */
    @IBAction func homeButton_TouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "GrowthCurve_To_Login_Segue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GrowthCurve_To_Login_Segue" {
            let previewVC = segue.destination as! LoginViewController
            previewVC.user = self.user
        }

    }
    
}
