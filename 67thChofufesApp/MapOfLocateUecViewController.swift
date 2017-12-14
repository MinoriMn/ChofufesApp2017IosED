//
//  MapOfLocateUecViewController.swift
//  67thChofufesApp
//
//  Created by 松田尚也 on 2017/09/14.
//  Copyright © 2017年 67thChofufes. All rights reserved.
//

import Foundation
import GoogleMaps
import Firebase
import CoreLocation

class MapOfLocateUecViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    var ref: DatabaseReference!
    var lm: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 35.657026, longitude: 139.542691, zoom: 16.3)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate=self
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        //現在位置
        mapView.isMyLocationEnabled = true
        mapView.accessibilityElementsHidden = false
       
        view = mapView
        
        // Creates a marker in the center of the map.
        
        ref = Database.database().reference(withPath: "MapLocate")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            for (_, child) in snapshot.children.enumerated(){
                let marker = GMSMarker()
                let key: String = (child as AnyObject).key
                let Type: Int = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Type").value as! Int
                
                let Latitude: Float = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Latitude").value as! Float
                let Longitude: Float = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Longitude").value as! Float
                marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(Latitude), longitude: CLLocationDegrees(Longitude))
               
                marker.title = snapshot.childSnapshot(forPath: key).childSnapshot(forPath: "Title").value as? String
                
                switch Type{
                case 0:
                    marker.icon = UIImage(named: "pin0")
                    marker.snippet = "タップでマップ起動"
                    break
                case 1:
                    marker.icon = UIImage(named: "pin1")
                    break
                case 2:
                    marker.icon = UIImage(named: "pin2")
                    break
                case 3:
                    marker.icon = UIImage(named: "pin3")
                    break
                case 4:
                    marker.icon = UIImage(named: "pin4")
                    break
                case 5:
                    marker.icon = UIImage(named: "pin5")
                    break
                case 6:
                    marker.icon = UIImage(named: "pin6")
                    break
                default:
                    break
                }
                marker.map = mapView
            }
            
        })
        
        //デバッグ用
        /*
        let position = CLLocationCoordinate2D(latitude: 35.655509, longitude: 139.5437)
        let marker = GMSMarker(position: position)
        marker.title = "デバッグ用"
        marker.snippet = "タップでマップ起動"
        marker.map = mapView
         */
        
        print("load finished")
        
    }
    
    @objc(mapView:didTapInfoWindowOfMarker:) func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if  marker.snippet != nil{
            let longitude = marker.position.longitude
            let latitude = marker.position.latitude
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:
                "comgooglemaps://?center=\(latitude),\(longitude)&zoom=14")!)
            } else {
            print("Can't use comgooglemaps://");
            let daddr = NSString(format: "%f,%f", latitude, longitude)
            
            let urlString = "http://maps.apple.com/?daddr=\(daddr)&dirflg=w"
            
            let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            let url = NSURL(string: encodedUrl)!
            
            UIApplication.shared.open(url as URL)
            }
        }
        //print("You tapped " + marker.position.latitude.description)
    }
    
    // 画面から非表示になる直前に呼ばれます。
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let nv = navigationController {
            let application = UIApplication.shared
            nv.setNavigationBarHidden(true, animated: true)
            application.setStatusBarHidden(true, with: .slide)
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
}
