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
        static let apikey = "a1c1fd71c54b8f126999cdd2b3b3956771e0c67b1fafd30bc6ab40a07eac490f"
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
        
        //Paymob Integration
        // first token
        static let firstTokenUrl = "https://accept.paymob.com/api/auth/tokens"
        static let firstTokenBody = [
            "api_key": "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1RJME5qVTNMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuSG9PNkZFUTZqUE1rOGxTSEhpdWxtczJiOXR6TkZBREtrSE1tdGxYanRVaGpMdEJBNFo0U3lfVW1PUlAzU1MyV2FmMmFMVnlKOHIxenhQTjdnZDBfZEE="
        ]
        
        // order id
        static let orderIdUrl = "https://accept.paymob.com/api/ecommerce/orders"
        static let orderIditems = [
            [
                "name": "Inter Milan",
                "amount_cents": "900000",
                "Ticket_Category": "Left cat3",
                "quantity": "3"
            ],
            [
                "name": "Liverpool VS Real",
                "amount_cents": "200000",
                "Ticket_Category": "Gold",
                "quantity": "1"
            ]
        ]
        
        // payment token
        static let paymentTokenUrl = "https://accept.paymob.com/api/acceptance/payment_keys"
        static let billingData = [
            "apartment": "803",
            "email": "mahmoud@gmail.com",
            "floor": "5",
            "first_name": "Mahmoud",
            "street": "Faysel",
            "building": "8028",
            "phone_number": "01148143311",
            "shipping_method": "PKG",
            "postal_code": "01898",
            "city": "Jaskolskiburgh",
            "country": "EG",
            "last_name": "Atrees",
            "state": "Cairo"
        ]
    }
}
