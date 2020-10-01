//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Bilgihan Köse on 1.10.2020.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


//backdrop_path
//title
//overview
//vote_average
//release_date
//imdb_id   https://www.imdb.com/title/tt7286966/

class MovieDetailViewController: UIViewController {
    
    //MARK: - Variables
    
    var movieID = ""
    var imdb_id = ""
    var vote_average = "0.0"
    
    //MARK: - Outlets
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailPageData()
        
    }
    
    //MARK: - Functions
    
    func getDetailPageData(){
        
        let movieEndPoint = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=725f3639ca3af567269233f60eddabc1"
        
        AF.request("\(movieEndPoint)", method: .get).responseJSON { response in
            switch response.result{
            case .success:
                
                let object = try? JSON(data: response.data!)
                let bacdropPath = object!["backdrop_path"].stringValue
                let imagePosterURL = "https://image.tmdb.org/t/p/w300\(bacdropPath)"
                self.posterView.kf.indicatorType = .activity
                self.posterView.kf.setImage(with: URL(string: "\(imagePosterURL)"))
                self.imdb_id = object!["imdb_id"].stringValue
                let title = object!["title"].stringValue
                self.titleLabel.text = title
                let release_date = object!["release_date"].stringValue
                self.releaseDateLabel.text = release_date
                self.vote_average = object!["vote_average"].stringValue //Double
                self.voteAverage.text = self.vote_average
                let overview = object!["overview"].stringValue
                self.overviewLabel.text = overview
                
            case .failure:
                print(response.error!)
                break
            }
            
        }
        
    }
    
    //MARK: - For Segue
    
    @IBAction func imdbButton(_ sender: UIButton) {
        performSegue(withIdentifier: "imdbPage", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? IMDBSiteViewController{
            destination.movieID = self.imdb_id
        }
    }
}



