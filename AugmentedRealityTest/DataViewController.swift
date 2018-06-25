//
//  DataViewController.swift
//  AugmentedRealityTest
//
//  Created by Anonymer Eintrag on 25.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    let dataService = DataServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataService.delegate = self

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

extension DataViewController : DataServiceManagerDelegate {

    func connectedDevicesChanged(manager: DataServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            //self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }
    
    func dataChanged(manager: DataServiceManager, dataString: String) {
        OperationQueue.main.addOperation {
            switch dataString {
            //case "red":
              //  self.change(color: .red)
            //case "yellow":
              //  self.change(color: .yellow)
            default:
                NSLog("%@", "Unknown color value received: \(dataString)")
            }
        }
    }
    
}
