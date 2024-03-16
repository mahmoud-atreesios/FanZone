//
//  UpcomingFixeturesModel.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 05/02/2024.
//

import Foundation


// MARK: - Temperatures
struct UpcomingFixeturesModel: Codable {
    let success: Int
    let result: [UpcomingFixetures]
}

// MARK: - Result
struct UpcomingFixetures: Codable {
    let eventKey: Int
    let eventDate, eventTime, eventHomeTeam: String
    let homeTeamKey: Int
    let eventAwayTeam: String
    let awayTeamKey: Int
    let eventHalftimeResult: String
    let eventFinalResult: EventFinalResult
    let eventFtResult, eventPenaltyResult: String
    let eventStatus: EventStatus
    let countryName, leagueName: String
    let leagueKey: Int
    let leagueRound: LeagueRound
    let leagueSeason, eventLive, eventStadium: String
    let eventReferee: EventReferee
    let homeTeamLogo, awayTeamLogo: String?
    let eventCountryKey: Int
    let leagueLogo, countryLogo: String?
    let fkStageKey: Int?
    let stageName: String?
    let leagueGroup: JSONNull?
    let goalscorers: [JSONAny]
    let substitutes: [Substitute]
    let cards: [JSONAny]
    let vars: Vars
    let lineups: Lineups
    let statistics: [Statistic]

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case homeTeamKey = "home_team_key"
        case eventAwayTeam = "event_away_team"
        case awayTeamKey = "away_team_key"
        case eventHalftimeResult = "event_halftime_result"
        case eventFinalResult = "event_final_result"
        case eventFtResult = "event_ft_result"
        case eventPenaltyResult = "event_penalty_result"
        case eventStatus = "event_status"
        case countryName = "country_name"
        case leagueName = "league_name"
        case leagueKey = "league_key"
        case leagueRound = "league_round"
        case leagueSeason = "league_season"
        case eventLive = "event_live"
        case eventStadium = "event_stadium"
        case eventReferee = "event_referee"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case eventCountryKey = "event_country_key"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
        case fkStageKey = "fk_stage_key"
        case stageName = "stage_name"
        case leagueGroup = "league_group"
        case goalscorers, substitutes, cards, vars, lineups, statistics
    }
}

enum EventFinalResult: String, Codable {
    case empty = "-"
}

enum EventReferee: Codable {
    case referee(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let stringValue = try? container.decode(String.self) {
            self = .referee(stringValue)
        } else {
            throw DecodingError.typeMismatch(EventReferee.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid event referee format"))
        }
    }
}

enum EventStatus: String, Codable {
    case cancelled = "Cancelled"
    case empty = ""
    case postponed = "Postponed"
}

enum LeagueRound: String, Codable {
    case empty = ""
    case leagueRoundFinal = "Final"
    case quarterFinals = "Quarter-finals"
    case round1 = "Round 1"
    case round10 = "Round 10"
    case round11 = "Round 11"
    case round12 = "Round 12"
    case round13 = "Round 13"
    case round14 = "Round 14"
    case round15 = "Round 15"
    case round16 = "Round 16"
    case round17 = "Round 17"
    case round18 = "Round 18"
    case round19 = "Round 19"
    case round2 = "Round 2"
    case round20 = "Round 20"
    case round21 = "Round 21"
    case round22 = "Round 22"
    case round23 = "Round 23"
    case round24 = "Round 24"
    case round25 = "Round 25"
    case round26 = "Round 26"
    case round27 = "Round 27"
    case round28 = "Round 28"
    case round29 = "Round 29"
    case round3 = "Round 3"
    case round30 = "Round 30"
    case round31 = "Round 31"
    case round32 = "Round 32"
    case round33 = "Round 33"
    case round34 = "Round 34"
    case round35 = "Round 35"
    case round36 = "Round 36"
    case round37 = "Round 37"
    case round38 = "Round 38"
    case round39 = "Round 39"
    case round4 = "Round 4"
    case round5 = "Round 5"
    case round6 = "Round 6"
    case round7 = "Round 7"
    case round8 = "Round 8"
    case round9 = "Round 9"
    case roundOf16 = "Round of 16"
    case semiFinals = "Semi-finals"
}

// MARK: - Lineups
struct Lineups: Codable {
    let homeTeam, awayTeam: Team

    enum CodingKeys: String, CodingKey {
        case homeTeam = "home_team"
        case awayTeam = "away_team"
    }
}

// MARK: - Team
struct Team: Codable {
    let startingLineups, substitutes: [StartingLineup]
    let coaches: [Coach]
    let missingPlayers: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case startingLineups = "starting_lineups"
        case substitutes, coaches
        case missingPlayers = "missing_players"
    }
}

// MARK: - Coach
struct Coach: Codable {
    let coache: String
    let coacheCountry: JSONNull?

    enum CodingKeys: String, CodingKey {
        case coache
        case coacheCountry = "coache_country"
    }
}

// MARK: - StartingLineup
struct StartingLineup: Codable {
    let player: String
    let playerNumber, playerPosition: Int
    let playerCountry: JSONNull?
    let playerKey: Int
    let infoTime: String

    enum CodingKeys: String, CodingKey {
        case player
        case playerNumber = "player_number"
        case playerPosition = "player_position"
        case playerCountry = "player_country"
        case playerKey = "player_key"
        case infoTime = "info_time"
    }
}

// MARK: - Statistic
struct Statistic: Codable {
    let type, home, away: String
}

// MARK: - Substitute
struct Substitute: Codable {
    let time: String
    let homeScorer: AwayScorerUnion
    let homeAssist: String
    let score: Score
    let awayScorer: AwayScorerUnion
    let awayAssist, info: String
    let infoTime: InfoTime

    enum CodingKeys: String, CodingKey {
        case time
        case homeScorer = "home_scorer"
        case homeAssist = "home_assist"
        case score
        case awayScorer = "away_scorer"
        case awayAssist = "away_assist"
        case info
        case infoTime = "info_time"
    }
}

enum AwayScorerUnion: Codable {
    case anythingArray([JSONAny])
    case awayScorerClass(AwayScorerClass)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([JSONAny].self) {
            self = .anythingArray(x)
            return
        }
        if let x = try? container.decode(AwayScorerClass.self) {
            self = .awayScorerClass(x)
            return
        }
        throw DecodingError.typeMismatch(AwayScorerUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for AwayScorerUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .anythingArray(let x):
            try container.encode(x)
        case .awayScorerClass(let x):
            try container.encode(x)
        }
    }
}

// MARK: - AwayScorerClass
struct AwayScorerClass: Codable {
    let scorerIn: String
    let out: String?
    let inID, outID: Int

    enum CodingKeys: String, CodingKey {
        case scorerIn = "in"
        case out
        case inID = "in_id"
        case outID = "out_id"
    }
}

enum InfoTime: String, Codable {
    case the1StHalf = "1st Half"
    case the2NdHalf = "2nd Half"
}

enum Score: String, Codable {
    case substitution = "substitution"
}

// MARK: - Vars
struct Vars: Codable {
    let homeTeam, awayTeam: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case homeTeam = "home_team"
        case awayTeam = "away_team"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
