//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Bilgihan Köse on 28.09.2020.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import TYImageSlider


class ViewController: UIViewController {
    
    //MARK: - Variables
    
    private var titleArray = [String]()
    private var overviewArray = [String]()
    private var releaseDateArray = [String]()
    private var posterPathArray = [String]()
    private var movieIDArray = [String]()
    private var sliderImageArray = [String]()
    private var imageString = ""
    
    //MARK: - Endpoints
    
    let upcomingEndPoint = "https://api.themoviedb.org/3/movie/upcoming?api_key=725f3639ca3af567269233f60eddabc1"
    let nowPlayingEndPoint = "https://api.themoviedb.org/3/movie/now_playing?api_key=725f3639ca3af567269233f60eddabc1"
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageSliderView: ImageSliderView!
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 180
        getData()
        getDataForSlider()
        
    }
    
    //MARK: - Functions
    
    func getDataForSlider(){
        AF.request("\(nowPlayingEndPoint)", method: .get).responseJSON { response in
            
            switch response.result{
            case .success:
                
                let object = try? JSON(data: response.data!)
                let sliderArray = object!["results"]
                self.sliderImageArray.removeAll()
                
                for i in sliderArray.arrayValue {
                    let backdrop_path = i["backdrop_path"].stringValue
                    self.sliderImageArray.append("https://image.tmdb.org/t/p/w300\(backdrop_path)")
                    
                }
                self.configureSlider()
              
            case .failure:
                print(response.error!)
                break
            }
        }
    }
    
    func configureSlider(){
        let imageSliderPresenter = ImageSliderViewPresenter(imageUrls: sliderImageArray,
                                                            loopingEnabled: true,
                                                            view: imageSliderView)
        imageSliderView.presenter = imageSliderPresenter
    }

    func getData(){
        AF.request("\(upcomingEndPoint)", method: .get).responseJSON { response in
            
            switch response.result{
            case .success:
                
                let object = try? JSON(data: response.data!)
                let resultsArray = object!["results"]
                
                self.titleArray.removeAll()
                self.overviewArray.removeAll()
                self.releaseDateArray.removeAll()
                self.posterPathArray.removeAll()
                
                for i in resultsArray.arrayValue {
                    let id = i["id"].stringValue
                    self.movieIDArray.append(id)
                    let title = i["title"].stringValue
                    self.titleArray.append(title)
                    let overview = i["overview"].stringValue
                    self.overviewArray.append(overview)
                    let releaseDate = i["release_date"].stringValue
                    self.releaseDateArray.append(releaseDate)
                    let posterPath = i["poster_path"].stringValue
                    self.posterPathArray.append("https://image.tmdb.org/t/p/w300\(posterPath)")
                }
                self.tableView.reloadData()
                
            case .failure:
                print(response.error!)
                break
            }
            
        }
    }
}

//MARK: - Extensions

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        cell.movieView.kf.indicatorType = .activity
        cell.movieView.kf.setImage(with: URL(string: "\(posterPathArray[indexPath.row])"))
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.overviewLabel.text = overviewArray[indexPath.row]
        cell.dateLabel.text = releaseDateArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailViewController{
            destination.movieID = movieIDArray[tableView.indexPathForSelectedRow!.row]
        }
    }
}


