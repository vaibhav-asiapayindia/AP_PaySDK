//
//  EnvBase.swift
//  PayDollarSDK
//
//  Created by AsiaPay Limited on 22/04/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//

import Foundation
//import PassKit

public enum Language: String {
    case ENGLISH = "E"
    case CHINESE_TRADITIONAL = "C"
    case CHINESE_SIMPLIFIED = "X"
    case JAPANESE = "J"
    case THAI = "T";
    case FRENCH = "F"
    case GERMAN = "G"
    case RUSSIAN = "R"
    case SPANISH = "S"
    case VIETNAMESE = "V"
}

public enum payMethod : String {
    case ALL = "ALL"
    case CREDIT_CARD = "CC"
    case VISA = "VISA"
    case MASTER_CARD = "Master"
    case JAPAN_CARD = "JCB"
    case AMERICAN_CARD = "AMEX"
    case DINER = "Diners"
    case ALIPAYHKAPP = "ALIPAYHKAPP"
    case ALIPAYCNAPP = "ALIPAYCNAPP"
    case ALIPAYAPP = "ALIPAYAPP"
}

public enum payType : String {
    case NORMAL_PAYMENT = "N"
    case HOLD_PAYMENT = "H"
}

public enum PayGate: String {
    case PAYDOLLAR = "1"
    case PESOPAY = "11"
    case SIAMPAY = "12"
}

public enum PayChannel : String{
    case WEBVIEW = "WebView"
    case DIRECT = "Direct"
    //case INDIRECT = "Indirect"
}

public enum EnvType: String {
    case SANDBOX = "SANDBOX"
    case PRODUCTION = "Production"
    //case SIT = "Sit"
}

enum PayGate_uat : String {
    case PAYDOLLAR = "https://test.paydollar.com/"
    case PESOPAY = "https://test.pesopay.com/"
    case SIAMPAY = "https://test.siampay.com/"
}


//enum PayGate_sit : String {
//    case PAYDOLLAR = "https://test.paydollar.com/"
//    case PESOPAY = "https://test.pesopay.com/"
//    case SIAMPAY = "https://test.siampay.com/"
//}


enum PayGate_production : String {
    case PAYDOLLAR = "https://www.paydollar.com/"
    case PESOPAY = "https://www.pesopay.com/"
    case SIAMPAY = "https://www.siampay.com/"
}


public enum currencyCode : String {
    
    case HKD = "344"
    case USD = "840"
    case SGD = "702"
    case RMB = "156"
    case YEN ,JPY = "392"
    case TWD = "901"
    case AUD = "036"
    case EUR = "978"
    case GBP = "826"
    case CAD = "124"
    case MOP = "446"
    case PHP = "608"
    case THB = "764"
    case IDR = "360"
    case BND = "096"
    case MYR = "458"
    case BRL = "986"
    case INR = "356"
    case TRY = "949"
    case ZAR = "710"
    case VND = "704"
    case LKR = "144"
    case KWD = "414"
    case NZD = "554"
}

enum SecureMethod {
    case  SHA_1, MD5 , SHA_2, NONE
}

//public enum ApplePayButtonType  : Int {
//    case Plain
//    case Buy
//    case SetUp
//    case InStore
//    case Donate
//    case Checkout
//    case Book
//    case Subscribe
//}

//public enum ApplePayButtonStyle : Int {
//    case White
//    case WhiteOutline
//    case Black
//}


//enum CardType: String {
//    case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay
//    
//    static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]
//    
//    var regex : String {
//        switch self {
//        case .Amex:
//            return "^3[47][0-9]{5,}$"
//        case .Visa:
//            return "^4[0-9]{6,}([0-9]{3})?$"
//        case .MasterCard:
//            return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
//        case .Diners:
//            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
//        case .Discover:
//            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
//        case .JCB:
//            return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
//        case .UnionPay:
//            return "^(62|88)[0-9]{5,}$"
//        case .Hipercard:
//            return "^(606282|3841)[0-9]{5,}$"
//        case .Elo:
//            return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
//        default:
//            return ""
//        }
//    }
//}

//protocol prcEnum {
//var description: String { get}
//}
//
//public enum prc: String , prcEnum {
//case "0" = "Seccess"
//case REJ_PAY_BANK = 1
//case REJ_AUTH_FAIL = 3
//case REJ_PAR_INCORRECT = -1
//case REJ_SERVER_ERROR = -2
//case REJ_PD_FRAUD_PREVENTION_CHECK = -8
//case REJ_HOST_ACCESS_ERROR = -9
//
//var description: String {
//switch self {
//case .SUCCESS:
//return "Success"
//case .REJ_PAY_BANK:
//return "Rejected by Payment Bank"
//case .REJ_AUTH_FAIL:
//return "Rejected due to Payer Authentication Failure (3D)"
//case .REJ_PAR_INCORRECT:
//return "Rejected due to Input Parameters Incorrect"
//case .REJ_SERVER_ERROR:
//return "Rejected due to Server Access Error"
//case .REJ_PD_FRAUD_PREVENTION_CHECK:
//return "Rejected due to PayDollar Internal/Fraud Prevention Checking"
//case .REJ_HOST_ACCESS_ERROR:
//return "Rejected by Host Access Error"
//}
//}
//case 0 = "Success"
//case 1 = "Rejected by Payment Bank"
//case 3 = "Rejected due to Payer Authentication Failure (3D)"
//case -1 = "Rejected due to Input Parameters Incorrect"
//case -2 = "Rejected due to Server Access Error"
//case -8 = "Rejected due to PayDollar Internal/Fraud Prevention Checking"
//case -9 = "Rejected by Host Access Error"
//}
//public enum countryCode : String {
//case A2 = "Satellite Provider"
//case AD = "Andorra"
//case AE = "United Arab Emirates"
//case AF = "Afghanistan"
//case AG = "Antigua and Barbuda"
//case AI = "Anguilla"
//case AL = "Albania"
//case AM = "Armenia"
//case AN = "Netherlands Antilles"
//case AO = "Angola"
//case AP = "Asia/Pacific Region"
//case AQ = "Antarctica"
//case AR = "Argentina"
//case AS = "American Samoa"
//case AT = "Austria"
//case AU = "Australia"
//case AW = "Aruba"
//case AZ = "Azerbaijan"
//case BA = "Bosnia and Herzegovina"
//case BB = "Barbados"
//case BD = "Bangladesh"
//case BE = "Belgium"
//case BF = "Burkina Faso"
//case BG = "Bulgaria"
//case BH = "Bahrain"
//case BI = "Burundi"
//case BJ = "Benin"
//case BM = "Bermuda"
//case BN = "Brunei Darussalam"
//case BO = "Bolivia"
//case BR = "Brazil"
//case BS = "Bahamas"
//case BT = "Bhutan"
//case BV = "Bouvet Island"
//case BW = "Botswana"
//case BY = "Belarus"
//case BZ = "Belize"
//case CA = "Canada"
//case CD,CG = "Congo"
//case CF = "Central African Republic"
//case CH = "Switzerland"
//case CI = "Cote D'Ivoire"
//case CK = "Cook Islands"
//case CL = "Chile"
//case CM = "Cameroon"
//case CN = "China"
//case CO = "Colombia"
//case CR = "Costa Rica"
//case CU = "Cuba"
//case CV = "Cape Verde"
//case CY = "Cyprus"
//case CZ = "Czech Republic"
//case DE = "Germany"
//case DJ = "Djibouti"
//case DK = "Denmark"
//case DM = "Dominica"
//case DO = "Dominican Republic"
//case DZ = "Algeria"
//case EC = "Ecuador"
//case EE = "Estonia"
//case EG = "Egypt"
//case ER = "Eritrea"
//case ES = "Spain"
//case ET = "Ethiopia"
//case EU = "Europe"
//case FI = "Finland"
//case FJ = "Fiji"
//case FK = "Falkland Islands (Malvinas)"
//case FM = "Micronesia"
//case FO = "Faroe Islands"
//case FR = "France"
//case GA = "Gabon"
//case GB = "United Kingdom"
//case GD = "Grenada"
//case GE = "Georgia"
//case GF = "French Guiana"
//case GH = "Ghana"
//case GI = "Gibraltar"
//case GL = "Greenland"
//case GM = "Gambia"
//case GN = "Guinea"
//case GP = "Guadeloupe"
//case GQ = "Equatorial Guinea"
//case GR = "Greece"
//case GT = "Guatemala"
//case GU = "Guam"
//case GW = "Guinea-Bissau"
//case GY = "Guyana"
//case HK = "Hong Kong"
//case HM = "Heard Island and McDonald Islands"
//case HN = "Honduras"
//case HR = "Croatia"
//case HT = "Haiti"
//case HU = "Hungary"
//case ID = "Indonesia"
//case IE = "Ireland"
//case IL = "Israel"
//case IN = "India"
//case IO = "British Indian Ocean Territory"
//case IQ = "Iraq"
//case IR = "Iran"
//case IS = "Iceland"
//case IT = "Italy"
//case JM = "Jamaica"
//case JO = "Jordan"
//case JP = "Japan"
//case KE = "Kenya"
//case KG = "Kyrgyzstan"
//case KH = "Cambodia"
//case KI = "Kiribati"
//case KM = "Comoros"
//case KN = "Saint Kitts and Nevis"
//case KP,KR = "Korea"
//case KW = "Kuwait"
//case KY = "Cayman Islands"
//case KZ = "Kazakstan"
//case LA = "Lao People's Democratic Republic"
//case LB = "Lebanon"
//case LC = "Saint Lucia"
//case LI = "Liechtenstein"
//case LK = "Sri Lanka"
//case LR = "Liberia"
//case LS = "Lesotho"
//case LT = "Lithuania"
//case LU = "Luxembourg"
//case LV = "Latvia"
//case LY = "Libyan Arab Jamahiriya"
//case MA = "Morocco"
//case MC = "Monaco"
//case MD = "Moldova"
//case MG = "Madagascar"
//case MH = "Marshall Islands"
//case MK = "Macedonia"
//case ML = "Mali"
//case MM = "Myanmar"
//case MN = "Mongolia"
//case MO = "Macau"
//case MP = "Northern Mariana Islands"
//case MQ = "Martinique"
//case MR = "Mauritania"
//case MS = "Montserrat"
//case MT = "Malta"
//case MU = "Mauritius"
//case MV = "Maldives"
//case MW = "Malawi"
//case MX = "Mexico"
//case MY = "Malaysia"
//case MZ = "Mozambique"
//case NA = "Namibia"
//case NC = "New Caledonia"
//case NE = "Niger"
//case NF = "Norfolk Island"
//case NG = "Nigeria"
//case NI = "Nicaragua"
//case NL = "Netherlands"
//case NO = "Norway"
//case NP = "Nepal"
//case NR = "Nauru"
//case NZ = "New Zealand"
//case OM = "Oman"
//case PA = "Panama"
//case PE = "Peru"
//case PF = "French Polynesia"
//case PG = "Papua New Guinea"
//case PH = "Philippines"
//case PK = "Pakistan"
//case PL = "Poland"
//case PR = "Puerto Rico"
//case PS = "Palestinian Territory"
//case PT = "Portugal"
//case PW = "Palau"
//case PY = "Paraguay QA Qatar"
//case RE = "Reunion"
//case RO = "Romania"
//case RU = "Russian Federation"
//case RW = "Rwanda"
//case SA = "Saudi Arabia"
//case SB = "Solomon Islands"
//case SC = "Seychelles"
//case SD = "Sudan"
//case SE = "Sweden"
//case SG = "Singapore"
//case SI = "Slovenia"
//case SK = "Slovakia"
//case SL = "Sierra Leone"
//case SM = "San Marino"
//case SN = "Senegal"
//case SO = "Somalia"
//case SR = "Suriname"
//case ST = "Sao Tome and Principe"
//case SV = "El Salvador"
//case SY = "Syrian Arab Republic"
//case SZ = "Swaziland"
//case TC = "Turks and Caicos Islands"
//case TD = "Chad"
//case TF = "French Southern Territories"
//case TG = "Togo"
//case TH = "Thailand"
//case TJ = "Tajikistan"
//case TK = "Tokelau"
//case TM = "Turkmenistan"
//case TN = "Tunisia"
//case TO = "Tonga"
//case TR = "Turkey"
//case TT = "Trinidad and Tobago"
//case TV = "Tuvalu"
//case TW = "Taiwan"
//case TZ = "Tanzania"
//case UA = "Ukraine"
//case UG = "Uganda"
//case UM = "United States Minor Outlying Islands"
//case US = "United States"
//case UY = "Uruguay"
//case UZ = "Uzbekistan"
//case VA = "Holy See (Vatican City State)"
//case VC = "Saint Vincent and the Grenadines"
//case VE = "Venezuela"
//case VG,VI = "Virgin Islands"
//case VN = "Vietnam"
//case VU = "Vanuatu"
//case WF = "Wallis and Futuna"
//case WS = "Samoa"
//case YE = "Yemen"
//case YT = "Mayotte"
//case YU = "Yugoslavia"
//case ZA = "South Africa"
//case ZM = "Zambia"
//case ZW = "Zimbabwe"
//}
