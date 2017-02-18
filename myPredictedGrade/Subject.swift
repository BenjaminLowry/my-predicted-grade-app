//
//  SubjectEnum.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/28/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import Foundation

enum Subject: String {
    //start of group 1: language and literature
    case EnglishALit = "English A Literature"
    case EnglishALangLit = "English A Language and Literature"
    case ChineseALit = "Chinese A Literature"
    case ChineseALangLit = "Chinese A Language and Literature"
    
    //start of group 2: language acquisition
    case SpanishAb = "Spanish Ab Initio"
    case SpanishB = "Spanish B"
    case ChineseAb = "Chinese Ab Initio"
    case ChineseB = "Chinese B"
    case FrenchAb = "French Ab Initio"
    case FrenchB = "French B"
    case GermanAb = "German Ab Initio"
    case GermanB = "German B"
    
    //start of group 3: individuals and socities
    case BusinessManagement = "Business Management"
    case Economics = "Economics"
    case Geography = "Geography"
    case History = "History"
    case InformationTechonologyinaGlobalSociety = "Information Technology in a Global Society"
    case Philosophy = "Philosophy"
    case Psychology = "Psychology"
    case SocialandCulturalAnthropology = "Social and Cultural Anthropology"
    case WorldReligions = "World Religions"
    case GlobalPolitics = "Global Politics"
    
    //start of group 4: science
    case Biology = "Biology"
    case Chemistry = "Chemistry"
    case ComputerScience = "Computer Science"
    case DesignTechnology = "Design Technology"
    case EnvironmentalSystemsandSocities = "Environmental Systems and Societies"
    case Physics = "Physics"
    case SportsExcerciseandHealthScience = "Sports Excercise and Health Science"
    
    //start of group 5: mathematics
    case MathematicsStudies = "Mathematics Studies"
    case Mathematics = "Mathematics"
    case FurtherMathematics = "Further Mathematics"
    
    //start of group 6: arts
    case Dance = "Dance"
    case Film = "Film"
    case Music = "Music"
    case MusicCreating = "Music Creating"
    case Theatre = "Theatre"
    case VisualArts = "Visual Arts"
    
    var sortIndex: Int {
        switch self {
        //start of group 1: language and literature
        case .EnglishALit, .EnglishALangLit, .ChineseALit, .ChineseALangLit:
            return 1
        //start of group 2: language acquisition
        case .SpanishAb, .SpanishB, .ChineseAb, .ChineseB, .FrenchAb, .FrenchB, .GermanAb, .GermanB:
            return 2
        //start of group 3: individuals and socities
        case .BusinessManagement, .Economics, .Geography, .History, .InformationTechonologyinaGlobalSociety, .Philosophy, .Psychology, .SocialandCulturalAnthropology, .WorldReligions, .GlobalPolitics:
            return 3
        //start of group 4: science
        case .Biology, .Chemistry, .ComputerScience, .DesignTechnology, .EnvironmentalSystemsandSocities, .Physics, .SportsExcerciseandHealthScience:
            return 4
        //start of group 5: mathematics
        case .MathematicsStudies, .Mathematics, .FurtherMathematics:
            return 5
        //start of group 6: arts
        case .Dance, .Film, .Music, .MusicCreating, .Theatre, .VisualArts:
            return 6
        }
        
    }
    
    var shortName: String {
        switch self {
        case .EnglishALit:
            return "Eng A Lit"
        case .EnglishALangLit:
            return "Eng A LangLit"
        case .ChineseALit:
            return "Chin A Lit"
        case .ChineseALangLit:
            return "Chin A LangLit"
        case .SpanishAb:
            return "Spanish Ab"
        case .ChineseAb:
            return "Chinese Ab"
        case .FrenchAb:
            return "French Ab"
        case .GermanAb:
            return "German Ab"
        case .InformationTechonologyinaGlobalSociety:
            return "ITGS"
        case .SocialandCulturalAnthropology:
            return "S&CA"
        case .EnvironmentalSystemsandSocities:
            return "ESS"
        case .SportsExcerciseandHealthScience:
            return "SE&HS"
        case .MathematicsStudies:
            return "Math Studies"
        case .Mathematics:
            return "Math"
        case .FurtherMathematics:
            return "Fur. Math"
        default:
            return ""
        }
        
    }
    
}

