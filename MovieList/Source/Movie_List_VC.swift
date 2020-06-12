//
//  Movie_List_VC.swift
//  MovieList
//
//  Created by Amit Saxena on 11/06/20.
//  Copyright © 2020 Amit Saxena. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage
import KDCircularProgress

class Movie_List_CollectionView_Cell: UICollectionViewCell{
    @IBOutlet weak var Img_poster: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_release_date: UILabel!
    @IBOutlet weak var lbl_vote_average: UILabel!
    @IBOutlet var progress: KDCircularProgress!
    
    
}

class Movie_List_VC: UIViewController {
    
    @IBOutlet weak var Movie_List_CollectionView: UICollectionView!
    
    var genres_Id = Int()
    
    var arr_movies = [[String:Any]](){
        didSet{
            self.Movie_List_CollectionView.reloadData()
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
        self.Get_Movie_List()
    }
}

//************----*****************-------**********************-------**********************-------****************
//************---- Api Services Calling.
//************----*****************-------**********************-------**********************-------****************
extension Movie_List_VC{
    func Get_Movie_List(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = Constant.BaseUrl+"discover/movie?api_key="+Constant.Api_key+"&language=en-US&with_genres="+"\(genres_Id)"
        
        APIServiceManager.shared.api_Calling_Get_Request(url: url) { (result, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            self.arr_movies = (result as? [String:Any] ?? [:])["results"] as? [[String:Any]] ?? [[:]]
        }
    }
}


//************----*****************-------**********************-------**********************-------**********************
//************----Collection view setup for bottom
//************----*****************-------**********************-------**********************-------**********************
extension Movie_List_VC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr_movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:Movie_List_CollectionView_Cell = self.Movie_List_CollectionView.dequeueReusableCell(withReuseIdentifier: "Movie_List_CollectionView_Cell", for: indexPath) as! Movie_List_CollectionView_Cell
        
        //mark:- ui setup
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1.0
        
        //mark:- set poster image
        let poster_path = self.arr_movies[indexPath.row]["poster_path"] as? String ?? ""
        cell.Img_poster.sd_setImage(with: URL(string: Constant.ImageUrl+poster_path), placeholderImage: UIImage(named: "placeholder.png"))
        
        //mark:- set details on lables
        cell.lbl_title.text = self.arr_movies[indexPath.row]["title"] as? String ?? ""
        cell.lbl_release_date.text = self.arr_movies[indexPath.row]["release_date"] as? String ?? ""
        
        let vote_average:Int = Int(((self.arr_movies[indexPath.row]["vote_average"] as? Float ?? 0.0) * 10))
        cell.lbl_vote_average.text = "\(vote_average)"+"%"
        
        cell.progress.angle = Double((360 * vote_average)/100)
        cell.progress.glowMode = .forward
        cell.progress.glowAmount = 0.9
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width/2-10
        let collectionViewHeight = collectionView.bounds.height/2-10
        
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let n_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Movie_Details_VC") as! Movie_Details_VC
        n_vc.movie_details_dict = self.arr_movies[indexPath.row]
        self.navigationController?.pushViewController(n_vc, animated: true)
    }
}
