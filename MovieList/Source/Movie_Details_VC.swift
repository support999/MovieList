//
//  Movie_Details_VC.swift
//  MovieList
//
//  Created by Amit Saxena on 11/06/20.
//  Copyright © 2020 Amit Saxena. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
import KDCircularProgress

class Reviews_Table_cell: UITableViewCell {
    @IBOutlet weak var view_Outer: UIView!
    @IBOutlet weak var lbl_author: UILabel!
    @IBOutlet weak var lbl_content: UILabel!
}

class Movie_Details_VC: UIViewController {
    
    @IBOutlet weak var Img_poster: UIImageView!
    @IBOutlet weak var lbl_vote_average: UILabel!
    @IBOutlet var progress: KDCircularProgress!
    @IBOutlet weak var lbl_overview: UILabel!
    
    @IBOutlet weak var Reviews_Table: UITableView!
    
    var movie_details_dict = [String:Any]()
    
    var arr_moview_review = [[String:Any]](){
        didSet{
            self.Reviews_Table.reloadData()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.Get_Movie_Reviews_List()
    }
    
    func setupUI(){
        
        //mark:- set poster image
        let poster_path = self.movie_details_dict["poster_path"] as? String ?? ""
        self.Img_poster.sd_setImage(with: URL(string: Constant.ImageUrl+poster_path), placeholderImage: UIImage(named: "placeholder.png"))
        
        self.lbl_overview.text = self.movie_details_dict["overview"] as? String ?? ""
        
        let vote_average:Int = Int(((self.movie_details_dict["vote_average"] as? Float ?? 0.0) * 10))
        lbl_vote_average.text = "\(vote_average)"+"%"
        
        self.progress.angle = Double((360 * vote_average)/100)
        self.progress.glowMode = .forward
        self.progress.glowAmount = 0.9
    }
    
    @IBAction func btnClick_PlayTrailer(_ sender: UIButton) {
        self.Get_Movie_Trailer()
    }
}


//************----*****************-------**********************-------**********************-------****************
//************---- TableView And Datasource
//************----*****************-------**********************-------**********************-------****************
extension Movie_Details_VC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_moview_review.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:Reviews_Table_cell = self.Reviews_Table.dequeueReusableCell(withIdentifier: "Reviews_Table_cell", for: indexPath as IndexPath) as! Reviews_Table_cell
        
        //mark:- ui setup
        cell.view_Outer.layer.cornerRadius = 5
        cell.view_Outer.layer.borderColor = UIColor.lightGray.cgColor
        cell.view_Outer.layer.borderWidth = 0.5
        
        cell.lbl_author?.text = "A review by \(self.arr_moview_review[indexPath.row]["author"] as? String ?? "")."
        
        cell.lbl_content?.text = self.arr_moview_review[indexPath.row]["content"] as? String ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight = 60
        return UITableView.automaticDimension
    }
}

//************----*****************-------**********************-------**********************-------****************
//************---- Api Services Calling.
//************----*****************-------**********************-------**********************-------****************
extension Movie_Details_VC{
    
    func Get_Movie_Reviews_List(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let id = self.movie_details_dict["id"] as? Int ?? 0
        
        let url = Constant.BaseUrl+"movie/"+"\(id)"+"/reviews?api_key="+Constant.Api_key
        
        APIServiceManager.shared.api_Calling_Get_Request(url: url) { (result, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            self.arr_moview_review = (result as? [String:Any] ?? [:])["results"] as? [[String:Any]] ?? [[:]]
        }
    }
    
    func Get_Movie_Trailer(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let id = self.movie_details_dict["id"] as? Int ?? 0
        
        let url = Constant.BaseUrl+"movie/"+"\(id)"+"/videos?api_key="+Constant.Api_key
        
        APIServiceManager.shared.api_Calling_Get_Request(url: url) { (result, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            let key = (((result as? [String:Any] ?? [:])["results"] as? [[String:Any]] ?? [[:]])[0])["key"] as? String ?? ""
            
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Movie_trailer_play_VC") as! Movie_trailer_play_VC
            popOverVC.urlStr = "https://www.youtube.com/embed/\(key)"
            self.addChild(popOverVC)
            popOverVC.view.frame = self.view.bounds
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
        }
    }
}
