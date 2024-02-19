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
    @IBOutlet weak var seeMoreLabelTapped: UILabel!
    
    var viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    var leagueID: String?
        
    var arr = ["PL","laliga","EPL2","BL","SA","CL"]
    var dic = ["PL":"152" , "laliga":"302", "EPL2":"141", "BL":"175", "SA":"207","CL":"3"]
    
    var plStadArray = Constants.links.plStadArray
    var laligaStadArray = Constants.links.laligaStadArray
    var cairoStadArray = Constants.links.cairoStadArray
    var bundesStadArray = Constants.links.bundesStadArray
    var seriaStadArray = Constants.links.seriaStadArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NavBar.applyCustomNavBar(to: self)
        leagueCollectionView.register(UINib(nibName: "LeagueCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "leagueCell")
        popularMatchesCollectionView.register(UINib(nibName: "PopularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "popularCell")
        upcomingMatchesTableView.register(UINib(nibName: "UpcomingMatchesTableViewCell", bundle: nil), forCellReuseIdentifier: "upcomingCell")
        
        viewModel.getUpcomingFixetures(leagueID: "152", from: calculateFormattedLaunchDate() , to: getFormattedDateAfterTenDays())
        
        upcomingMatchesTableView.isScrollEnabled = false
        
        setUpLeagueCollectionView()
        bindingPopularCollectionViewToViewModel()
        bindingUpcomingTableViewToViewModel()
        makeSeeMoreLabelGestured()
        
    }
    
}

extension HomeVC{
    func setUpLeagueCollectionView(){
        var selectedCell: LeagueCollectionViewCell?
        var hasExecutedOnce = false
        
        Observable.just(arr)
            .bind(to: leagueCollectionView.rx.items(cellIdentifier: "leagueCell", cellType: LeagueCollectionViewCell.self)) { row, image, cell in
                cell.layer.cornerRadius = 35.8
                cell.clipsToBounds = true
                cell.leagueImageView.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1)
                cell.leagueImageView.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
                
                
                // Execute this block only once
                if !hasExecutedOnce {
                    // Set background color for the first row by default
                    if row == 0 {
                        cell.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 179/255, alpha: 1.0)
                        selectedCell = cell
                        //self.leagueID = self.dic["PL"] // Assuming arr contains the keys
                    }
                    hasExecutedOnce = true
                }
                
                // Handle cell selection
                let tapGesture = UITapGestureRecognizer()
                cell.leagueImageView.addGestureRecognizer(tapGesture)
                cell.leagueImageView.isUserInteractionEnabled = true
                
                tapGesture.rx.event
                    .subscribe(onNext: { [self] _ in
                        
                        if let selected = selectedCell {
                            selected.backgroundColor = UIColor(red: 216/255, green: 217/255, blue: 218/255, alpha: 1.0)
                        }
                        
                        selectedCell = cell
                        cell.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 179/255, alpha: 1.0)
                        
                        if row == 0 {
                            // 3aezo lma edos hna eb3at ll api l id bta3 l league w egyb l data w b kda hakon mstakhdm function wa7da w model wa7da bs
                            self.leagueID = self.dic["PL"]
                        }else if row == 1{
                            self.leagueID = self.dic["laliga"]
                        }else if row == 2{
                            self.leagueID = self.dic["EPL2"]
                        }else if row == 3{
                            self.leagueID = self.dic["BL"]
                        }else if row == 4{
                            //print("fourth row selected!")
                            self.leagueID = self.dic["SA"]
                        }else if row == 5{
                            self.leagueID = self.dic["CL"]
                        }
                        
                        self.viewModel.clearUpcomingFixtures()
                        self.viewModel.getUpcomingFixetures(leagueID: self.leagueID!, from: calculateFormattedLaunchDate(), to: getFormattedDateAfterTenDays())
                    })
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeVC{
    
    func bindingPopularCollectionViewToViewModel(){
        viewModel.upcomingFixeturesResult
            .map { results in
                // Filter the results to include only those involving popular teams
                return results.filter { self.shouldDisplayCell($0) }
            }
            .map { results in
                // Sort the results based on the event date in ascending order
                return results.sorted { (result1, result2) in
                    if let date1 = self.getDatePrepareForComparison(from: result1.eventDate),
                       let date2 = self.getDatePrepareForComparison(from: result2.eventDate) {
                        return date1 < date2
                    }
                    return false
                }
            }
            .bind(to: popularMatchesCollectionView.rx.items(cellIdentifier: "popularCell", cellType: PopularCollectionViewCell.self)) { row, result, cell in
                
                switch self.leagueID {
                case "302":
                    cell.stadiumImageView.image = UIImage(named: self.laligaStadArray[row])
                case "141":
                    cell.stadiumImageView.image = UIImage(named: self.cairoStadArray[row])
                case "175":
                    cell.stadiumImageView.image = UIImage(named: self.bundesStadArray[row])
                case "207":
                    cell.stadiumImageView.image = UIImage(named: self.seriaStadArray[row])
                case "3":
                    cell.stadiumImageView.image = UIImage(named: self.laligaStadArray[row])
                default:
                    cell.stadiumImageView.image = UIImage(named: self.plStadArray[row])
                }
                
                cell.homeTeam.text = result.eventHomeTeam
                cell.awayTeam.text = result.eventAwayTeam
                
                cell.matchDate.text = result.eventDate
                cell.matchTime.text = result.eventTime
                cell.stadiumName.text = result.eventStadium
                
                // Add a light grey stroke to the cell
                cell.contentView.layer.borderWidth = 1.0
                cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
                cell.contentView.layer.cornerRadius = 10.0
                cell.contentView.layer.masksToBounds = true
            }
            .disposed(by: disposeBag)
    }
    
    func shouldDisplayCell(_ result: UpcomingFixetures) -> Bool{
        
        let popularTeams = ["Chelsea","Manchester Utd","Arsenal","Liverpool","Manchester City","Atletico Madrid","Barcelona","Atl. Madrid","Sevilla","Real Madrid","Zamalek","Al Ahly","Ismaily","Juventus","Inter Milan","AC Milan","AS Roma","Inter","Borussia Dortmund","Mainz","Bayern Munich","Bayer Leverkusen"]
        
        return popularTeams.contains(result.eventHomeTeam) || popularTeams.contains(result.eventAwayTeam)
    }
}

extension HomeVC{
    func bindingUpcomingTableViewToViewModel() {
        viewModel.upcomingFixeturesResult
            .map { results in
                // Sort by event date in ascending order
                return results.sorted { (result1, result2) in
                    if let date1 = self.getDatePrepareForComparison(from: result1.eventDate),
                       let date2 = self.getDatePrepareForComparison(from: result2.eventDate) {
                        return date1 < date2
                    }
                    return false
                }
            }
            .bind(to: upcomingMatchesTableView.rx.items(cellIdentifier: "upcomingCell", cellType: UpcomingMatchesTableViewCell.self)) { row, result, cell in
                
                switch self.leagueID {
                case "302":
                    cell.stadImageView.image = UIImage(named: self.laligaStadArray[row])
                case "141":
                    cell.stadImageView.image = UIImage(named: self.cairoStadArray[row])
                case "175":
                    cell.stadImageView.image = UIImage(named: self.bundesStadArray[row])
                case "207":
                    cell.stadImageView.image = UIImage(named: self.seriaStadArray[row])
                case "3":
                    cell.stadImageView.image = UIImage(named: self.laligaStadArray[row])
                default:
                    cell.stadImageView.image = UIImage(named: self.plStadArray[row])
                }
                
                cell.homeTeamName.text = result.eventHomeTeam
                cell.awayTeamName.text = result.eventAwayTeam
                cell.matchDate.text = result.eventDate
                cell.matchTime.text = result.eventTime
                cell.stadName.text = result.eventStadium
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cellTapped(_:)))
                cell.addGestureRecognizer(tapGesture)
                cell.isUserInteractionEnabled = true
                
            }
            .disposed(by: disposeBag)
    }
    
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? UpcomingMatchesTableViewCell else { return }
        guard let indexPath = upcomingMatchesTableView.indexPath(for: cell) else { return }
        
        performSegue(withIdentifier: "ShowBookingSegue", sender: indexPath)
    }

}

// MARK: - Date Managment
extension HomeVC{
    
    func getDatePrepareForComparison(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
    
    func calculateFormattedLaunchDate() -> String {
        guard let launchDate = UserDefaults.standard.value(forKey: "appLaunchDate") as? Date
        else {
            return ""
        }
        
        let calendar = Calendar.current
        guard let dateAfterOneDay = calendar.date(byAdding: .day, value: 1, to: launchDate)
        else{
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //print("Today's date \(dateFormatter.string(from: dateAfterOneDay))")
        
        return dateFormatter.string(from: dateAfterOneDay)
    }
    
    func getDateAfterTenDays() -> Date? {
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        if let dateAfterTenDays = calendar.date(byAdding: .day, value: 11, to: currentDate) {
            return dateAfterTenDays
        } else {
            return nil
        }
    }
    
    func getFormattedDateAfterTenDays() -> String {
        if let dateAfterTenDays = getDateAfterTenDays() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: dateAfterTenDays)
        } else {
            return ""
        }
    }
}

extension HomeVC {
    func makeSeeMoreLabelGestured() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(seeMoreLabelTapped(_:)))
        seeMoreLabelTapped.isUserInteractionEnabled = true
        seeMoreLabelTapped.addGestureRecognizer(tapGesture)
    }
    
    @objc func seeMoreLabelTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "ShowFixturesSegue", sender: viewModel.upcomingFixeturesResult)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFixturesSegue",
           let destinationVC = segue.destination as? FixturesVC,
           let upcomingFixtures = sender as? BehaviorRelay<[UpcomingFixetures]> {
            destinationVC.upcomingFixtures.accept(upcomingFixtures.value)
            destinationVC.leagueID = leagueID
        }
    }
}

