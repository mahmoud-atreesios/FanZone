//
//  Constants.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 05/02/2024.
//

import Foundation

struct Constants{
    enum links{
        
        //HomeVC
        static let apikey = "eb02c914aa96963e3ebbc5bfb33afefd31c77ad1b1d5355ccd0a29bbbb6fbb1b"
        static let upcomingFixteuresURL = "https://apiv2.allsportsapi.com/football/?met=Fixtures&APIkey="
        static let leagueId = "&leagueId="
        
        //NewsVC
        static let newsApiKey = "7403d80699msh2fd43e6b48b57b5p1df40bjsndf535a86df57"
        static let newsHost = "football-news-aggregator-live.p.rapidapi.com"
        static let trendingNewsURL = "https://football-news-aggregator-live.p.rapidapi.com/news/espn"
        static let newsURL = "https://football-news-aggregator-live.p.rapidapi.com/news/fourfourtwo/epl"
        
        //HighlightsVC
        static let highlightsApi = "MTQyMjc0XzE3MDc0NDY2MTVfODY5NTJhNzVlYzM1OWYyNmE4ZGE5MjI2NTIxNzUwMWZjNDg4YTI0Yg=="
        static let highlightsURL = "https://www.scorebat.com/video-api/v3/feed/?token="
        
        //stadiums
        static let plStadArray = ["PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3"]
        static let laligaStadArray = ["laliga1","laliga2","laliga3","laliga1","laliga2","laliga3","laliga1","laliga2","laliga3","laliga1","laliga2","laliga3","laliga1","laliga2","laliga3","laliga1","laliga2","laliga3","laliga1","laliga2","laliga3"]
        static let cairoStadArray = ["cairo1","cairo2","cairo3","cairo1","cairo2","cairo3","cairo1","cairo2","cairo3","cairo1","cairo2","cairo3","cairo1","cairo2","cairo3","cairo1","cairo2","cairo3","cairo1","cairo2","cairo3","cairo1","cairo2","cairo3"]
        static let bundesStadArray = ["bundes1","bundes2","bundes3","bundes1","bundes2","bundes3","bundes1","bundes2","bundes3","bundes1","bundes2","bundes3","bundes1","bundes2","bundes3","bundes1","bundes2","bundes3","bundes1","bundes2","bundes3"]
        static let seriaStadArray = ["seria1","seria2","seria3","seria1","seria2","seria3","seria1","seria2","seria3","seria1","seria2","seria3","seria1","seria2","seria3","seria1","seria2","seria3","seria1","seria2","seria3","seria1","seria2","seria3"]
    }
}
