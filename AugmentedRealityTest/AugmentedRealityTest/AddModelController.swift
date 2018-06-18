//
//  AddModelController.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 18.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit


class AddModelController: UIViewController {

    @IBAction func save3DObject(_ sender: UIButton) {
        selectFolder()
       
        /*
        let userChoice = openPanel.runModal()
        switch userChoice{
        //openPanel.prompt = "Save Model"
        case .OK :
            let panelResult = openPanel.url
            if let panelResult = panelResult {
                //do something with the result
            }
        case .cancel :
            print("user cancelled")
        default:
            print("An open panel will never return anything other than OK or cancel")
        }
 */
    }
    
    func selectFolder(){
        let openPanel = NSOpenPanel()
        openPanel.title = ""
        openPanel.message = ""
        openPanel.showsResizeIndicator=true;
        openPanel.canChooseDirectories = true;
        openPanel.canChooseFiles = false;
        openPanel.allowsMultipleSelection = false;
        openPanel.canCreateDirectories = true;
        openPanel.delegate = self;
        
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if(result == NSFileHandlingPanelOKButton){
                let path = openPanel.URL!.path!
                print("selected folder is \(path)");
                self.savePref("", value: path);
            }
        }
        
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

/*
extension NSOpenPanel {
    var selectUrl: URL? {
        title = "Select Image"
        allowsMultipleSelection = false
        canChooseDirectories = true
        canChooseFiles = false
        canCreateDirectories = false
        //allowedFileTypes = ["jpg","png","pdf","pct", "bmp", "tiff"]  // to allow only images, just comment out this line to allow any file type to be selected
        return runModal() == .OK ? urls.first : nil
    }
    var selectUrls: [URL]? {
        title = "Select Images"
        allowsMultipleSelection = true
        canChooseDirectories = true
        canChooseFiles = false
        canCreateDirectories = false
        //allowedFileTypes = ["jpg","png","pdf","pct", "bmp", "tiff"]  // to allow only images, just comment out this line to allow any file type to be selected
        return runModal() == .OK ? urls : nil
    }
}
 */
