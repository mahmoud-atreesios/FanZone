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
    
    var plStadArray = ["PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3"]
    var laligaStadArray = ["laliga1","laliga2","laliga3","laliga1","laliga2","laliga3","laliga1","laliga2","laliga3","laliga1","laliga2","laliga3","laliga1","laliga2","laliga3","laliga1","laliga2","laliga3","laliga1","laliga2","laliga3"]
    var cairoStadArray = ["cairo1","cairo2","cairo3","cairo1","cairo2","cairo3","cairo1","cairo2","cairo3","cairo1","cairo2","cairo3","cairo1","cairo2","cairo3","cairo1","cairo2","cairo3","cairo1","cairo2","cairo3","cairo1","cairo2","cairo3"]
    var bundesStadArray = ["bundes1","bundes2","bundes3","bundes1","bundes2","bundes3","bundes1","bundes2","bundes3","bundes1","bundes2","bundes3","bundes1","bundes2","bundes3","bundes1","bundes2","bundes3","bundes1","bundes2","bundes3",]
    var seriaStadArray = ["seria1","seria2","seria3","seria1","seria2","seria3","seria1","seria2","seria3","seria1","seria2","seria3","seria1","seria2","seria3","seria1","seria2","seria3","seria1","seria2","seria3","seria1","seria2","seria3"]
    
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
                cell.matchTime.text = result.eventTime
                cell.matchDate.text = result.eventDate
                cell.stadName.text = result.eventStadium
            }
            .disposed(by: disposeBag)
    }
    
    func getDatePrepareForComparison(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
}



