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
        static let apikey = "a48dcaedd80a17e65f5ba952179e4d6f8db99401cbf29a9e94189d9776f19c9e"
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
    }
}
