//
//  ViewController.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 31/01/2024.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {


    @IBOutlet weak var leagueCollectionView: UICollectionView!
    @IBOutlet weak var popularMatchesCollectionView: UICollectionView!
    @IBOutlet weak var upcomingMatchesTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    var arr = ["PL","laliga","EPL2","BL","CL","SA"]
    var stadArray = ["Stad1","Stad2","Stad3","Stad1","Stad2","Stad3","Stad1","Stad2","Stad3","Stad1","Stad2","Stad3","Stad1","Stad2","Stad3","Stad1","Stad2","Stad3","Stad1","Stad2","Stad3","Stad1","Stad2","Stad3","Stad1","Stad2","Stad3"]
    var homeTeamArray = ["Arsenal","Manchester United", "Nottengham Forest"]
    var awayTeamArray = ["Manchester United", "Manchester City","Wolves"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NavBar.applyCustomNavBar(to: self)
        leagueCollectionView.register(UINib(nibName: "LeagueCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "leagueCell")
        popularMatchesCollectionView.register(UINib(nibName: "PopularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "popularCell")
        upcomingMatchesTableView.register(UINib(nibName: "UpcomingMatchesTableViewCell", bundle: nil), forCellReuseIdentifier: "upcomingCell")
        
        upcomingMatchesTableView.isScrollEnabled = false

        setUpLeagueCollectionView()
        setUpPopularMatchesCollectionView()
        setUpUpcomingMatchesTableView()

    }

}

extension HomeVC{
    func setUpLeagueCollectionView(){
        Observable.just(arr)
            .bind(to: leagueCollectionView.rx.items(cellIdentifier: "leagueCell", cellType: LeagueCollectionViewCell.self)){row,image,cell in
                cell.leagueImageView.image = UIImage(named: image)
                
                // Make the cell circular
                cell.layer.cornerRadius = 35.8
                cell.clipsToBounds = true
                
                cell.leagueImageView.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1)
                cell.leagueImageView.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeVC{
    func setUpPopularMatchesCollectionView(){
        Observable.just(stadArray)
            .bind(to: popularMatchesCollectionView.rx.items(cellIdentifier: "popularCell", cellType: PopularCollectionViewCell.self)){row,stad,cell in
                
                cell.stadiumImageView.image = UIImage(named: stad)
                
                if row < self.homeTeamArray.count {
                    cell.homeTeam.text = self.homeTeamArray[row]
                }
                if row < self.awayTeamArray.count {
                    cell.awayTeam.text = self.awayTeamArray[row]
                }
                
                cell.matchDate.text = "2024-02-02"
                cell.stadiumName.text = "Etihad Stadium"
                
                // Add a light grey stroke to the cell
                cell.contentView.layer.borderWidth = 1.0
                cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
                cell.contentView.layer.cornerRadius = 10.0 // Adjust the corner radius as needed
                cell.contentView.layer.masksToBounds = true
                
            }
            .disposed(by: disposeBag)
    }
}

extension HomeVC{
    func setUpUpcomingMatchesTableView(){
        Observable.just(stadArray)
            .bind(to: upcomingMatchesTableView.rx.items(cellIdentifier: "upcomingCell", cellType: UpcomingMatchesTableViewCell.self)){row,stad,cell in
                cell.stadImageView.image = UIImage(named: stad)
            }
            .disposed(by: disposeBag)
    }
}
