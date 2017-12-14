//
//  TimeTableDayOneViewController.swift
//  67thChofufesApp
//
//  Created by 松田尚也 on 2017/09/15.
//  Copyright © 2017年 67thChofufes. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class TimeTableDayOneViewController: UIViewController, IndicatorInfoProvider {

    var itemInfo: IndicatorInfo = "1日目"
    let Day : String = "d1"
    @IBOutlet var TimeTable: UIImageView?
    @IBOutlet var VerText: UILabel?
    var ref: DatabaseReference!
    let saveData: UserDefaults = UserDefaults.standard
    var TableImage : UIImage?
    var LastVer: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.saveData.object(forKey: "TableVer" + Day) == nil{
            self.saveData.set(1, forKey: "TableVer" + self.Day)
        }
        
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference().child("TimeTable")
        
        ref = Database.database().reference(withPath: "TimeTable")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            self.LastVer = snapshot.childSnapshot(forPath: self.Day).childSnapshot(forPath: "Ver").value as! Int
            let date = snapshot.childSnapshot(forPath: self.Day).childSnapshot(forPath: "Date").value as? String
            self.VerText?.text = "Ver." + (self.LastVer.description) + " " + date!
            
            let ThisVer : Int = (self.saveData.object(forKey: "TableVer" + self.Day) as! Int)
            print(self.LastVer.description + " " + ThisVer.description)
            if self.LastVer != ThisVer{
                //新規データor最新ヴァージョン
                let storeStorageRef = storageRef.child(self.Day + ".png")
                storeStorageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                        print("Error " + self.Day)
                        
                    } else {
                        // Data for "images/island.jpg" is returned
                        print("Success " + self.Day)
                        self.TableImage = UIImage(data: data!)
                        self.TimeTable?.image = self.TableImage
                        self.saveData.set(UIImagePNGRepresentation(self.TableImage!), forKey: "TableImage" + self.Day)
                        
                    }
                    self.saveData.set(self.LastVer, forKey: "TableVer" + self.Day)
                }
            }else{
                //既存
                print("Load " + self.Day)
                
                if let Image = self.saveData.object(forKey: "TableImage" + self.Day){
                    print("Loaded")
                    self.TableImage = UIImage(data: Image as! Data)
                    self.TimeTable?.image = self.TableImage
                }else{
                    print("FailedByNil")
                    self.TableImage = nil
                }
            }
            
        })
        
        
    }
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }// Do any additional setup after loading the view.
    

}
