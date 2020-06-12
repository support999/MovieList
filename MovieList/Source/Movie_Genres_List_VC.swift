//
//  Movie_Genres_List_VC.swift
//  MovieList
//
//  Created by Amit Saxena on 11/06/20.
//  Copyright © 2020 Amit Saxena. All rights reserved.
//

import UIKit
import MBProgressHUD

class Movie_Genres_List_Table_Cell: UITableViewCell{
    @IBOutlet weak var lbl_Movie_Genres_Name: UILabel!
}

class Movie_Genres_List_VC: UIViewController {
    
    @IBOutlet weak var Movie_Genres_List_Table: UITableView!
    
    var arr_genres = [[String:Any]](){
        didSet{
            self.Movie_Genres_List_Table.reloadData()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
     return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI(){
        self.Get_Movie_Genres_List()
    }
}

//************----*****************-------**********************-------**********************-------****************
//************---- TableView And Datasource
//************----*****************-------**********************-------**********************-------****************
extension Movie_Genres_List_VC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:Movie_Genres_List_Table_Cell = self.Movie_Genres_List_Table.dequeueReusableCell(withIdentifier: "Movie_Genres_List_Table_Cell", for: indexPath as IndexPath) as! Movie_Genres_List_Table_Cell
        
        cell.lbl_Movie_Genres_Name?.text = self.arr_genres[indexPath.row]["name"] as? String ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let n_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Movie_List_VC") as! Movie_List_VC
        n_vc.genres_Id = self.arr_genres[indexPath.row]["id"] as? Int ?? 0
        self.navigationController?.pushViewController(n_vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
}

//************----*****************-------**********************-------**********************-------****************
//************---- Api Services Calling.
//************----*****************-------**********************-------**********************-------****************
extension Movie_Genres_List_VC{
    func Get_Movie_Genres_List(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = Constant.BaseUrl+"genre/movie/list?api_key="+Constant.Api_key
        
        APIServiceManager.shared.api_Calling_Get_Request(url: url) { (result, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            self.arr_genres = (result as? [String:Any] ?? [:])["genres"] as? [[String:Any]] ?? [[:]]
        }
    }
}
