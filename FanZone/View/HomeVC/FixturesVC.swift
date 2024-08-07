//
//  FixturesVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 10/02/2024.
//

import UIKit
import RxSwift
import RxCocoa

class FixturesVC: UIViewController {
    
    @IBOutlet weak var fixturesTableView: UITableView!
        
    var upcomingFixtures: BehaviorRelay<[UpcomingFixetures]> = BehaviorRelay(value: [])
    private let disposeBag = DisposeBag()
    
    var leagueID: String?
    
    let plStadArray = Constants.links.plStadArray
    let laligaStadArray = Constants.links.laligaStadArray
    let cairoStadArray = Constants.links.cairoStadArray
    let bundesStadArray = Constants.links.bundesStadArray
    let seriaStadArray = Constants.links.seriaStadArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fixturesTableView.register(UINib(nibName: "UpcomingMatchesTableViewCell", bundle: nil), forCellReuseIdentifier: "upcomingCell")
        setUpUpcomingFixturesTableView()
    }
    
}

extension FixturesVC{
    func setUpUpcomingFixturesTableView(){
        upcomingFixtures
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
            .bind(to: fixturesTableView.rx.items(cellIdentifier: "upcomingCell", cellType: UpcomingMatchesTableViewCell.self)) { row, result, cell in
                
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
                cell.matchTime.text = result.eventTime
                cell.matchDate.text = result.eventDate
                cell.stadName.text = result.eventStadium
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cellTapped(_:)))
                cell.addGestureRecognizer(tapGesture)
                cell.isUserInteractionEnabled = true
                
            }
            .disposed(by: disposeBag)
    }
    
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? UpcomingMatchesTableViewCell else { return }
        guard let indexPath = fixturesTableView.indexPath(for: cell) else { return }
        
        // Use the sorted upcomingFixeturesResult to get the selected match
        let sortedMatches = upcomingFixtures.value.sorted { (result1, result2) in
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
        
        performSegue(withIdentifier: "ShowBookingSegueFromFixtures", sender: indexPath)
    }
    
    func getDatePrepareForComparison(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
}



