//
//  MapListViewController.swift
//  AppstudTest
//
//  Created by thejus manoharan on 09/06/2018.
//  Copyright © 2018 thejus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GooglePlaces
import GoogleMaps
import SDWebImage

class MapListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabelList: UITableView!
    let cellResueIdentifier = "ListTableViewCell"
    var searchActive : Bool = false
    let apiKey = "AIzaSyCTK5ZKQlhUoKMxpLCRzpw6Cpe1EC6C65Q"
    var searchQuery : String = ""
    var swiftyJsonVar:JSON = JSON.null
    var arrRes = [[String:AnyObject]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=bar&key=\(apiKey)"
        self.fetchPlaces(url:url)
        
        searchBar.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Fethc Places API
    
    func fetchPlaces(url:String){
        
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                self.swiftyJsonVar = JSON(responseData.result.value!)
                print(self.swiftyJsonVar)
                
                if let resData = self.swiftyJsonVar["results"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                
              
                    self.tabelList.reloadData()
            }
        }
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return arrRes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ListTableViewCell = self.tabelList.dequeueReusableCell(withIdentifier: cellResueIdentifier) as! ListTableViewCell
        var photo_ref:String = ""
        var dict = arrRes[indexPath.row]
        if let arr:NSArray = dict["photos"] as? NSArray{
            let imgData = arr.firstObject as AnyObject
            photo_ref = (imgData["photo_reference"] as? String)!
        }
        
        cell.labelTitle.text = dict["name"] as? String
        
        cell.imageBackground.sd_setImage(with: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=\(photo_ref)&key=\(apiKey)"), placeholderImage: UIImage(named: "placeholder.png"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    // MARK: - SearchBar view delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(self.searchQuery as String)&radius=1000&key=\(self.apiKey)"

        fetchPlaces(url: url)
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchQuery = searchText
//        let url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(searchText)&key=\(self.apiKey)"
//        fetchPlaces(url: url)
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.tabelList.reloadData()
    }

}
