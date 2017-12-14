//
//  ViewController.swift
//  67thChofufesApp
//
//  Created by 松田尚也 on 2017/09/03.
//  Copyright © 2017年 67thChofufes. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    let saveData: UserDefaults = UserDefaults.standard
    @IBOutlet var newInfo : UIImageView!
    var ref: DatabaseReference!
    var Value : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        newInfo.isHidden = true
        ref = Database.database().reference(withPath: "InfoVer")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let val = snapshot.value{
                self.Value = val as! Int
            }
            
            var DefaultVer : Int? = self.saveData.object(forKey: "InfoVer") as? Int
            if DefaultVer == nil{ DefaultVer = 0 }
            if self.Value != DefaultVer {
                self.newInfo.isHidden = false
            }
        })
        
        if let nv = navigationController {
            let application = UIApplication.shared
            nv.setNavigationBarHidden(true, animated: true)
            application.setStatusBarHidden(true, with: true ? .slide : .none)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoadInfo(){
        self.saveData.set(self.Value, forKey: "InfoVer")
        self.newInfo.isHidden = true
    }
   

    @IBAction func LoadOfficialSite(){
        let url = NSURL(string: "http://www.chofusai.uec.ac.jp")
        UIApplication.shared.open(url! as URL)

    }
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
    }

}

