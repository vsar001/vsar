//
//  StatetmentTextViewController.swift
//  AugmentedRealityTest
//
//  Created by Anonymer Eintrag on 27.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit

class StatetmentTextViewController: UIViewController {

    var textStatement : String = ""
    @IBOutlet weak var currentStatementlLabel: UILabel!
    @IBOutlet weak var editStatement: UITextField!
    @IBAction func editThis(_ sender: UIButton) {
        textStatement = editStatement.text!
        currentStatementlLabel.text = "New Statetment: \(textStatement)"
        var st = StatetmentsTextes (statetmentText: textStatement)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
