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
     "Spanish A Literature": Subject.SpanishALit,
     "Spanish A Language and Literature": Subject.SpanishALangLit,
     "Arabic A Language and Literature": Subject.ArabicALangLit,
     "Arabic A Literature": Subject.ArabicALit,
     "Catalan A Literature": Subject.CatalanALit,
     "Danish A Literature": Subject.DanishALit,
     "Dutch A Language and Literature": Subject.DutchALangLit,
     "Dutch A Literature": Subject.DutchALit,
     "Finnish A Literature": Subject.FinnishALit,
     "French A Language and Literature": Subject.FrenchALangLit,
     "French A Literature": Subject.FrenchALit,
     "German A Language and Literature": Subject.GermanALangLit,
     "German A Literature": Subject.GermanALit,
     "Indonesian A Language and Literature": Subject.IndonesianALangLit,
     "Indonesian A Literature": Subject.IndonesianALit,
     "Italian A Literature": Subject.ItalianALit,
     "Japanese A Language and Literature": Subject.JapaneseALangLit,
     "Japanese A Literature": Subject.JapaneseALit,
     "Korean A Literature": Subject.KoreanALit,
     "Literature and Performance": Subject.LiteraturePerformance,
     "Malay A Literature": Subject.MalayALit,
     "Modern Greek A Literature": Subject.ModernGreekALit,
     "Norwegian A Literature": Subject.NorwegianALit,
     "Polish A Literature": Subject.PolishALit,
     "Portuguese A Language and Literature": Subject.PortugueseALangLit,
     "Russian A Literature": Subject.RussianALit,
     "Swedish A Language and Literature": Subject.SwedishALangLit,
     "Swedish A Literature": Subject.SwedishALit,
     "Thai A Language and Literature": Subject.ThaiALangLit,
     "Turkish A Literature": Subject.TurkishALit,
     "Spanish Ab Initio": Subject.SpanishAb,
     "Spanish B": Subject.SpanishB,
     "Mandarin Ab Initio": Subject.MandarinAb,
     "Mandarin B": Subject.MandarinB,
     "French Ab Initio": Subject.FrenchAb,
     "French B": Subject.FrenchB,
     "German Ab Initio": Subject.GermanAb,
     "German B": Subject.GermanB,
     "English Ab Initio": Subject.EnglishAb,
     "English B": Subject.EnglishB,
     "Arabic Ab Initio": Subject.ArabicAb,
     "Arabic B": Subject.ArabicB,
     "Cantonese B": Subject.CantoneseB,
     "Danish B": Subject.DanishB,
     "Dutch B": Subject.DutchB,
     "Hindi B": Subject.HindiB,
     "Indonesian B": Subject.IndonesianB,
     "Italian Ab Initio": Subject.ItalianAb,
     "Italian B": Subject.ItalianB,
     "Japanese Ab Initio": Subject.JapaneseAb,
     "Japanese B": Subject.JapaneseB,
     "Latin": Subject.Latin,
     "Norwegian B": Subject.NorwegianB,
     "Russian Ab Initio": Subject.RussianAb,
     "Russian B": Subject.RussianB,
     "Swedish B": Subject.SwedishB,
     "Business Management": Subject.BusinessManagement,
     "Economics": Subject.Economics,
     "Geography": Subject.Geography,
     "History": Subject.History,
     "Information Technology in a Global Society": Subject.InformationTechonologyinaGlobalSociety,
     "Philosophy": Subject.Philosophy,
     "Psychology": Subject.Psychology,
     "Social and Cultural Anthropology": Subject.SocialCulturalAnthropology,
     "World Relgions": Subject.WorldReligions,
     "Global Politics": Subject.GlobalPolitics,
     "Brazilian Social Studies": Subject.BrazSocStud,
     "Turkey in the 20th Century": Subject.Turkey20thCentury,
     "Biology": Subject.Biology,
     "Chemistry": Subject.Chemistry,
     "Computer Science": Subject.ComputerScience,
     "Design Technology": Subject.DesignTechnology,
     "Environmental Systems and Societies": Subject.EnvironmentalSystemsandSocities,
     "Physics": Subject.Physics,
     "Sports Excercise and Health Science": Subject.SportsExcerciseandHealthScience,
     "Marine Science": Subject.MarineScience,
     "Mathematics Studies": Subject.MathematicsStudies,
     "Mathematics": Subject.Mathematics,
     "Further Mathematics": Subject.FurtherMathematics,
     "Dance": Subject.Dance,
     "Film": Subject.Film,
     "Music": Subject.Music,
     "Music Creating": Subject.MusicCreating,
     "Music Group Performance": Subject.MusicGroupPerformance,
     "Music Solo Performance": Subject.MusicSoloPerformance,
     "Theatre": Subject.Theatre,
     "Visual Arts": Subject.VisualArts,
     "Theory of Knowledge": Subject.TheoryOfKnowledge,
     "Extended Essay": Subject.ExtendedEssay]
    
    enum Subject: String {
        // Start of group 1: Language and Literature
        case EnglishALit = "English A Literature"
        case EnglishALangLit = "English A Language and Literature"
        case ChineseALit = "Chinese A Literature"
        case ChineseALangLit = "Chinese A Language and Literature"
        case SpanishALit = "Spanish A Literature"
        case SpanishALangLit = "Spanish A Language and Literature"
        case ArabicALangLit = "Arabic A Language and Literature"
        case ArabicALit = "Arabic A Literature"
        case CatalanALit = "Catalan A Literature"
        case DanishALit = "Danish A Literature"
        case DutchALangLit = "Dutch A Language and Literature"
        case DutchALit = "Dutch A Literature"
        case FinnishALit = "Finnish A Literature"
        case FrenchALangLit = "French A Language and Literature"
        case FrenchALit = "French A Literature"
        case GermanALangLit = "German A Language and Literature"
        case GermanALit = "German A Literature"
        case IndonesianALangLit = "Indonesian A Language and Literature"
        case IndonesianALit = "Indonesian A Literature"
        case ItalianALit = "Italian A Literature"
        case JapaneseALangLit = "Japanese A Language and Literature"
        case JapaneseALit = "Japanese A Literature"
        case KoreanALit = "Korean A Literature"
        case LiteraturePerformance = "Literature and Performance"
        case MalayALit = "Malay A Literature"
        case ModernGreekALit = "Modern Greek A Literature"
        case NorwegianALit = "Norwegian A Literature"
        case PolishALit = "Polish A Literature"
        case PortugueseALangLit = "Portuguese A Language and Literature"
        case RussianALit = "Russian A Literature"
        case SwedishALangLit = "Swedish A Language and Literature"
        case SwedishALit = "Swedish A Literature"
        case ThaiALangLit = "Thai A Language and Literature"
        case TurkishALit = "Turkish A Literature"
        
        // Start of group 2: Language Acquisition
        case SpanishAb = "Spanish Ab Initio"
        case SpanishB = "Spanish B"
        case MandarinAb = "Mandarin Ab Initio"
        case MandarinB = "Mandarin B"
        case FrenchAb = "French Ab Initio"
        case FrenchB = "French B"
        case GermanAb = "German Ab Initio"
        case GermanB = "German B"
        case EnglishAb = "English Ab Initio"
        case EnglishB = "English B"
        case ArabicAb = "Arabic Ab Initio"
        case ArabicB = "Arabic B"
        case CantoneseB = "Cantonese B"
        case DanishB = "Danish B"
        case DutchB = "Dutch B"
        case HindiB = "Hindi B"
        case IndonesianB = "Indonesian B"
        case ItalianAb = "Italian Ab Initio"
        case ItalianB = "Italian B"
        case JapaneseAb = "Japanese Ab"
        case JapaneseB = "Japanese B"
        case Latin = "Latin"
        case NorwegianB = "Norwegian B"
        case RussianAb = "Russian Ab"
        case RussianB = "Russian B"
        case SwedishB = "Swedish B"
        
        // Start of group 3: Individuals and Socities
        case BusinessManagement = "Business Management"
        case Economics = "Economics"
        case Geography = "Geography"
        case History = "History"
        case InformationTechonologyinaGlobalSociety = "Information Technology in a Global Society"
        case Philosophy = "Philosophy"
        case Psychology = "Psychology"
        case SocialCulturalAnthropology = "Social and Cultural Anthropology"
        case WorldReligions = "World Religions"
        case GlobalPolitics = "Global Politics"
        case BrazSocStud = "Brazilian Social Studies"
        case Turkey20thCentury = "Turkey in the 20th Century"
        
        // Start of group 4: Science
        case Biology = "Biology"
        case Chemistry = "Chemistry"
        case ComputerScience = "Computer Science"
        case DesignTechnology = "Design Technology"
        case EnvironmentalSystemsandSocities = "Environmental Systems and Societies"
        case Physics = "Physics"
        case SportsExcerciseandHealthScience = "Sports Excercise and Health Science"
        case MarineScience = "Marine Science"
        
        // Start of group 5: Mathematics
        case MathematicsStudies = "Mathematics Studies"
        case Mathematics = "Mathematics"
        case FurtherMathematics = "Further Mathematics"
        
        // Start of group 6: Arts
        case Dance = "Dance"
        case Film = "Film"
        case Music = "Music"
        case MusicCreating = "Music Creating"
        case MusicGroupPerformance = "Music Group Performance"
        case MusicSoloPerformance = "Music Solo Performance"
        case Theatre = "Theatre"
        case VisualArts = "Visual Arts"
        
        // Others
        case TheoryOfKnowledge = "Theory of Knowledge"
        case ExtendedEssay = "Extended Essay"
        
        // For void values of subject
        case Default = "Default"
        
        // TODO: - Should deprecate due to use of hash values to sort
        /*var sortIndex: Int {
            switch self {
            //start of group 1: language and literature
            case .EnglishALit, .EnglishALangLit, .ChineseALit, .ChineseALangLit, .SpanishALit, .SpanishALangLit:
                return 1
            //start of group 2: language acquisition
            case .SpanishAb, .SpanishB, .ChineseAb, .ChineseB, .FrenchAb, .FrenchB, .GermanAb, .GermanB, .EnglishAb, .EnglishB:
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
            //others
            case .TheoryOfKnowledge, .ExtendedEssay:
                return 7
            case .Default:
                return 666
            }
            
        }*/
        
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
            case .SpanishALit:
                return "Span A Lit"
            case .SpanishALangLit:
                return "Span A LangLit"
            case .ArabicALit:
                return "Arab A Lit"
            case .ArabicALangLit:
                return "Arab A LangLit"
            case .CatalanALit:
                return "Catalan A Lit"
            case .DanishALit:
                return "Danish A Lit"
            case .DutchALit:
                return "Dtch A Lit"
            case .DutchALangLit:
                return "Dtch A LangLit"
            case .FinnishALit:
                return "Finnish A Lit"
            case .FrenchALit:
                return "Fren A Lit"
            case .FrenchALangLit:
                return "Fren A LangLit"
            case .GermanALit:
                return "Germ A Lit"
            case .GermanALangLit:
                return "Germ A LangLit"
            case .IndonesianALit:
                return "Indo A Lit"
            case .IndonesianALangLit:
                return "Indo A LangLit"
            case .ItalianALit:
                return "Italian A Lit"
            case .JapaneseALit:
                return "Japn A Lit"
            case .JapaneseALangLit:
                return "Japn A LangLit"
            case .KoreanALit:
                return "Korean A Lit"
            case .LiteraturePerformance:
                return "Lit & Perf"
            case .MalayALit:
                return "Malay A Lit"
            case .ModernGreekALit:
                return "Mdn Grk A Lit"
            case .NorwegianALit:
                return "Norw A Lit"
            case .PolishALit:
                return "Polish A Lit"
            case .PortugueseALangLit:
                return "Port A LangLit"
            case .RussianALit:
                return "Russian A Lit"
            case .SwedishALit:
                return "Swed A Lit"
            case .SwedishALangLit:
                return "Swed A LangLit"
            case .ThaiALangLit:
                return "Thai A LangLit"
            case .TurkishALit:
                return "Turkish A Lit"
            case .SpanishAb:
                return "Spanish Ab"
            case .MandarinAb:
                return "Mandarin Ab"
            case .FrenchAb:
                return "French Ab"
            case .GermanAb:
                return "German Ab"
            case .EnglishAb:
                return "English Ab"
            case .ArabicAb:
                return "Arabic Ab"
            case .ItalianAb:
                return "Italian Ab"
            case .JapaneseAb:
                return "Japanese Ab"
            case .RussianAb:
                return "Russian Ab"
            case .BusinessManagement:
                return "Business"
            case .DesignTechnology:
                return "DT"
            case .InformationTechonologyinaGlobalSociety:
                return "ITGS"
            case .SocialCulturalAnthropology:
                return "S&CA"
            case .EnvironmentalSystemsandSocities:
                return "ESS"
            case .BrazSocStud:
                return "Brz Soc Stud"
            case .Turkey20thCentury:
                return "Turk 20th"
            case .SportsExcerciseandHealthScience:
                return "SE&HS"
            case .MathematicsStudies:
                return "Math Studies"
            case .Mathematics:
                return "Math"
            case .FurtherMathematics:
                return "Fur. Math"
            case .ComputerScience:
                return "CompSci"
            case .MusicGroupPerformance:
                return "Music Grp Perf"
            case .MusicSoloPerformance:
                return "Music Sol Perf"
            case .TheoryOfKnowledge:
                return "TOK"
            case .ExtendedEssay:
                return "EE"
            default:
                return self.rawValue
            }
            
        }
        
    }
    
    init(subject: Subject, isHL: Bool) {
        
        self.subject = subject
        self.isHL = isHL
        
    }
    
    func toString() -> String {
        if subject == .TheoryOfKnowledge || subject == .ExtendedEssay {
            return subject.rawValue
        }
        return subject.rawValue + (isHL ? " HL" : " SL")
    }
    
    func toShortString() -> String {
        if subject == .TheoryOfKnowledge || subject == .ExtendedEssay {
            return subject.shortName
        }
        return subject.shortName + (isHL ? " HL" : " SL")
    }
    
    func subjectValue(forString string: String) -> SubjectObject? {
        var subjectString = string
        var isHL = false
        if subjectString.contains("HL") {
            subjectString.removeSubrange(subjectString.range(of: " HL")!)
            isHL = true
        } else if subjectString.contains("SL") { // TOK and EE have neither, so must check
            subjectString.removeSubrange(subjectString.range(of: " SL")!)
        }
        
        // Safety conversion for old names of Mandarin Ab/B
        if subjectString == "Chinese Ab Initio" {
            return SubjectObject(subject: .MandarinAb, isHL: false)
        } else if subjectString == "Chinese B" {
            return SubjectObject(subject: .MandarinB, isHL: isHL)
        }
        
        if let subject = valueDictionary[subjectString] {
            return SubjectObject(subject: subject, isHL: isHL)
        } else {
            return nil
        }
    }
    
    // For comparing SubjectObjects
    static func == (lhs: SubjectObject, rhs: SubjectObject) -> Bool {
        return (lhs.subject == rhs.subject) && (lhs.isHL == rhs.isHL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        // Random initialization to shut compiler up
        self.subject = .GermanB
        self.isHL = false
        
        super.init()
        
        let subjectString = aDecoder.decodeObject(forKey: "SubjectString") as! String
        
        self.subject = (subjectValue(forString: subjectString)?.subject)!
        
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


