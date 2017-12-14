//
//  InfoViewController.swift
//  67thChofufesApp
//
//  Created by 松田尚也 on 2017/10/14.
//  Copyright © 2017年 67thChofufes. All rights reserved.
//

import UIKit
import Firebase

class InfoViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet var table:UITableView!
    var DataNumber: Int!
    var ref: DatabaseReference!
    var InfoListViewDatas = [InfoListViewData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataNumber = 0
        ref = Database.database().reference(withPath: "Info")

        setInitdata()
        
        table.dataSource = self
        table.delegate = self
        // Do any additional setup after loading the view.
    }

    func setInitdata() {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for (_, child) in snapshot.children.enumerated(){
                let key: String = (child as AnyObject).key
                
                let Day: String = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Day").value as! String
                let Title: String = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Title").value as! String
                let Content: String = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Content").value as! String
                
                if let keyInt = Int(key){
                    if self.DataNumber < keyInt{
                        self.DataNumber = keyInt
                    }
                }
                
                self.InfoListViewDatas.append(InfoListViewData(DayString: Day, TitleString: Title, ContextString: Content))
                print("Added " + key)
            }
            self.table.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 画面から非表示になる直前に呼ばれます。
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let nv = navigationController {
            let application = UIApplication.shared
            nv.setNavigationBarHidden(true, animated: true)
            application.setStatusBarHidden(true, with: .slide )
        }
    }
    // 画面から表示になる直前に呼ばれます。
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let nv = navigationController {
            let application = UIApplication.shared
            nv.setNavigationBarHidden(false, animated: true)
            application.setStatusBarHidden(false, with: .slide)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : InfoListViewCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoListViewCell
        cell.setCell(InfoListViewData: InfoListViewDatas[indexPath.row])
        
        cell.SetTableZero()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Twitter or HP
        /*
        if InfoListViewDatas[indexPath.row].HPURL != nil && InfoListViewDatas[indexPath.row].TwitterURL != nil{
            let alert: UIAlertController = UIAlertController(title: "団体公式ページにアクセス", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "Twitter",
                style: UIAlertActionStyle.default, handler: {
                    action in
                    
                    let url = NSURL(string: self.InfoListViewDatas[indexPath.row].TwitterURL!)
                    UIApplication.shared.open(url! as URL)
            }))
            alert.addAction(UIAlertAction(
                title: "HP",
                style: UIAlertActionStyle.default, handler: {
                    action in
                    
                    let url = NSURL(string: self.InfoListViewDatas[indexPath.row].HPURL!)
                    UIApplication.shared.open(url! as URL)
            }))
            alert.addAction(UIAlertAction(
                title: "キャンセル",
                style: UIAlertActionStyle.default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        }else
            //Twitter
            if InfoListViewDatas[indexPath.row].HPURL == nil && InfoListViewDatas[indexPath.row].TwitterURL != nil{
                let url = NSURL(string: InfoListViewDatas[indexPath.row].TwitterURL!)
                UIApplication.shared.open(url! as URL)
                
                
            }else
                //HP
                if InfoListViewDatas[indexPath.row].HPURL != nil && InfoListViewDatas[indexPath.row].TwitterURL == nil{
                    let url = NSURL(string: InfoListViewDatas[indexPath.row].HPURL!)
                    UIApplication.shared.open(url! as URL)
        }
        */
    }

}

class InfoListViewData: NSObject {
    var DayString: String
    var TitleString: String
    var ContextString: String
    
    
    init(DayString: String, TitleString: String, ContextString: String) {
        self.DayString = DayString
        self.TitleString = TitleString
        self.ContextString = ContextString
    }
    
}


class InfoListViewCell: UITableViewCell {
    @IBOutlet weak var DayText: UILabel!
    @IBOutlet weak var TitleText: UILabel!
    @IBOutlet weak var ContentText: UITextView!
    
    
    func setCell(InfoListViewData: InfoListViewData) {
        DayText.text = InfoListViewData.DayString
        TitleText.text = InfoListViewData.TitleString
        ContentText.text = InfoListViewData.ContextString
        self.ContentText.contentOffset = CGPoint(x: 0, y: -self.ContentText.contentInset.top);
        
        //Intro.setContentOffset(CGPoint.zero, animated: false)
        
    }
    func SetTableZero() {
        self.ContentText.contentOffset = CGPoint(x: 0, y: -self.ContentText.contentInset.top);
    }
    
}

