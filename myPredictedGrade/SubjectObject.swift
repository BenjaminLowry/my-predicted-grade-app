//
//  SubjectEnum.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/28/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import Foundation

class SubjectObject: NSObject, NSCoding, NSCopying {
    
    var isHL: Bool
    var subject: Subject
    
    var valueDictionary: [String: Subject] =
    ["English A Literature": Subject.EnglishALit,
     "English A Language and Literature": Subject.EnglishALangLit,
     "Chinese A Literature": Subject.ChineseALit,
     "Chinese A Language and Literature": Subject.ChineseALangLit,
     "Spanish Ab Initio": Subject.SpanishAb,
     "Spanish B": Subject.SpanishB,
     "Chinese Ab Initio": Subject.ChineseAb,
     "Chinese B": Subject.ChineseB,
     "French Ab Initio": Subject.FrenchAb,
     "French B": Subject.FrenchB,
     "German Ab Initio": Subject.GermanAb,
     "German B": Subject.GermanB,
     "Business Management": Subject.BusinessManagement,
     "Economics": Subject.Economics,
     "Geography": Subject.Geography,
     "History": Subject.History,
     "Information Technology in a Global Society": Subject.InformationTechonologyinaGlobalSociety,
     "Philosophy": Subject.Philosophy,
     "Psychology": Subject.Psychology,
     "Social and Cultural Anthropology": Subject.SocialandCulturalAnthropology,
     "World Relgions": Subject.WorldReligions,
     "Global Politics": Subject.GlobalPolitics,
     "Biology": Subject.Biology,
     "Chemistry": Subject.Chemistry,
     "Computer Science": Subject.ComputerScience,
     "Design Technology": Subject.DesignTechnology,
     "Environmental Systems and Societies": Subject.EnvironmentalSystemsandSocities,
     "Physics": Subject.Physics,
     "Sports Excercise and Health Science": Subject.SportsExcerciseandHealthScience,
     "Mathematics Studies": Subject.MathematicsStudies,
     "Mathematics": Subject.Mathematics,
     "Further Mathematics": Subject.FurtherMathematics,
     "Dance": Subject.Dance,
     "Film": Subject.Film,
     "Music": Subject.Music,
     "Music Creating": Subject.MusicCreating,
     "Theatre": Subject.Theatre,
     "Visual Arts": Subject.VisualArts]
    
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
        
        //for void values of subject
        case Default = "Default"
        
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
            case .Default:
                return 666
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
    
    
    init(subject: Subject, isHL: Bool) {
        
        self.subject = subject
        self.isHL = isHL
        
    }
    
    func toString() -> String {
        return subject.rawValue + (isHL ? " HL" : " SL")
    }
    
    func toShortString() -> String {
        return subject.shortName + (isHL ? " HL" : " SL")
    }
    
    func subjectValue(forString string: String) -> SubjectObject? {
        var subjectString = string
        var isHL = false
        if subjectString.contains("HL") {
            subjectString.removeSubrange(subjectString.range(of: " HL")!)
            isHL = true
        } else {
            subjectString.removeSubrange(subjectString.range(of: " SL")!)
        }
        
        if let subject = valueDictionary[subjectString] {
            return SubjectObject(subject: subject, isHL: isHL)
        } else {
            return nil
        }
    }
    
    //for comparing subjectObjects
    static func == (lhs: SubjectObject, rhs: SubjectObject) -> Bool {
        return (lhs.subject == rhs.subject) && (lhs.isHL == rhs.isHL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        //random initialization to shut compiler up
        self.subject = .GermanB
        self.isHL = false
        
        super.init()
        
        let subjectString = aDecoder.decodeObject(forKey: "SubjectString") as! String
        print(subjectString)
        self.subject = (subjectValue(forString: subjectString)?.subject)!
        print(self.subject.rawValue)
        print(aDecoder.decodeBool(forKey: "isHL"))
        
        self.isHL = aDecoder.decodeBool(forKey: "isHL")
        
    }

    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.toString(), forKey: "SubjectString")
        aCoder.encode(self.isHL, forKey: "isHL")
        
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
}


