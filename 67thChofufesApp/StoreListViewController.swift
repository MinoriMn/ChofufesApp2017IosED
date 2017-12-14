//
//  StoreListViewController.swift
//  67thChofufesApp
//
//  Created by 松田尚也 on 2017/09/03.
//  Copyright © 2017年 67thChofufes. All rights reserved.
//

import UIKit
import Firebase
import NullSafe


class StoreListViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    //ボード上のTabelView
    @IBOutlet var table:UITableView!
    @IBOutlet var typeName: UILabel!
    
    var storeListViewDatas = [StoreListViewData]()
    var storeListViewDatasSaved = [StoreListViewData]()
    var ref: DatabaseReference!
    var refStoreType: DatabaseReference!
    var DataNumber: Int!
    let saveData: UserDefaults = UserDefaults.standard
    var storeImage: [UIImage] = []
    var storeTypes: [storeType] = []
    var storeTypeIndex: Int = 0
    
    struct storeType {
        var Name : String = "Error"
        var Code : Int = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "StoreList")
        refStoreType = Database.database().reference(withPath: "StoreType")
        
        DataNumber = 0
        setInitdata()
        
        //このクラスをデータの管理に設定
        
        table.dataSource = self
        table.delegate = self
        // Do any additional setup after loading the view.
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInitdata() {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference().child("StoreImage")
        
        refStoreType.observeSingleEvent(of: .value, with: {(snapshot) in
             for (_, child) in snapshot.children.enumerated(){
                let key: String = (child as AnyObject).key

                var StoreType: storeType = storeType()
                if let Name: String = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Name").value as? String{
                    StoreType.Name = Name
                }
                if let Code: Int = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Code").value as? Int{
                    StoreType.Code = Code
                }
                
                self.storeTypes.append(StoreType)
            }
        })
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        
            for (_, child) in snapshot.children.enumerated(){
                let key: String = (child as AnyObject).key
            
                let storeOrga: String = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "storeOrga").value as! String
                let storeName: String = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "storeName").value as! String
                let Intro: String = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "introduction").value as! String
                let type: Int? = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Type").value as? Int
                
                let Twitter : String?
                if snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Twitter").exists() == true{
                    Twitter = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Twitter").value as? String
                }else{
                    Twitter = nil
                }
                
                let HP : String?
                if snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "HP").exists() == true{
                    HP = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "HP").value as? String
                }else{
                    HP = nil
                }
                
                let Icon : String?
                if snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Icon").exists() == true{
                    Icon = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Icon").value as? String
                }else{
                    Icon = nil
                }
                
                var StoreImage : UIImage?
                var DefaultVer : Int? = self.saveData.object(forKey: "StoreImageVer" + storeName) as? Int
                if DefaultVer == nil{ DefaultVer = 0 }
                
                if DefaultVer! != snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "IconVer").value as! Int{
                    if Icon != nil{
                        let storeStorageRef = storageRef.child(Icon! + ".jpg")
                        storeStorageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                            let number = Int(key)!
                            if (error != nil) {
                                // Uh-oh, an error occurred!
                                print("Error " + key)
                                self.storeListViewDatas[number - 1].setStoreImage(StoreImage: nil)
                            } else {
                                // Data for "images/island.jpg" is returned
                                print("Success " + number.description)
                                StoreImage = UIImage(data: data!)
                                let storeListViewData = self.storeListViewDatas[number - 1]
                                storeListViewData.setStoreImage(StoreImage: StoreImage)
                                self.saveData.set(UIImagePNGRepresentation(StoreImage!), forKey: "StoreImage" + storeName)
                                
                            }
                            self.saveData.set(snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "IconVer").value as! Int, forKey: "StoreImageVer" + storeName)
                            self.table.reloadData()
                        }
                    }

                }else{
                    print("Load " + key)
                    
                    if let Image = self.saveData.object(forKey: "StoreImage" + storeName){
                        StoreImage = UIImage(data: Image as! Data)
                    }else{
                        StoreImage = nil
                    }
                   
                }
                self.DataNumber = Int(key)
                
                self.storeListViewDatas.append(StoreListViewData(StoreOrgaString: storeOrga, StoreNameString: storeName, IntroString: Intro, TwitterURL: Twitter, HPURL: HP, StoreImage: StoreImage, type: type))
                self.storeListViewDatasSaved.append(StoreListViewData(StoreOrgaString: storeOrga, StoreNameString: storeName, IntroString: Intro, TwitterURL: Twitter, HPURL: HP, StoreImage: StoreImage, type: type))
                print("Added " + key)
                
            }
             self.table.reloadData()
        }
        )
        
        print("" + DataNumber.description)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : StoreListViewCell = tableView.dequeueReusableCell(withIdentifier: "SLVCell") as! StoreListViewCell
        cell.setCell(storeListViewData: storeListViewDatas[indexPath.row])
        
        if storeListViewDatas[indexPath.row].HPURL  == nil{
            cell.HPSetHide()
        }else{
            cell.HPSetImage()
        }
        
        if storeListViewDatas[indexPath.row].TwitterURL == nil{
            cell.TwitterSetHide()
        }else{
            cell.TwitterSetImage()
        }
        cell.SetTableZero()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Twitter or HP
        if storeListViewDatas[indexPath.row].HPURL != nil && storeListViewDatas[indexPath.row].TwitterURL != nil{
            let alert: UIAlertController = UIAlertController(title: "団体公式ページにアクセス", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "Twitter",
                style: UIAlertActionStyle.default, handler: {
                    action in
                    
                    let url = NSURL(string: self.storeListViewDatas[indexPath.row].TwitterURL!)
                    UIApplication.shared.open(url! as URL)
                }))
            alert.addAction(UIAlertAction(
                title: "HP",
                style: UIAlertActionStyle.default, handler: {
                    action in
                    
                    let url = NSURL(string: self.storeListViewDatas[indexPath.row].HPURL!)
                    UIApplication.shared.open(url! as URL)
            }))
            alert.addAction(UIAlertAction(
                title: "キャンセル",
                style: UIAlertActionStyle.default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        }else
            //Twitter
            if storeListViewDatas[indexPath.row].HPURL == nil && storeListViewDatas[indexPath.row].TwitterURL != nil{
                let url = NSURL(string: storeListViewDatas[indexPath.row].TwitterURL!)
                UIApplication.shared.open(url! as URL)
                
                
            }else
                //HP
                if storeListViewDatas[indexPath.row].HPURL != nil && storeListViewDatas[indexPath.row].TwitterURL == nil{
                    let url = NSURL(string: storeListViewDatas[indexPath.row].HPURL!)
                    UIApplication.shared.open(url! as URL)
        }

    }
    
    func tableView(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        print("Called")
        let myCell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "SLVCell",for: indexPath as IndexPath) as UITableViewCell
        
        myCell?.isHidden = false
        
        if storeTypeIndex == 0{return myCell!}
        if storeTypes[storeTypeIndex-1].Code != 0{
            if storeTypes[storeTypeIndex-1].Code != storeListViewDatas[indexPath.row].type{
            myCell?.isHidden = true
            }
        }
        
        return myCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //let myCell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "SLVCell",for: indexPath as IndexPath) as UITableViewCell
        if storeTypeIndex == 0{return 150}
        if storeTypes[storeTypeIndex-1].Code != 0{
            if storeTypes[storeTypeIndex-1].Code != storeListViewDatas[indexPath.row].type{
                return 0
            }
        }
            return 150
        
    }
    
    
    @IBAction func RightButton(){
        if storeTypes.count == 0{return}
        storeTypeIndex = (storeTypeIndex + 1) % (storeTypes.count+1)
        print("RightButton")
        if storeTypeIndex != 0{
            typeName.text = storeTypes[storeTypeIndex-1].Name
        }else{
            typeName.text = "オール"
        }
        /*
        for i in 0...DataNumber-1{
            let myCell:UITableViewCell? = table.dequeueReusableCell(withIdentifier: "SLVCell",for: IndexPath(row: i, section: 0) as IndexPath) as UITableViewCell
            if storeType != storeListViewDatas[i].type{
                myCell?.isHidden = true
            }else{
                myCell?.isHidden = false
            }
        }*/
        table.reloadData()
    }
    
    @IBAction func LeftButton(){
        if storeTypes.count == 0{return}
        storeTypeIndex = (storeTypeIndex + storeTypes.count - 1) % (storeTypes.count+1)
        print("LeftButton")
        if storeTypeIndex != 0{
            typeName.text = storeTypes[storeTypeIndex-1].Name
        }else{
            typeName.text = "オール"
        }
        /*
        for i in 0...DataNumber-1{
            let myCell:UITableViewCell? = table.dequeueReusableCell(withIdentifier: "SLVCell",for: IndexPath(row: i, section: 0) as IndexPath) as UITableViewCell
           
            myCell?.isHidden = true
            
        }*/
        table.reloadData()
    }
    
}

class StoreListViewData: NSObject {
    var StoreOrgaString: String
    var StoreNameString: String
    var IntroString: String
    var TwitterURL: String?
    var HPURL: String?
    var StoreImage: UIImage?
    var type: Int = 1
    
    init(StoreOrgaString: String, StoreNameString: String, IntroString: String, TwitterURL: String?, HPURL: String?, StoreImage: UIImage?, type: Int?) {
        self.StoreOrgaString = StoreOrgaString
        self.StoreNameString = StoreNameString
        self.IntroString = IntroString
        self.TwitterURL = TwitterURL
        self.HPURL = HPURL
        self.StoreImage = StoreImage
        if let typenum = type{
            self.type = typenum
        }
    }
    
    func setStoreImage(StoreImage : UIImage?) {
        self.StoreImage = StoreImage
    }
}

class StoreListViewCell: UITableViewCell {
    @IBOutlet weak var StoreOrga: UILabel!
    @IBOutlet weak var StoreName: UILabel!
    @IBOutlet weak var Intro: UITextView!
    @IBOutlet weak var StoreImage: UIImageView!
    @IBOutlet weak var Twitter: UIImageView!
    @IBOutlet weak var HP: UIImageView!
    
    func setCell(storeListViewData: StoreListViewData) {
        StoreOrga.text = storeListViewData.StoreOrgaString
        StoreName.text = storeListViewData.StoreNameString
        Intro.text = storeListViewData.IntroString
        self.Intro.contentOffset = CGPoint(x: 0, y: -self.Intro.contentInset.top);
        
        if storeListViewData.StoreImage != nil{
        StoreImage.image = storeListViewData.StoreImage
           
        }else{
        StoreImage.image = UIImage(named: "noImage")
            
        }
        
        //Intro.setContentOffset(CGPoint.zero, animated: false)

    }
    func SetTableZero() {
        self.Intro.contentOffset = CGPoint(x: 0, y: -self.Intro.contentInset.top);
    }
    
    func HPSetHide() {
        HP.image = UIImage(named: "White")!
    }
    
    func HPSetImage() {
        HP.image = UIImage(named: "公式サイト")!
    }
    
    func TwitterSetHide() {
        Twitter.image = UIImage(named: "White")!
    }
    
    func TwitterSetImage() {
        Twitter.image = UIImage(named: "公式Twitter")!
    }
    
}
