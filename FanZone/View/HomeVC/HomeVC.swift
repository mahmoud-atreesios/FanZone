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
        
    var arr = ["mlss","EPL2","uefa","copa","SA","CL"]
    var dic = ["mlss":"332" , "EPL2":"141", "uefa":"1", "copa":"17", "SA":"207","CL":"3"]
    
    let plStadArray = Constants.links.plStadArray
    let laligaStadArray = Constants.links.laligaStadArray
    let cairoStadArray = Constants.links.cairoStadArray
    let bundesStadArray = Constants.links.bundesStadArray
    let seriaStadArray = Constants.links.seriaStadArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        setUpLeagueCollectionView()
        bindingPopularCollectionViewToViewModel()
        bindingUpcomingTableViewToViewModel()
        makeSeeMoreLabelGestured()
    }
}

// MARK: - league collection view
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
                
                if !hasExecutedOnce {
                    if row == 0 {
                        cell.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 179/255, alpha: 1.0)
                        selectedCell = cell
                        //self.leagueID = self.dic["PL"]
                    }
                    hasExecutedOnce = true
                }
                
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
                            self.leagueID = self.dic["mlss"]
                        }else if row == 1{
                            self.leagueID = self.dic["EPL2"]
                        }else if row == 2{
                            self.leagueID = self.dic["uefa"]
                        }else if row == 3{
                            self.leagueID = self.dic["copa"]
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

// MARK: - popular collection view
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
                case "1":
                    cell.stadiumImageView.image = UIImage(named: self.laligaStadArray[row])
                case "141":
                    cell.stadiumImageView.image = UIImage(named: self.cairoStadArray[row])
                case "17":
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
                
                cell.contentView.layer.borderWidth = 1.0
                cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
                cell.contentView.layer.cornerRadius = 10.0
                cell.contentView.layer.masksToBounds = true
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cellTapped(_:)))
                cell.addGestureRecognizer(tapGesture)
                cell.isUserInteractionEnabled = true
                
            }
            .disposed(by: disposeBag)
    }
    
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? PopularCollectionViewCell else { return }
        guard let indexPath = popularMatchesCollectionView.indexPath(for: cell) else { return }

        let filteredMatches = viewModel.upcomingFixeturesResult.value.filter { shouldDisplayCell($0) }
        let sortedMatches = filteredMatches.sorted { (result1, result2) in
            if let date1 = self.getDatePrepareForComparison(from: result1.eventDate),
               let date2 = self.getDatePrepareForComparison(from: result2.eventDate) {
                return date1 < date2
            }
            return false
        }
        let selectedMatch = sortedMatches[indexPath.row]

        print("***********Tapped IndexPath:", indexPath)
        print("=========Selected Match:", selectedMatch)

        MatchTicketsManager.shared.selectedMatchTicketsModel = MatchTicketsModel(
            leagueName: selectedMatch.leagueName,
            leagueRound: selectedMatch.leagueRound.rawValue,
            departmentName: "Cat3-left",
            homeTeamLogo: selectedMatch.homeTeamLogo,
            homeTeamName: selectedMatch.eventHomeTeam,
            awayTeamLogo: selectedMatch.awayTeamLogo,
            awayTeamName: selectedMatch.eventAwayTeam,
            matchStadium: selectedMatch.eventStadium,
            matchDate: selectedMatch.eventDate,
            matchTime: selectedMatch.eventTime,
            ticketStatus: "Activated"
        )
        performSegue(withIdentifier: "ShowBookingSegue", sender: indexPath)
    }
    
    func shouldDisplayCell(_ result: UpcomingFixetures) -> Bool{
        
        let popularTeams = ["Zamalek","Al Ahly","Ismaily","LA Galaxy","Inter Miami","Toronto FC","Portland Timbers","England","Italy","Spain","Germany","Portugal","USA","Uruguay","Brazil","Argentina"]
        
        return popularTeams.contains(result.eventHomeTeam) || popularTeams.contains(result.eventAwayTeam)
    }
}

// MARK: - upcoming table view
extension HomeVC{
    func bindingUpcomingTableViewToViewModel(){
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
                case "1":
                    cell.stadImageView.image = UIImage(named: self.laligaStadArray[row])
                case "141":
                    cell.stadImageView.image = UIImage(named: self.cairoStadArray[row])
                case "17":
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
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.upcomingCellTapped(_:)))
                cell.addGestureRecognizer(tapGesture)
                cell.isUserInteractionEnabled = true
                
            }
            .disposed(by: disposeBag)
    }
    
    @objc func upcomingCellTapped(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? UpcomingMatchesTableViewCell else { return }
        guard let indexPath = upcomingMatchesTableView.indexPath(for: cell) else { return }
        
        // Use the sorted upcomingFixeturesResult to get the selected match
        let sortedMatches = viewModel.upcomingFixeturesResult.value.sorted { (result1, result2) in
            if let date1 = self.getDatePrepareForComparison(from: result1.eventDate),
               let date2 = self.getDatePrepareForComparison(from: result2.eventDate) {
                return date1 < date2
            }
            return false
        }
        let selectedMatch = sortedMatches[indexPath.row]
        
        print("***********Tapped IndexPath:", indexPath)
        print("=========Selected Match:", selectedMatch)
        
        MatchTicketsManager.shared.selectedMatchTicketsModel = MatchTicketsModel(
            leagueName: selectedMatch.leagueName,
            leagueRound: selectedMatch.leagueRound.rawValue,
            departmentName: "Cat3-left",
            homeTeamLogo: selectedMatch.homeTeamLogo,
            homeTeamName: selectedMatch.eventHomeTeam,
            awayTeamLogo: selectedMatch.awayTeamLogo,
            awayTeamName: selectedMatch.eventAwayTeam,
            matchStadium: selectedMatch.eventStadium,
            matchDate: selectedMatch.eventDate,
            matchTime: selectedMatch.eventTime,
            ticketStatus: "Activated"
        )
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
        
        if let dateAfterTenDays = calendar.date(byAdding: .day, value: 15, to: currentDate) {
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

// MARK: - intial setup
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

extension HomeVC{
    func setup(){
        NavBar.applyCustomNavBar(to: self)
        leagueCollectionView.register(UINib(nibName: "LeagueCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "leagueCell")
        popularMatchesCollectionView.register(UINib(nibName: "PopularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "popularCell")
        upcomingMatchesTableView.register(UINib(nibName: "UpcomingMatchesTableViewCell", bundle: nil), forCellReuseIdentifier: "upcomingCell")
        //upcomingMatchesTableView.delegate = self
        //upcomingMatchesTableView.dataSource = self
        
        viewModel.getUpcomingFixetures(leagueID: "332", from: calculateFormattedLaunchDate() , to: getFormattedDateAfterTenDays())
        
        upcomingMatchesTableView.isScrollEnabled = false
    }
}

// MARK: - fixed data
//extension HomeVC: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! UpcomingMatchesTableViewCell
//
//        cell.homeTeamName.text = "Man City"
//        cell.awayTeamName.text = "Arsenal"
//        cell.matchDate.text = "2024-05-20"
//        cell.matchTime.text = "17:00"
//        cell.stadName.text = "Etihad Stadium"
//        cell.stadImageView.image = UIImage(named: "PL1")
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        MatchTicketsManager.shared.selectedMatchTicketsModel = MatchTicketsModel(
//            leagueName: "Premier League",
//            leagueRound: "Round 12",
//            departmentName: "Cat3-left",
//            homeTeamLogo: "https://firebasestorage.googleapis.com:443/v0/b/database10-244fc.appspot.com/o/images%2F2ED98C1C-C283-47D3-8655-9E9849AB4ACB.jpg?alt=media&token=3ab99d5f-cb7c-4646-b105-694df74c6da1",
//            homeTeamName: "Arsenal",
//            awayTeamLogo: "https://firebasestorage.googleapis.com:443/v0/b/database10-244fc.appspot.com/o/images%2F2ED98C1C-C283-47D3-8655-9E9849AB4ACB.jpg?alt=media&token=3ab99d5f-cb7c-4646-b105-694df74c6da1",
//            awayTeamName: "Arsenal",
//            matchStadium: "Etihad Stadium",
//            matchDate: "2024-05-20",
//            matchTime: "17:00",
//            ticketStatus: "Activated"
//        )
//
//        performSegue(withIdentifier: "ShowBookingSegue", sender: indexPath)
//    }
//}
