import {AfterViewInit, Component, Injectable, OnInit, Output, ViewEncapsulation} from '@angular/core';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import {ActivatedRoute} from "@angular/router";
import {FormControl} from '@angular/forms';
import {MatDialog} from "@angular/material/dialog";
import {PatientComponent} from "../patient/patient.component";
import {Globals} from '../globals'
import {ngxCsv} from "ngx-csv";
import {BehaviorSubject, Observable} from "rxjs";
import {MatTreeFlatDataSource, MatTreeFlattener} from "@angular/material/tree";
import {FlatTreeControl} from "@angular/cdk/tree";
import {SelectionModel} from "@angular/cdk/collections";

interface widget {
  icon: string;
  name: string;
}

interface dashboardQuery {
  selectedVisualisation1: string;
  xAxisLabel1: string;
  yAxisLabel1: string;
  visualType: widget[];
}

/**
 * Node for orgitem
 */
export class OrgItemNode {
  children: OrgItemNode[];
  item: string;
}

/** Flat orgitem node with expandable and level information */
export class OrgItemFlatNode {
  item: string;
  level: number;
  expandable: boolean;
}

/**
 * The Json object for orglist data.
 */
const ORG_DATA = {
  "North East London STP":{
    "NEL NHS111":{
      "NEL NHS111":[
        "NEL NHS111"
      ]
    },
    "BHRUT":{
      "BHRUT":[
        "BHRUT"
      ]
    },
    "BARTS":{
      "BARTS":[
        "BARTS"
      ]
    },
    "HOMERTON":{
      "HOMERTON":[
        "HOMERTON"
      ]
    },
    "NHS BARKING AND DAGENHAM CCG":{
      "East ONE PCN":[
        "DR C OLA'S PRACTICE",
        "DR DP SHAH'S PRACTICE",
        "DR KM ALKAISY PRACTICE",
        "DR M FATEH'S PRACTICE",
        "HEATHWAY MEDICAL CENTRE",
        "HEDGEMANS MEDICAL CENTRE",
        "ST ALBANS SURGERY"
      ],
      "East PCN":[
        "DR M GOYAL'S PRACTICE",
        "HALBUTT STREET SURGERY",
        "PORTERS AVENUE SURGERY",
        "PRIME PRACTICE PARTNERSHIP"
      ],
      "New West PCN":[
        "ABBEY MEDICAL CENTRE",
        "AURORA MEDCARE",
        "SHIFA MEDICAL PRACTICE",
        "VICTORIA MEDICAL CENTRE"
      ],
      "North PCN":[
        "DR A ARIF",
        "DR BK JAISWAL'S PRACTICE",
        "DR P PRASAD'S PRACTICE",
        "DR SZ HAIDER'S PRACTICE",
        "FIVE ELMS MEDICAL PRACTICE",
        "GABLES SURGERY",
        "GREEN LANE SURGERY",
        "LABURNUM HEALTH CENTRE",
        "THE OVAL PRACTICE"
      ],
      "North West PCN":[
        "DR A MOGHAL'S PRACTICE",
        "MARKS GATE HEALTH CENTRE",
        "TULASI MEDICAL CENTRE"
      ],
      "West One (NW1) PCN":[
        "BARKING MEDICAL GROUP PRACTICE",
        "DR AA ANSARI'S PRACTICE",
        "DR R CHIBBER'S PRACTICE",
        "HIGHGROVE SURGERY",
        "JOHN SMITH MEDICAL CENTRE",
        "THE WHITE HOUSE SURGERY"
      ]
    },
    "NHS CITY AND HACKNEY CCG":{
      "Clissold Park PCN":[
        "BARTON HOUSE GROUP PRACTICE",
        "SOMERFORD GROVE PRACTICE",
        "THE SURGERY (BARRETTS GROVE)",
        "THE SURGERY (BROOKE ROAD)"
      ],
      "Hackney Downs PCN":[
        "FOUNTAYNE ROAD HEALTH CENTRE",
        "HEALY MEDICAL CENTRE",
        "ROSEWOOD PRACTICE",
        "THE CLAPTON SURGERY",
        "THE ELM PRACTICE",
        "THE NIGHTINGALE PRACTICE",
        "THE RIVERSIDE PRACTICE"
      ],
      "Hackney Marshes PCN":[
        "ATHENA MEDICAL CENTRE",
        "KINGSMEAD HEALTHCARE",
        "LATIMER HEALTH CENTRE",
        "LOWER CLAPTON GROUP PRACTICE",
        "THE LEA SURGERY"
      ],
      "London Fields PCN":[
        "BEECHWOOD MEDICAL CENTRE",
        "LONDON FIELDS MEDICAL CENTRE",
        "QUEENSBRIDGE GROUP PRACTICE",
        "RICHMOND ROAD MEDICAL CENTRE",
        "SANDRINGHAM PRACTICE",
        "THE DALSTON PRACTICE"
      ],
      "Shoreditch Park & City PCN":[
        "DE BEAUVOIR SURGERY",
        "SHOREDITCH PARK SURGERY",
        "SOUTHGATE ROAD MEDICAL CENTRE",
        "THE HOXTON SURGERY",
        "THE LAWSON PRACTICE",
        "THE NEAMAN PRACTICE"
      ],
      "Springfield Park PCN":[
        "SPRING HILL PRACTICE",
        "STAMFORD HILL GROUP PRACTICE",
        "THE SURGERY (CRANWICH ROAD)"
      ],
      "Well Street Common PCN":[
        "ELSDALE STREET SURGERY",
        "THE GREENHOUSE WALK-IN",
        "THE WICK HEALTH CENTRE",
        "TROWBRIDGE PRACTICE",
        "WELL STREET SURGERY"
      ],
      "Woodberry Wetlands PCN":[
        "THE ALLERTON ROAD SURGERY",
        "THE CEDAR PRACTICE",
        "THE HERON PRACTICE",
        "THE STATHAM GROVE SURGERY"
      ]
    },
    "NHS HAVERING CCG":{
      "Havering Crest PCN":[
        "BILLET LANE MEDICAL PRACTICE",
        "DR MARKS PRACTICE",
        "DR P & S POOLOGANATHAN",
        "DR SANOMI",
        "HIGH STREET SURGERY",
        "MODERN MEDICAL CENTRE",
        "ST EDWARDS MEDICAL CENTRE",
        "THE UPSTAIRS SURGERY"
      ],
      "Havering North PCN":[
        "ABBAMOOR SURGERY",
        "CENTRAL PARK SURGERY",
        "CHASE CROSS MEDICAL CENTRE",
        "CHOWDHURY",
        "DR A PATEL",
        "DR GUPTA",
        "INGREBOURNE MEDICAL CENTRE",
        "KINGS PARK SURGERY",
        "KUCCHAI",
        "LYNWOOD MEDICAL CENTRE",
        "PETERSFIELD SURGERY",
        "PRASAD",
        "THE GREEN WOOD PRACTICE",
        "THE ROBINS SURGERY, HAROLD HILL HEALTH C"
      ],
      "Marshall PCN":[
        "NORTH STREET MEDICAL CARE",
        "THE NEW MEDICAL CENTRE",
        "WESTERN ROAD MEDICAL CENTRE"
      ],
      "South PCN":[
        "BERWICK SURGERY",
        "CRANHAM HEALTH CENTRE",
        "CRANHAM VILLAGE SURGERY",
        "DR ABDULLAH",
        "DR PM PATEL",
        "DR VM PATEL",
        "HAIDERIAN MEDICAL CENTRE",
        "HARLOW ROAD SURGERY",
        "HORNCHURCH HEALTHCARE",
        "MAYLANDS HEALTHCARE",
        "RAHMAN & TSOI",
        "SPRING FARM SURGERY",
        "THE ROSEWOOD MEDICAL CENTRE",
        "UPMINSTER BRIDGE SURGERY",
        "UPMINSTER MEDICAL CENTRE",
        "WOOD LANE SURGERY"
      ]
    },
    "NHS NEWHAM CCG":{
      "Cental 1 PCN":[
        "BOLEYN MEDICAL CENTRE",
        "GREENGATE MEDICAL CENTRE",
        "MARKET STREET HEALTH GROUP",
        "NEWHAM MEDICAL CENTRE",
        "ST. BARTHOLOMEWS SURGERY",
        "THE AZAD PRACTICE",
        "THE PROJECT SURGERY"
      ],
      "Docklands PCN":[
        "ROYAL DOCKS MEDICAL PRACTICE",
        "THE PRACTICE ALBERT ROAD",
        "TOLLGATE MEDICAL CENTRE"
      ],
      "Leaside PCN":[
        "ABBEY ROAD MEDICAL PRACTICE",
        "CARPENTERS PRACTICE",
        "LIBERTY BRIDGE ROAD PRACTICE"
      ],
      "Newham Central PCN":[
        "BALAAM STREET PRACTICE",
        "BOLEYN ROAD PRACTICE",
        "ESSEX LODGE",
        "LUCAS AVENUE PRACTICE"
      ],
      "North East 1 PCN":[
        "BIRCHDALE ROAD MEDICAL CENTRE",
        "DR CM PATEL'S SURGERY",
        "PLASHET ROAD MEDICAL CENTRE",
        "SANGAM PRACTICE",
        "THE MANOR PARK PRACTICE",
        "WESTBURY ROAD MEDICAL PRACTICE"
      ],
      "North East 2 PCN":[
        "DR T KRISHNAMURTHY",
        "E12 MEDICAL CENTRE",
        "LATHOM ROAD MEDICAL CENTRE",
        "THE GRAHAM PRACTICE",
        "THE SHREWSBURY CENTRE",
        "THE SUMMITT PRACTICE"
      ],
      "North Newham PCN":[
        "CLAREMONT CLINIC",
        "FIRST 4 HEALTH GROUP - E7 HEALTH",
        "WOODGRANGE MEDICAL PRACTICE"
      ],
      "North West 2 PCN":[
        "DR SKS SWEDAN",
        "EAST END MEDICAL CENTRE",
        "STRATFORD HEALTH CENTRE",
        "THE FOREST PRACTICE",
        "UPTON LANE MEDICAL CENTRE"
      ],
      "South One Newham PCN":[
        "CUMBERLAND MEDICAL CENTRE",
        "CUSTOM HOUSE SURGERY",
        "ESK ROAD MEDICAL CENTRE",
        "GLEN ROAD MEDICAL CENTRE",
        "STAR LANE MEDICAL CENTRE",
        "THE RUIZ MEDICAL PRACTICE"
      ],
      "Stratford PCN":[
        "DR PCL KNIGHT",
        "DR SAMUEL AND DR KHAN",
        "E12 HEALTH",
        "NEWHAM TRANSITIONAL PRACTICE",
        "STRATFORD VILLAGE SURGERY"
      ],
      "Unknown1  PCN":[
        "DR T LWIN"
      ],
      "Unknown2  PCN":[
        "LORD LISTER HEALTH CENTRE"
      ]
    },
    "NHS REDBRIDGE CCG":{
      "Cranbrook PCN":[
        "BALFOUR ROAD SURGERY",
        "CRANBROOK SURGERY",
        "GANTS HILL MEDICAL CENTRE",
        "GRANVILLE MEDICAL CENTRE",
        "ST CLEMENT'S SURGERY",
        "THE DRIVE SURGERY",
        "THE REDBRIDGE SURGERY",
        "YORK ROAD SURGERY"
      ],
      "Fairlop PCN":[
        "FENCE PIECE ROAD MEDICAL CENTRE",
        "FULLWELL CROSS MED. CTR.",
        "HAINAULT SURGERY",
        "KENWOOD MEDICAL",
        "THE EASTERN AVENUE MEDICAL CENTRE",
        "THE FOREST EDGE PRACTICE",
        "THE FULLWELL AVENUE SURGERY",
        "THE HEATHCOTE PRIMARY CARE CENTRE",
        "THE WILLOWS PRACTICE"
      ],
      "Loxford PCN":[
        "AT MEDICS - THE LOXFORD PRACTICE",
        "ILFORD LANE SURGERY",
        "ILFORD MEDICAL CENTRE",
        "MATHUKIA'S SURGERY",
        "OAK TREE MEDICAL CENTRE"
      ],
      "Seven Kings PCN":[
        "CASTLETON ROAD HEALTH CENTRE",
        "CHADWELL HEATH SURGERY",
        "GOODMAYES MEDICAL CENTRE",
        "GREEN LANE, GOODMAYES MEDICAL PRACTICE",
        "GROVE SURGERY",
        "NEWBURY GROUP PRACTICE",
        "SEVEN KINGS PRACTICE",
        "THE DOCTORS HOUSE",
        "THE PALMS MEDICAL CENTRE"
      ],
      "Wanstead & Woodford PCN":[
        "ALDERSBROOK MEDICAL CENTRE",
        "CLAYHALL CLINIC",
        "GLEBELANDS PRACTICE",
        "QUEEN MARY PRACTICE",
        "RYDAL",
        "SOUTHDENE SURGERY",
        "THE BROADWAY SURGERY",
        "THE ELMHURST PRACTICE",
        "THE EVERGREEN SURGERY",
        "THE SHRUBBERIES MEDICAL CENTRE",
        "WANSTEAD PLACE SURGERY"
      ]
    },
    "NHS TOWER HAMLETS CCG":{
      "Bow Health (PCN 5)":[
        "HARLEY GROVE MEDICAL CTR.",
        "RUSTON STREET CLINIC",
        "ST. STEPHENS HEALTH CENTRE",
        "THE GROVE ROAD SURGERY",
        "TREDEGAR PRACTICE"
      ],
      "East End Health (PCN 2)":[
        "ALBION HEALTH CENTRE",
        "HEALTH E1",
        "THE BLITHEHALE MED.CTR.",
        "THE SPITALFIELDS PRACTICE"
      ],
      "Healthy Island Partnership (PCN 8)":[
        "DOCKLANDS MEDICAL CENTRE",
        "ISLAND HEALTH",
        "ROSERTON STREET SURGERY",
        "THE BARKANTINE PRACTICE"
      ],
      "Highway PCN (PCN 4)":[
        "EAST ONE HEALTH",
        "JUBILEE STREET PRACTICE",
        "ST. KATHERINE'S DOCK PRACTICE",
        "THE WAPPING GROUP PRACTICE"
      ],
      "Mile End and Bromley by Bow (PCN 6)":[
        "MERCHANT STREET PRACTICE",
        "ST ANDREWS HEALTH CENTRE",
        "ST. PAUL'S WAY MEDICAL CTR",
        "THE STROUDLEY WLK HTH CTR",
        "XX PLACE HEALTH CENTRE"
      ],
      "Poplar and Limehouse (PCN 7)":[
        "ABERFELDY PRACTICE",
        "GOUGH WALK PRACTICE",
        "THE CHRISP STREET HTH CTR",
        "THE LIMEHOUSE PRACTICE"
      ],
      "Stepney and Whitechapel (PCN 3)":[
        "BRAYFORD SQUARE SURGERY",
        "CITY WELLBEING PRACTICE",
        "HARFORD HEALTH CENTRE",
        "WHITECHAPEL HEALTH CENTRE"
      ],
      "The One PCN Alliance Ltd (PCN 1)":[
        "BETHNAL GREEN HEALTH CTR.",
        "POLLARD ROW SURGERY",
        "STROUTS PLACE MEDICAL CENTRE",
        "THE GLOBE TOWN SURGERY",
        "THE MISSION PRACTICE"
      ]
    },
    "NHS WALTHAM FOREST CCG":{
      "Chingford E4 PCN":[
        "CHINGFORD MEDICAL PRACTICE",
        "CHURCHILL MEDICAL CENTRE",
        "HANDSWORTH MEDICAL PRACTICE",
        "THE OLD CHURCH SURGERY",
        "THE RIDGEWAY SURGERY"
      ],
      "Forest 8 PCN":[
        "DR SHANTIR PRACTICE",
        "KINGS HEAD MEDICAL PRACTICE",
        "LARKSHALL MEDICAL CENTRE",
        "SINNOTT ROAD SURGERY",
        "THE BAILEY PRACTICE",
        "THE FOREST SURGERY",
        "THE MICROFACULTY",
        "THE PENRHYN SURGERY"
      ],
      "Forest Integrated Health PCN":[
        "CRAWLEY ROAD MEDICAL CENTRE",
        "FRANCIS ROAD MEDICAL CENTRE",
        "HAMPTON MEDICAL CENTRE",
        "LIME TREE SURGERY",
        "THE ALLUM MEDICAL CENTRE",
        "THE ECCLESBOURNE PRACTICE",
        "THE LYNDHURST SURGERY"
      ],
      "Leyton Collaborative PCN":[
        "LEYTON HEALTHCARE 4TH FLOOR",
        "ORIENT PRACTICE",
        "SMA MEDICAL PRACTICE",
        "THE MANOR PRACTICE"
      ],
      "South Leytonstone PCN":[
        "DR MOHAMMED GREEN MAN MEDICAL CENTRE",
        "HARROW ROAD GP CENTRE",
        "HIGH ROAD SURGERY",
        "KIYANI MEDICAL PRACTICE",
        "LANGTHORNE SHARMA FAMILY PRACTICE",
        "LL MEDICAL CARE LTD"
      ],
      "Walthamstow Central PCN":[
        "ADDISON ROAD MEDICAL PRACTICE",
        "CLAREMONT MEDICAL CENTRE",
        "DR DHITAL PRACTICE",
        "THE FIRS",
        "WALTHAM FOREST COMM & FAM HTH SERV LTD"
      ],
      "Walthamstow West PCN":[
        "DR S PHILLIPS AND DR M PATEL PRACTICE",
        "GROVE SURGERY",
        "HIGHAM HILL MEDICAL CENTRE",
        "QUEENS ROAD MEDICAL CENTRE",
        "ST JAMES MEDICAL PRACTICE LIMITED"
      ]
    }
  },
  "North West London STP":{
    "NHS BRENT CCG":{
      "ConnectHealth Alliance PCN":[
        "THE LAW MEDICAL GROUP PRACTICE",
        "THE LONSDALE MEDICAL CENTRE",
        "WILLESDEN GREEN SURGERY"
      ],
      "Harness North PCN":[
        "CHURCH LANE SURGERY",
        "PRESTON MEDICAL CENTRE",
        "SUDBURY & ALPERTON MEDICAL CENTRE",
        "WILLOW TREE FAMILY DOCTORS"
      ],
      "Harness Parks PCN":[
        "FREUCHEN MEDICAL CENTRE",
        "OXGATE GARDENS SURGERY",
        "PARK ROYAL MEDICAL PRACTICE",
        "ROUNDWOOD PARK MEDICAL CENTRE",
        "WALM LANE SURGERY"
      ],
      "Harness Stadium PCN":[
        "LANFRANC MEDICAL CENTRE",
        "PEARL MEDICAL PRACTICE",
        "SMS MEDICAL PRACTICE",
        "THE SUNFLOWER MEDICAL CENTRE",
        "THE SURGERY",
        "WEMBLEY PARK DRIVE MEDICAL CENTRE"
      ],
      "Harness Temple PCN":[
        "AKSYR MEDICAL PRACTICE",
        "BRENTFIELD MEDICAL CENTRE",
        "CHURCH END MEDICAL CENTRE",
        "HILLTOP MEDICAL PRACTICE",
        "THE STONEBRIDGE PRACTICE"
      ],
      "K&W Central PCN":[
        "CHALKHILL FAMILY PRACTICE",
        "ELLIS PRACTICE",
        "FORTY WILLOWS SURGERY",
        "PRESTON ROAD SURGERY",
        "SUDBURY SURGERY",
        "THE TUDOR HOUSE MEDICAL CENTRE"
      ],
      "K&W North PCN":[
        "BRAMPTON HEALTH CENTRE",
        "KINGS EDGE MEDICAL CENTRE",
        "KINGSBURY HEALTH AND WELLBEING",
        "NEASDEN MEDICAL CENTRE",
        "THE FRYENT WAY SURGERY",
        "THE STAG - HOLLYROOD PRACTICE",
        "UXENDON CRESCENT SURGERY"
      ],
      "K&W South PCN":[
        "BURNLEY PRACTICE",
        "GLADSTONE MEDICAL CENTRE",
        "ST ANDREWS MEDICAL CENTRE",
        "ST.GEORGES MEDICAL CENTRE",
        "THE WILLESDEN MEDICAL CENTRE"
      ],
      "K&W West PCN":[
        "ALPERTON MEDICAL CENTRE",
        "HAZELDENE MEDICAL CENTRE",
        "LANCELOT MEDICAL CENTRE",
        "PREMIER MEDICAL CENTRE",
        "STANLEY CORNER MEDICAL CENTRE",
        "THE WEMBLEY PRACTICE"
      ],
      "Kilburn Partnership PCN":[
        "CHICHELE ROAD SURGERY",
        "KILBURN PARK MEDICAL CENTRE",
        "MAPESBURY MEDICAL GROUP",
        "PEEL PRECINCT SURGERY",
        "STAVERTON SURGERY"
      ]
    },
    "NHS CENTRAL LONDON (WESTMINSTER) CCG":{
      "Regents Health PCN":[
        "CONNAUGHT SQUARE PRACTICE",
        "CROMPTON MEDICAL CENTRE",
        "IMPERIAL COLLEGE HEALTH CENTRE",
        "LISSON GROVE HEALTH CENTRE",
        "NEWTON MEDICAL CENTRE",
        "PADDINGTON GREEN HEALTH CENTRE",
        "THE WESTBOURNE GREEN SURGERY",
        "WOODFIELD ROAD MEDICAL CENTRE"
      ],
      "South Westminster PCN":[
        "BELGRAVIA SURGERY",
        "DR MAHER SHAKARCHI'S PRACTICE",
        "DR VICTORIA MUIR'S PRACTICE",
        "KINGS COLLEGE HEALTH CENTRE",
        "MILLBANK MEDICAL CENTRE",
        "PIMLICO HEALTH AT THE MARVEN SURGERY",
        "THE DOCTOR HICKEY SURGERY",
        "VICTORIA MEDICAL CENTRE",
        "WESTMINSTER SCHOOL"
      ],
      "St John?s Wood and Maida Vale PCN":[
        "GROUND FLOOR LANARK MEDICAL CENTRE",
        "LITTLE VENICE MEDICAL CENTRE",
        "MAIDA VALE MEDICAL CENTRE",
        "ST JOHNS WOOD MEDICAL PRACTICE",
        "THE RANDOLPH SURGERY",
        "THIRD FLOOR LANARK ROAD MEDICAL CENTRE",
        "WELLINGTON HEALTH CENTRE"
      ],
      "West End and Marylebone PCN":[
        "CAVENDISH HEALTH CENTRE",
        "COVENT GARDEN MEDICAL CENTRE",
        "CRAWFORD STREET SURGERY",
        "FITZROVIA MEDICAL CENTRE",
        "GREAT CHAPEL STREET MEDICAL CENTRE",
        "MARYLEBONE HEALTH CENTRE",
        "MAYFAIR MEDICAL CENTRE",
        "SOHO CENTRE FOR HEALTH AND CARE",
        "SOHO SQUARE GENERAL PRACTICE"
      ]
    },
    "NHS EALING CCG":{
      "Acton PCN":[
        "ACTON LANE MEDICAL CENTRE",
        "ACTON TOWN MEDICAL CENTRE",
        "CHISWICK FAMILY PRACTICE",
        "CLOISTER ROAD SURGERY",
        "CROWN STREET SURGERY",
        "HILLCREST SURGERY",
        "THE ACTON HEALTH CENTRE",
        "THE BEDFORD PARK SURGERY",
        "THE BOILEAU ROAD SURGERY",
        "THE CHURCHFIELD ROAD SURGERY",
        "THE HORN LANE SURGERY",
        "THE MILL HILL SURGERY",
        "THE VALE SURGERY",
        "WESTERN AVENUE SURGERY"
      ],
      "Greenwell PCN":[
        "EASTMEAD AVENUE SURGERY",
        "ELMBANK SURGERY",
        "GREENFORD AVENUE FHP",
        "HANWELL HEALTH CENTRE (NAISH)",
        "HANWELL HEALTH CENTRE (STEWART)",
        "OLDFIELD FAMILY PRACTICE",
        "THE MANSELL ROAD PRACTICE"
      ],
      "NGP PCN":[
        "ELMTREES SURGERY",
        "GREENFORD ROAD MED.CTR.",
        "HILLVIEW SURGERY",
        "ISLIP MANOR MEDICAL CENTRE",
        "MANDEVILLE MEDICAL CENTRE",
        "MEADOW VIEW",
        "PERIVALE MEDICAL CLINIC",
        "THE ALLENDALE ROAD SURGERY",
        "THE BARNABAS MEDICAL CTRE",
        "THE GROVE MEDICAL PRACTICE",
        "THE MEDICAL CENTRE"
      ],
      "North Southall PCN":[
        "CHEPSTOW GARDENS MEDICAL CENTRE",
        "DORMERS WELLS MEDICAL CENTRE",
        "DR SIVANESAN & PARTNER",
        "KS MEDICAL CENTRE",
        "LADY MARGARET ROAD MEDICAL CENTRE",
        "SOMERSET FHP O",
        "ST.GEORGES MEDICAL CTR.",
        "THE MWH PRACTICE",
        "THE SALUJA CLINIC",
        "THE TOWN SURGERY"
      ],
      "Northolt PCN":[
        "ALLENBY CLINIC",
        "BROADMEAD SURGERY",
        "GOODCARE PRACTICE",
        "JUBILEE GARDENS MEDICAL CENTRE",
        "NORTHOLT FAMILY PRACTICE",
        "SOMERSET MEDICAL CENTRE",
        "WEST END SURGERY",
        "YEADING MEDICAL CENTRE"
      ],
      "South Central Ealing PCN":[
        "EALING PARK HEALTH CENTRE",
        "ELTHORNE PARK SURGERY",
        "GROSVENOR HOUSE SURGERY",
        "NORTHFIELDS SURGERY",
        "THE FLORENCE ROAD SURGERY"
      ],
      "South Southall PCN":[
        "BELMONT MEDICAL CENTRE",
        "FEATHERSTONE ROAD HEALTH CENTRE",
        "GURU NANAK MEDICAL CENTRE",
        "HAMMOND ROAD SURGERY",
        "MEDICAL CENTRE",
        "SUNRISE MEDICAL CENTRE",
        "THE SOUTHALL MEDICAL CTR.",
        "WATERSIDE MEDICAL CENTRE",
        "WELCOME PRACTICE"
      ],
      "The Ealing PCN":[
        "BRUNSWICK ROAD MED.CTR.",
        "GORDON HOUSE SURGERY",
        "MATTOCK LANE HEALTH CENTRE",
        "QUEENS WALK PRACTICE",
        "THE AVENUE SURGERY",
        "THE CORFTON ROAD SURGERY",
        "THE CUCKOO LANE PRACTICE",
        "THE LYNWOOD SURGERY",
        "THE PITSHANGER LANE SURGERY"
      ]
    },
    "NHS HAMMERSMITH AND FULHAM CCG":{
      "Babylon GP PCN":[
        "GP AT HAND",
        "THE MEDICAL CENTRE, DR JEFFERIES & PARTN"
      ],
      "H&F Central PCN":[
        "ASHCHURCH SURGERY",
        "BROOK GREEN SURGERY",
        "HAMMERSMITH SURGERY",
        "STERNDALE SURGERY",
        "THE SURGERY, 82 LILLIE ROAD"
      ],
      "H&F PARTNERSHIP PCN":[
        "BROOK GREEN MEDICAL CENTRE",
        "NORTH END MEDICAL CENTRE",
        "PARK MEDICAL CENTRE",
        "RICHFORD GATE MEDICAL CENTRE",
        "THE BUSH DOCTORS"
      ],
      "North H&F PCN":[
        "CANBERRA OLD OAK SURGERY",
        "DR CANISIUS & DR HASAN, PARKVIEW CFH&W",
        "DR RK KUKAR, PARKVIEW CTR FOR H&W",
        "DR UPPAL & PARTN, PARKVIEW CTR FOR H&W",
        "HAMMERSMITH & FULHAM CENTRES FOR HEALTH",
        "SHEPHERDS BUSH MEDICAL CENTRE",
        "THE MEDICAL CENTRE, DR KUKAR",
        "THE NEW SURGERY",
        "THE SURGERY, DR DASGUPTA & PARTNERS"
      ],
      "South Fulham PCN":[
        "ASHVILLE SURGERY",
        "CASSIDY ROAD MEDICAL CENTRE",
        "FULHAM CROSS MEDICAL CENTRE",
        "SALISBURY SURGERY",
        "SANDS END HEALTH CLINIC",
        "THE FULHAM MEDICAL CENTRE",
        "THE LILYVILLE SURGERY",
        "THE SURGERY, DR MANGWANA & PARTNERS"
      ]
    },
    "NHS HARROW CCG":{
      "Harrow Collaborative PCN":[
        "FIRST CHOICE MEDICAL CARE",
        "HEADSTONE LANE MEDICAL CENTRE",
        "HEADSTONE ROAD SURGERY",
        "KENTON CLINIC",
        "KINGS ROAD SURGERY",
        "PINNER VIEW MEDICAL CENTRE",
        "SAVITA MEDICAL CENTRE",
        "THE CIVIC MEDICAL CENTRE",
        "THE PINNER ROAD SURGERY",
        "THE SHAFTESBURY MEDICAL CENTRE",
        "ZAIN MEDICAL CENTRE"
      ],
      "Harrow East PCN":[
        "BACON LANE SURGERY",
        "HARNESS HARROW PRACTICE",
        "HONEYPOT MEDICAL CENTRE"
      ],
      "Health Alliance PCN":[
        "ASPRI MEDICAL CENTRE",
        "BELMONT HEALTH CENTRE",
        "THE CIRCLE PRACTICE",
        "THE ENTERPRISE PRACTICE",
        "THE STANMORE MEDICAL CENTRE",
        "THE STREATFIELD MEDICAL CENTRE"
      ],
      "Healthsense PCN":[
        "ENDERLEY ROAD MEDICAL CENTRE",
        "KENTON BRIDGE MEDICAL CENTRE - DR RAJA",
        "KENTON BRIDGE MEDICAL CENTRE DR GOLDEN",
        "ROXBOURNE MEDICAL CENTRE",
        "SIMPSON HOUSE MEDICAL CENTRE",
        "THE PINN MEDICAL CENTRE",
        "THE RIDGEWAY SURGERY"
      ],
      "Sphere PCN":[
        "ELLIOTT HALL MEDICAL CTR.",
        "GP DIRECT",
        "HATCH END MEDICAL CENTRE",
        "ST. PETER'S MEDICAL CENTRE",
        "STREATFIELD HEALTH CENTRE",
        "THE NORTHWICK SURGERY"
      ]
    },
    "NHS HILLINGDON CCG":{
      "Celandine Health PCN":[
        "KING EDWARDS MEDICAL CENTRE",
        "LADYGATE LANE MEDICAL PRACTICE",
        "SOUTHCOTE CLINIC",
        "ST MARTINS MEDICAL CENTRE",
        "WALLASEY MEDICAL CENTRE",
        "WOOD LANE MEDICAL CENTRE"
      ],
      "Colne Union PCN":[
        "OTTERFIELD MEDICAL CENTRE",
        "THE HIGH STREET PRACTICE",
        "THE MEDICAL CENTRE",
        "YIEWSLEY FAMILY PRACTICE"
      ],
      "HH Collaborative PCN":[
        "CEDAR BROOK PRACTICE",
        "GLENDALE MEDICAL CENTRE",
        "HAYES MEDICAL CENTRE",
        "HESA MEDICAL CENTRE - Y00352",
        "KINCORA DOCTORS SURGERY",
        "KINGSWAY SURGERY",
        "NORTH HYDE ROAD SURGERY",
        "THE WARREN PRACTICE",
        "TOWNFIELD DOCTORS SURGERY"
      ],
      "Long Lane First Care Group PCN":[
        "ACORN MEDICAL CENTRE",
        "HEATHROW MEDICAL CENTRE",
        "HILLINGDON HEALTH CENTRE",
        "PARKVIEW SURGERY",
        "SHAKESPEARE HEALTH CENTRE",
        "THE OAKLAND MEDICAL CENTRE",
        "THE PINE MEDICAL CENTRE",
        "WILLOW TREE SURGERY",
        "YEADING COURT SURGERY"
      ],
      "MetroCare PCN":[
        "CEDARS MEDICAL CENTRE",
        "DR MLR SIDDIQUI'S PRACTICE",
        "OXFORD DRIVE MEDICAL CENTRE",
        "QUEENS WALK MEDICAL CENTRE",
        "THE ABBOTSBURY PRACTICE",
        "THE DEVONSHIRE LODGE PRACTICE"
      ],
      "North Connect PCN":[
        "ACRE SURGERY",
        "ACREFIELD SURGERY",
        "CAREPOINT PRACTICE",
        "EASTBURY SURGERY",
        "HAREFIELD PRACTICE",
        "MOUNTWOOD SURGERY"
      ],
      "Synergy PCN":[
        "BELMONT MEDICAL CENTRE",
        "BRUNEL MEDICAL CENTRE",
        "CENTRAL UXBRIDGE SURGERY"
      ]
    },
    "NHS HOUNSLOW CCG":{
      "Brentford & Isleworth PCN":[
        "ALBANY PRACTICE",
        "BRENTFORD FAMILY PRACTICE",
        "BRENTFORD GROUP PRACTICE",
        "SPRING GROVE MEDICAL PRACTICE",
        "ST.MARGARETS PRACTICE",
        "THORNBURY ROAD CENTRE FOR HEALTH"
      ],
      "Chiswick PCN":[
        "CHISWICK FAMILY DRS PRACTICE",
        "CHISWICK HEALTH PRACTICE",
        "GLEBE STREET SURGERY",
        "GROVE PARK SURGERY",
        "GROVE PARK TERRACE SURGERY",
        "HOLLY ROAD MEDICAL CENTRE",
        "WELLESLEY ROAD PRACTICE",
        "WEST4 GPS"
      ],
      "Feltham PCN":[
        "CARLTON SURGERY",
        "CLIFFORD HOUSE MEDICAL CENTRE",
        "GILL MEDICAL PRACTICE",
        "GREENBROOK BEDFONT",
        "GROVE VILLAGE MEDICAL CENTRE",
        "HATTON MEDICAL PRACTICE",
        "LITTLE PARK SURGERY",
        "MOUNT MEDICAL CENTRE",
        "PENTELOW PRACTICE",
        "QUEENS PARK MEDICAL PRACTICE",
        "ST DAVIDS PRACTICE",
        "THE PRACTICE FELTHAM",
        "TWICKENHAM PARK MEDICAL CENTRE"
      ],
      "Great West Road PCN":[
        "CLIFFORD ROAD SURGERY",
        "CRANFORD MEDICAL CENTRE",
        "CROSSLANDS SURGERY",
        "DR SOOD'S PRACTICE",
        "FIRSTCARE PRACTICE",
        "JERSEY PRACTICE",
        "LIVINGCARE HESTON",
        "SKYWAYS MEDICAL CENTRE"
      ],
      "Heart of Hounslow PCN":[
        "BATH ROAD SURGERY",
        "BLUE WING FAMILY DOCTOR UNIT",
        "CHESTNUT PRACTICE",
        "GREEN PRACTICE",
        "HOUNSLOW FAMILY PRACTICE",
        "HOUNSLOW MEDICAL CENTRE",
        "KINGFISHER PRACTICE",
        "REDWOOD PRACTICE",
        "THE PRACTICE HEART OF HOUNSLOW",
        "WILLOW PRACTICE"
      ]
    },
    "NHS WEST LONDON CCG":{
      "Inclusive Health PCN":[
        "AHMED N QUEENS PARK HEALTH CENTRE",
        "BARLBY SURGERY",
        "ELGIN CLINIC",
        "HALF PENNY STEPS HEALTH CENTRE",
        "LAI CHUNG FONG QUEENS PARK HEALTH CENTRE",
        "MEANWHILE GARDEN MEDICAL CENTRE",
        "SHIRLAND ROAD MEDICAL CENTRE",
        "SRIKRISHNAMURTHY HARROW ROAD SURGERY"
      ],
      "Kensington and Chelsea South PCN":[
        "BROMPTON MEDICAL CENTRE",
        "EARLS COURT MEDICAL CENTRE",
        "EARLS COURT SURGERY",
        "HEALTH AND WELLBEING CENTRE, EARLS COURT",
        "KENSINGTON PARK MEDICAL CENTRE",
        "KINGS ROAD MEDICAL CENTRE",
        "KNIGHTSBRIDGE MEDICAL CENTRE",
        "ROSARY GARDEN SURGERY",
        "THE SURGERY"
      ],
      "NeoHealth PCN":[
        "COLVILLE HEALTH CENTRE",
        "NORTH KENSINGTON MEDICAL CENTRE",
        "ST. QUINTIN HEALTH CENTRE",
        "THE EXMOOR SURGERY",
        "THE FORELAND MEDICAL CENTRE",
        "THE GOLBORNE MEDICAL CENTRE",
        "THE NOTTING HILL MEDICAL CENTRE",
        "THE PRACTICE BEACON"
      ],
      "West-Hill Health PCN":[
        "GRAND UNION HEALTH CENTRE",
        "HOLLAND PARK SURGERY",
        "LANCASTER GATE MEDICAL CENTRE",
        "PORTLAND ROAD PRACTICE",
        "PORTOBELLO MEDICAL CENTRE",
        "THE GARWAY MEDICAL PRACTICE",
        "THE PEMBRIDGE VILLAS SURGERY",
        "WESTBOURNE GROVE MEDICAL CENTRE"
      ],
      "WL South PCN":[
        "EMPEROR'S GATE CENTRE FOR HEALTH",
        "ROYAL HOSPITAL CHELSEA",
        "SCARSDALE MEDICAL CENTRE",
        "STANHOPE MEWS SURGERY",
        "THE ABINGDON HEALTH CENTRE",
        "THE CHELSEA PRACTICE",
        "THE GOOD PRACTICE",
        "THE REDCLIFFE SURGERY"
      ]
    }
  },
  "South East London STP":{
    "NHS BEXLEY CCG":{
      "APL Bexley PCN":[
        "BURSTED WOOD SURGERY",
        "LYNDHURST ROAD MEDICAL CENTRE",
        "PLAS MEDDYG SURGERY",
        "THE ALBION SURGERY"
      ],
      "Clocktower PCN":[
        "BELLEGROVE SURGERY",
        "BEXLEY GROUP PRACTICE",
        "DR THAVAPALAN AND PARTNERS",
        "THE WESTWOOD SURGERY",
        "WELLING MEDICAL PRACTICE"
      ],
      "Frognal PCN":[
        "BARNARD MEDICAL GROUP",
        "SIDCUP MEDICAL CENTRE",
        "STATION ROAD SURGERY",
        "WOODLANDS SURGERY"
      ],
      "G83024 PCN":[
        "INGLETON AVENUE SURGERY"
      ],
      "North Bexley PCN":[
        "BELVEDERE MEDICAL CENTRE",
        "BEXLEY MEDICAL GROUP",
        "BULBANKS MEDICAL CENTRE",
        "CRAYFORD TOWN SURGERY",
        "LAKESIDE MEDICAL",
        "NORTHUMBERLAND HEATH MED.CTR.",
        "RIVERSIDE SURGERY",
        "SLADE GREEN MEDICAL CTR."
      ]
    },
    "NHS BROMLEY CCG":{
      "Beckenham PCN":[
        "CATOR MEDICAL CENTRE",
        "CORNERWAYS SURGERY",
        "EDEN PARK SURGERY",
        "ELM HOUSE SURGERY",
        "MANOR ROAD SURGERY",
        "ST JAMES' PRACTICE"
      ],
      "Bromley Connect PCN":[
        "DYSART SURGERY",
        "LONDON LANE CLINIC",
        "SOUTH VIEW PARTNERSHIP"
      ],
      "Five Elms PCN":[
        "BROMLEY COMMON PRACTICE",
        "NORHEADS LANE SURGERY",
        "SOUTHBOROUGH LANE SURGERY",
        "STOCK HILL SURGERY",
        "SUMMERCROFT SURGERY"
      ],
      "Hayes Wick PCN":[
        "ADDINGTON ROAD SURGERY",
        "FORGE CLOSE SURGERY",
        "PICKHURST SURGERY",
        "STATION ROAD SURGERY",
        "WICKHAM PARK SURGERY"
      ],
      "Mottingham, Downham and Chislehurst PCN":[
        "CHISLEHURST MEDICAL PRACTICE",
        "LINKS MEDICAL PRACTICE",
        "WOODLANDS PRACTICE"
      ],
      "Orpington PCN":[
        "BALLATER SURGERY",
        "BANK HOUSE SURGERY",
        "BROMLEAG CARE PRACTICE",
        "CHELSFIELD SURGERY",
        "FAMILY SURGERY",
        "GREEN STREET GREEN MED CT",
        "KNOLL MEDICAL PRACTICE",
        "TUDOR WAY SURGERY",
        "WHITEHOUSE SURGERY"
      ],
      "Penge PCN":[
        "ANERLEY SURGERY",
        "HIGHLAND ROAD SURGERY",
        "OAKFIELD SURGERY",
        "ROBIN HOOD SURGERY",
        "SUNDRIDGE MEDICAL CENTRE",
        "THE PARK PRACTICE"
      ],
      "The Crays Collaborative PCN":[
        "BROOMWOOD ROAD SURGERY",
        "CRESCENT SURGERY",
        "DERRY DOWNS SURGERY",
        "GILLMANS ROAD SURGERY",
        "POVEREST MEDICAL CENTRE",
        "ST MARY CRAY PRACTICE"
      ]
    },
    "NHS GREENWICH CCG":{
      "Blackheath and Charlton PCN":[
        "BLACKHEATH STANDARD PMS",
        "FAIRFIELD PMS",
        "MANOR BROOK PMS",
        "VANBRUGH GROUP PRACTICE"
      ],
      "Eltham PCN":[
        "ELMSTEAD MEDICAL CLINIC",
        "ELTHAM MEDICAL PRACTICE",
        "ELTHAM PALACE PMS",
        "NEW ELTHAM AND BLACKFEN MEDICAL CENTRE",
        "SHERARD ROAD MEDICAL CENTRE"
      ],
      "Greenwich West PCN":[
        "BURNEY STREET PMS",
        "GREENWICH PENINSULA",
        "PLUMBRIDGE MEDICAL CENTRE",
        "PRIMECARE PMS (SOUTH STREET)",
        "WOODLANDS SURGERY"
      ],
      "Heritage PCN":[
        "ABBEY WOOD SURGERY",
        "ABBEYSLADE PMS (DR CHAND)",
        "BANNOCKBURN SURGERY",
        "TRIVENI PMS",
        "WAVERLEY PMS"
      ],
      "Riverview Health PCN":[
        "AT MEDICS",
        "CONWAY PMS",
        "GALLIONS REACH HEALTH CENTRE",
        "ROYAL ARSENAL MEDICAL CENTRE",
        "ST MARKS PMS",
        "THE TRINITY MEDICAL CENTRE",
        "VALENTINE HEALTH PARTNERSHIP"
      ],
      "Unity PCN":[
        "ALL SAINTS MEDICAL CENTRE PMS",
        "CLOVER HEALTH CENTRE",
        "GLYNDON PMS",
        "MOSTAFA PMS",
        "PLUMSTEAD H/C PMS"
      ]
    },
    "NHS LAMBETH CCG":{
      "AT Medics Streatham PCN":[
        "EDITH CAVELL PRACTICE",
        "STREATHAM HIGH PRACTICE"
      ],
      "Brixton & Clapham Park PCN":[
        "CLAPHAM PARK GROUP PRACTICE",
        "HETHERINGTON AT THE PAVILION",
        "HETHERINGTON GROUP PRACTICE"
      ],
      "Clapham PCN":[
        "CLAPHAM FAMILY PRACTICE",
        "DR CURRAN & PARTNERS",
        "GRAFTON SQUARE SURGERY",
        "SANDMERE PRACTICE"
      ],
      "Croxted PCN":[
        "BROCKWELL PARK SURGERY",
        "PAXTON GREEN GROUP PRACTICE",
        "THE OLD DAIRY HEALTH CENTRE"
      ],
      "Fiveways PCN":[
        "AKERMAN MEDICAL PRACTICE",
        "HERNE HILL ROAD MEDICAL PRACTICE",
        "MINET GREEN HEALTH PRACTICE",
        "THE CORNER SURGERY",
        "VASSALL MEDICAL CENTRE"
      ],
      "Hills, Brooks and Dales Group PCN":[
        "BRIXTON HILL GROUP PRACTICE",
        "HERNE HILL GROUP PRACTICE",
        "KNIGHTS HILL SURGERY SUITE 1",
        "NORTH WOOD GROUP PRACTICE",
        "THE DEERBROOK SURGERY"
      ],
      "North Lambeth PCN":[
        "HURLEY AND RIVERSIDE PRACTICES",
        "LAMBETH WALK GROUP PRACTICE",
        "MAWBEY GROUP PRACTICE",
        "THE SOUTH LAMBETH RD PRACTICE",
        "THE VAUXHALL SURGERY",
        "WATERLOO HEALTH CENTRE"
      ],
      "StockWellBeing PCN":[
        "BECKETT HOUSE PRACTICE",
        "BINFIELD ROAD SURGERY",
        "DR WICKREMESINGHE SSG",
        "SPRINGFIELD MEDICAL CENTRE",
        "STOCKWELL GROUP PRACTICE"
      ],
      "Streatham PCN":[
        "PALACE ROAD SURGERY",
        "PRENTIS MEDICAL CENTRE",
        "STREATHAM COMMON GROUP PRACTICE",
        "THE EXCHANGE SURGERY",
        "THE STREATHAM HILL GROUP PRACTICE",
        "THE VALE SURGERY",
        "VALLEY ROAD SURGERY"
      ]
    },
    "NHS LEWISHAM CCG":{
      "Aplos Health PCN":[
        "SYDENHAM GREEN GROUP PRACTICE",
        "VALE MEDICAL CENTRE",
        "WELLS PARK PRACTICE",
        "WOOLSTONE MEDICAL CENTRE"
      ],
      "Lewisham Alliance PCN":[
        "BURNT ASH SURGERY",
        "LEE ROAD SURGERY",
        "LEWISHAM MEDICAL CENTRE",
        "NIGHTINGALE SURGERY",
        "TRIANGLE GROUP PRACTICE",
        "WOODLANDS HEALTH CENTRE"
      ],
      "Lewisham Care Partnership PCN":[
        "BELMONT HILL SURGERY",
        "HILLY FIELDS MEDICAL CENTRE",
        "HONOR OAK GROUP PRACTICE",
        "MORDEN HILL SURGERY",
        "ST JOHNS MEDICAL CENTRE"
      ],
      "Modality Lewisham PCN":[
        "BELLINGHAM GREEN SURGERY",
        "SOUTH LEWISHAM GROUP PRACTICE",
        "THE JENNER PRACTICE"
      ],
      "North Lewisham PCN":[
        "AMERSHAM VALE TRAINING PRACTICE",
        "CLIFTON RISE FAMILY PRACTICE",
        "DEPTFORD MEDICAL CENTRE",
        "DEPTFORD SURGERY",
        "GROVE MEDICAL CENTRE",
        "KINGFISHER MEDICAL CENTRE",
        "MORNINGTON SURGERY",
        "NEW CROSS CENTRE (HURLEY GROUP)",
        "THE QRP SURGERY",
        "VESTA ROAD SURGERY"
      ],
      "Sevenfields PCN":[
        "DOWNHAM FAMILY MEDICAL PRACTICE",
        "ICO HEALTH GROUP",
        "NOVUM HEALTH PARTNERSHIP",
        "OAKVIEW FAMILY PRACTICE",
        "PARKVIEW SURGERY",
        "TORRIDON ROAD MEDICAL PRACTICE"
      ]
    },
    "NHS SOUTHWARK CCG":{
      "North Southwark PCN":[
        "ALBION STREET GROUP PRACTICE",
        "BERMONDSEY SPA MEDICAL CENTRE",
        "BLACKFRIARS MEDICAL PRACTICE",
        "DR AT BRADFORD'S PRACTICE",
        "FALMOUTH ROAD GROUP PRACTICE",
        "NEXUS HEALTH GROUP",
        "OLD KENT ROAD SURGERY",
        "PARK MEDICAL CENTRE",
        "PENROSE SURGERY",
        "QHS GP CARE HOME SERVICE",
        "SILVERLOCK MEDICAL CENTRE",
        "THE NEW MILL STREET SURGERY",
        "THE VILLA STREET MEDICAL CENTRE",
        "TRAFALGAR SURGERY"
      ],
      "South Southwark PCN":[
        "DMC CHADWICK ROAD",
        "DR RS DURSTON'S PRACTICE",
        "ELM LODGE SURGERY",
        "FOREST HILL GROUP PRACTICE",
        "PARKSIDE MEDICAL CENTRE",
        "QUEENS ROAD SURGERY",
        "ST GILES SURGERY",
        "ST GILES SURGERY DR PATEL",
        "STERNHALL LANE SURGERY",
        "TESSA JOWELL GP SURGERY",
        "THE ACORN & GAUMONT HOUSE SURGERY",
        "THE DULWICH MEDICAL CENTRE",
        "THE GARDENS SURGERY",
        "THE LISTER PRACTICE",
        "THE LISTER PRIMARY CARE CENTRE",
        "THE LORDSHIP LANE SURGERY",
        "THE NUNHEAD SURGERY",
        "THE THREE ZERO SIX MEDICAL CENTRE"
      ]
    }
  }
};

/**
 * Checklist database, it can build a tree structured Json object.
 * Each node in Json object represents a orgitem or a category.
 * If a node is a category, it has children items and new items can be added under the category.
 */
@Injectable()
export class ChecklistDatabase {
  dataChange = new BehaviorSubject<OrgItemNode[]>([]);

  get data(): OrgItemNode[] { return this.dataChange.value; }

  constructor() {
    this.initialize();
  }

  initialize() {
    // Build the tree nodes from Json object. The result is a list of `OrgItemNode` with nested
    //     file node as children.
    const data = this.buildFileTree(ORG_DATA, 0);

    // Notify the change.
    this.dataChange.next(data);
  }

  /**
   * Build the file structure tree. The `value` is the Json object, or a sub-tree of a Json object.
   * The return value is the list of `OrgItemNode`.
   */
  buildFileTree(obj: {[key: string]: any}, level: number): OrgItemNode[] {
    return Object.keys(obj).reduce<OrgItemNode[]>((accumulator, key) => {
      const value = obj[key];
      const node = new OrgItemNode();
      node.item = key;

      if (value != null) {
        if (typeof value === 'object') {
          node.children = this.buildFileTree(value, level + 1);
        } else {
          node.item = value;
        }
      }

      return accumulator.concat(node);
    }, []);
  }

}

@Component({
  selector: 'app-covidviewer',
  templateUrl: './covidviewer.component.html',
  styleUrls: ['./covidviewer.component.scss'],
  providers: [ChecklistDatabase],
  encapsulation: ViewEncapsulation.None
})

export class CovidViewerComponent implements OnInit {
  globals: Globals;
  name: string = "";
  combineSeries1: boolean = false;
  combineEthnic1: boolean = true;
  combineAge1: boolean = true;
  combineSex1: boolean = true;
  combineOrgs: boolean = false;
  selectAllEthnic1: boolean = true;
  selectAllSeries1: boolean = true;
  selectAllAge1: boolean = true;
  selectAllSex1: boolean = true;
  view1: any[] = [1250, 620];
  chartResults1: any[];
  chartResultsSingle1: any[];
  dateFrom1: string = '2020-01-01';
  dateTo1: string = this.formatDate(new Date());
  dashboardId: string;
  showLineCharts1: boolean = false;
  showBarCharts1: boolean = false;
  seriesValues1 = new FormControl();
  seriesList1: string = '';
  selectedethnic1: any = [];
  selectedage1: any = [];
  selectedsex1: any = [];
  chartName: string = "";
  showPrompt: boolean = true;
  showWait: boolean = false;
  showCharts: boolean = false;

  // options
  legend: boolean = true;
  legendPosition: string = 'right';
  animations: boolean = true;
  xAxis: boolean = true;
  yAxis: boolean = true;
  showYAxisLabel: boolean = true;
  showXAxisLabel: boolean = true;
  chartTitle1: string = "Chart Title";
  xAxisLabel1: string = 'Date';
  yAxisLabel1: string = 'People with indicator';
  yAxisLabel: string;
  chartSelections1: string = '';
  chartSelections2: string = '';
  chartSelections3: string = '';
  chartSelections4: string = '';
  timeline: boolean = true;
  showAreaChart1: boolean = false;
  gradient1: boolean = false;
  showRefLines1: boolean = false;
  logarithmic1: boolean = false;
  cumulative1: boolean = false;
  weekly1: boolean = false;
  rate1: boolean = false;
  refLines1 = [{value: 1, name: 'Minimum'}, {value: 2, name: 'Average'}, {value: 3, name: 'Maximum'}];
  ethnicList1 = [];
  ethnicValues1 = new FormControl(this.ethnicList1);
  ageList1 = [];
  ageValues1 = new FormControl(this.ageList1);
  sexList1 = [];
  sexValues1 = new FormControl(this.sexList1);
  colorScheme = {
    domain: ["#3366cc","#dc3912","#ff9900","#109618","#990099","#0099c6","#dd4477","#66aa00","#b82e2e","#316395","#3366cc",
      "#994499","#22aa99","#aaaa11","#6633cc","#e67300","#8b0707","#651067","#329262",
      "#5574a6","#3b3eac","#b77322","#16d620","#b91383","#f4359e","#9c5935","#a9c413","#2a778d","#668d1c","#bea413","#0c5922","#743411"]
  };

  selectedSeries1: any = [];
  selectedWidgets : widget[] = [
  ];

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private dialog: MatDialog,
    private _database: ChecklistDatabase,
    globals: Globals) {

    this.globals = globals;

    this.treeFlattener = new MatTreeFlattener(this.transformer, this.getLevel,
      this.isExpandable, this.getChildren);
    this.treeControl = new FlatTreeControl<OrgItemFlatNode>(this.getLevel, this.isExpandable);
    this.dataSource = new MatTreeFlatDataSource(this.treeControl, this.treeFlattener);

    _database.dataChange.subscribe(data => {
      this.dataSource.data = data;
    });
  }

  ngOnInit() {
    this.ethnicValues1 = new FormControl(this.ethnicList1);
    this.selectedethnic1 = this.ethnicList1;

    this.explorerService.getLookupLists('19','')
      .subscribe(
        (result) => this.loadList(result),
        (error) => this.log.error(error)
      );
  }

  toggleEthnicSelection1(event) {
    if (event.checked) {
      this.ethnicValues1 = new FormControl(this.ethnicList1);
      this.selectedethnic1 = this.ethnicList1;
    } else {
      this.ethnicValues1 = new FormControl([]);
      this.selectedethnic1 = "";
    }
    this.refreshDashboard();
  }

  toggleAgeSelection1(event) {
    if (event.checked) {
      this.ageValues1 = new FormControl(this.ageList1);
      this.selectedage1 = this.ageList1;
    } else {
      this.ageValues1 = new FormControl([]);
      this.selectedage1 = "";
    }
    this.refreshDashboard();
  }

  toggleSexSelection1(event) {
    if (event.checked) {
      this.sexValues1 = new FormControl(this.sexList1);
      this.selectedsex1 = this.sexList1;
    } else {
      this.sexValues1 = new FormControl([]);
      this.selectedsex1 = "";
    }
    this.refreshDashboard();
  }

  toggleSeriesSelection1(event) {
    if (event.checked) {
      this.seriesValues1 = new FormControl(this.seriesList1);
      this.selectedSeries1 = this.seriesList1;
    } else {
      this.seriesValues1 = new FormControl([]);
      this.selectedSeries1 = "";
    }
    this.refreshDashboard();
  }

  refreshDashboard() {
    let series = this.selectedSeries1.toString();

    this.showLineCharts1 = this.selectedWidgets[0].name=='Line chart';
    this.showBarCharts1 = this.selectedWidgets[0].name=='Bar chart';

    let stp = "";
    let ccg = "";
    let pcn = "";
    let practice = "";

    this.checklistSelection.selected.map(
      e => {
        if (e.level==0)
          stp += ','+e.item;
        else if (e.level==1)
          ccg += ','+e.item;
        else if (e.level==2)
          pcn += ','+e.item;
        else if (e.level==3)
          practice += ','+e.item;
      }
    )

    stp = stp.replace(',', '');
    ccg = ccg.replace(',', '');
    pcn = pcn.replace(',', '');
    practice = practice.replace(',', '');

    if (stp!="") {
      ccg = "";
      pcn = "";
      practice = "";
    }
    if (ccg!="") {
      pcn = "";
      practice = "";
    }
    if (pcn!="") {
      practice = "";
    }

    if (series==''||(stp==''&&ccg==''&&pcn==''&&practice==''))
      return;

    let ethnic = this.selectedethnic1.toString();
    let age = this.selectedage1.toString();
    let sex = this.selectedsex1.toString();

    if (this.selectAllEthnic1)
      ethnic = 'All';
    if (this.selectAllAge1)
      age = 'All';
    if (this.selectAllSex1)
      sex = 'All';

    if (this.showLineCharts1) {
      let cumulative = "0";
      if (this.cumulative1) {
        cumulative = "1";
      }
      let weekly = "0";
      if (this.weekly1) {
        weekly = "1";
      }

      let rate = "0";
      if (this.rate1) {
        rate = "1";
      }

      this.showPrompt = false;
      this.showWait = true;
      this.showCharts = false;

      let cumulativeText = '';
      if (cumulative=="1")
        cumulativeText+='cumulative ';

      if (weekly=="1") {
        this.chartSelections1='Weekly '+cumulativeText+'trend'
      }
      else {
        this.chartSelections1='Daily '+cumulativeText+'trend'
      }

      if (rate == '1') {
        this.yAxisLabel1 = 'Rate per 100,000 patients';
      } else
        this.yAxisLabel1 = this.yAxisLabel;

      this.xAxisLabel1 = this.chartSelections1;
      this.chartSelections2 = ' of '+series;
      this.chartSelections3 = ' in '+stp+ccg+pcn+practice;
      this.chartSelections4 =' (Ethnic groups: '+ethnic+'. Age groups: '+age+'. Sex groups: '+sex+')';

      let re = /\,/gi;

      this.chartSelections2 = this.chartSelections2.replace(re, ", ");
      this.chartSelections3 = this.chartSelections3.replace(re, ", ");
      this.chartSelections4 = this.chartSelections4.replace(re, ", ");

      this.explorerService.getDashboardCovid(this.dashboardId, series, this.formatDate(this.dateFrom1), this.formatDate(this.dateTo1), stp, ccg, pcn, practice, ethnic, age, sex, cumulative, weekly, rate, this.combineSeries1, this.combineEthnic1, this.combineAge1, this.combineSex1, this.combineOrgs)
        .subscribe(result => {

          this.showPrompt = false;
          this.showWait = false;
          this.showCharts = true;

          this.chartResults1 = result.results;

          // apply log10 to values in series
          this.chartResults1 = this.chartResults1.map(
            e => {
              return {
                name: e.name,
                series: e.series.map(
                  v => {
                    return {
                      name: new Date(v.name),
                      value: this.applyLogarithm1(v.value)
                    }
                  }
                )
              }
            }
          )
        });
    }

    if (this.showBarCharts1) {
      this.explorerService.getDashboardSingle(this.dashboardId, series, this.formatDate(this.dateFrom1), this.formatDate(this.dateTo1), 0, ccg)
        .subscribe(result => {
          this.chartResultsSingle1 = result.series;
        });
    }

  }

  loadList(lists: any) {
    lists.results.map(
      e => {
        this.ethnicList1.push(e.type);
      }
    )
    this.ethnicValues1 = new FormControl(this.ethnicList1);

    this.ageValues1 = new FormControl(this.ageList1);
    this.selectedage1 = this.ageList1;

    this.explorerService.getLookupLists('20','')
      .subscribe(
        (result) => this.loadList2(result),
        (error) => this.log.error(error)
      );

  }

  loadList2(lists: any) {
    lists.results.map(
      e => {
        this.ageList1.push(e.type);
      }
    )
    this.ageValues1 = new FormControl(this.ageList1);

    this.sexValues1 = new FormControl(this.sexList1);
    this.selectedsex1 = this.sexList1;

    this.explorerService.getLookupLists('21','')
      .subscribe(
        (result) => this.loadList3(result),
        (error) => this.log.error(error)
      );
  }

  loadList3(lists: any) {
    lists.results.map(
      e => {
        this.sexList1.push(e.type);
      }
    )
    this.sexValues1 = new FormControl(this.sexList1);

    this.route.queryParams
      .subscribe(params => {
        this.dashboardId = params['dashboardNumber'];

        this.explorerService.getCovidView(this.dashboardId)
          .subscribe(
            (result) => this.parseDashboard(result),
            (error) => this.log.error(error)
          );
      });

  }

  parseDashboard (result: any) {
    result.results.map(
      e => {
        let query: dashboardQuery = JSON.parse(e.jsonQuery);

        this.chartTitle1 = query.selectedVisualisation1;
        this.xAxisLabel1 = query.xAxisLabel1;
        this.yAxisLabel = query.yAxisLabel1;
        this.selectedWidgets = query.visualType;

        this.loadSeries();
      }
    )

    this.refreshDashboard();

  }

  loadSeries() {
     this.explorerService.getSeriesFromDashboardId(this.dashboardId)
        .subscribe(
          (result) => this.loadSeriesFilter(result),
          (error) => this.log.error(error)
        );
  }

  loadSeriesFilter(result: any) {
    let seriesMap = [];
    result.results.map(
      e => {
        seriesMap.push(e.name);
      }
    )

    this.selectedSeries1 = seriesMap;
    this.seriesList1 = this.selectedSeries1;
    this.seriesValues1 = new FormControl(this.seriesList1);

    this.refreshDashboard();
  }

  formatTooltipYAxis1(val: number) {
    if (this.logarithmic1 == true) {
      val = Math.round((Math.pow(10, val) + Number.EPSILON) * 100) / 100;
      return val.toLocaleString()
    } else {
      return Number(val).toLocaleString()
    }
  }

  formatYAxis(val: number) {
    if (val < 5) {
      val = Math.round(Math.pow(10, val));
      return val.toLocaleString()
    } else {
      return Number(val).toLocaleString()
    }
  }

  applyLogarithm1(value: number) {
    if (this.logarithmic1 == true) {
      return Math.log10(value)
    } else {
      return value
    }
  }

  formatXAxis(date) {
    var d = new Date(date),
      month = '' + (d.getMonth()),
      day = '' + d.getDate(),
      year = d.getFullYear();

    if (day.length < 2)
      day = '0' + day;

    let months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    var monthName = months[(Number(month))];

    return [day, monthName, year].join('-');
  }

  onSelectLine1(data): void {
    // this.patientDialog(data.series, data.name, this.selectOrg);
  }

  onSelectBar1(data): void {
    // this.patientDialog(this.selectedSeries1, data.name, this.selectOrg);
  }

  patientDialog(chartName: any, seriesName: any, ccgs: any) {
    const dialogRef = this.dialog.open(PatientComponent, {
      disableClose: true,
      height: '830px',
      width: '1600px',

      data: {chartName: chartName, seriesName: seriesName, ccgs: ccgs}
    });

    dialogRef.afterClosed().subscribe(result => {
      let patientId = 0;
      if (result) {
        patientId = result;
        window.location.href = "https://devgateway.discoverydataservice.net/record-viewer/#/summary?patient_id="+patientId;
      }
    });
  }

  formatDate(date) {
    var d = new Date(date),
      month = '' + (d.getMonth() + 1),
      day = '' + d.getDate(),
      year = d.getFullYear();

    if (month.length < 2)
      month = '0' + month;
    if (day.length < 2)
      day = '0' + day;

    return [year, month, day].join('-');
  }

  download1() {
    var csvData = '';
    if (this.showLineCharts1)
      csvData = this.ConvertToCSVMulti(this.chartResults1);
    else
      csvData = this.ConvertToCSVSingle(this.chartResultsSingle1,this.selectedSeries1.toString());

    let exportData = this.csvJSON(csvData);

    if (exportData) {
      let options = {
        fieldSeparator: ',',
        quoteStrings: '"',
        decimalseparator: '.',
        showLabels: true,
        headers: ['key','point','count'],
        showTitle: false,
        title: '`````dashboard`````',
        useTextFile: false,
        useBom: false,
      };
      new ngxCsv(exportData, 'dashboard', options);
    }
  }

  csvJSON(csv){
    var lines=csv.split("\n");

    var result = [];

    var headers=lines[0].split(",");

    headers = ["key","point","count"];

    for(var i=0;i<lines.length-1;i++){

      var obj = {};
      var currentline=lines[i].split(",");

      for(var j=0;j<headers.length;j++){
        obj[headers[j]] = currentline[j];
      }

      result.push(obj);

    }
    return result;
  }

  ConvertToCSVMulti(objArray) {
    let array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    let csv = '';
    for (let key in array) {
      if (array.hasOwnProperty(key)) {
        for (let key2 in array[key].series) {
          if (array[key].series.hasOwnProperty(key2)) {
            let point = array[key].series[key2].name;
            if (point.toString().indexOf("GMT") > -1) { // date type of series
              point = this.formatDate(point);
            }
            csv += array[key].name+ ',' + point + ',' + array[key].series[key2].value + '\n';
          }
        }
      }
    }
    return csv;
  }

  ConvertToCSVSingle(objArray, series) {
    let array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    let csv = 'key,point,count\r\n';
    for (let key in array) {
      if (array.hasOwnProperty(key)) {
        let point = array[key].name;
        if (point.toString().indexOf("GMT") > -1) { // date type of series
          point = this.formatDate(point);
        }
        csv += series+ ',' + point + ',' + array[key].value + '\n';
      }
    }
    return csv;
  }

  /** Map from flat node to nested node. This helps us finding the nested node to be modified */
  flatNodeMap = new Map<OrgItemFlatNode, OrgItemNode>();

  /** Map from nested node to flattened node. This helps us to keep the same object for selection */
  nestedNodeMap = new Map<OrgItemNode, OrgItemFlatNode>();

  /** A selected parent node to be inserted */
  selectedParent: OrgItemFlatNode | null = null;

  treeControl: FlatTreeControl<OrgItemFlatNode>;

  treeFlattener: MatTreeFlattener<OrgItemNode, OrgItemFlatNode>;

  dataSource: MatTreeFlatDataSource<OrgItemNode, OrgItemFlatNode>;

  /** The selection for checklist */
  checklistSelection = new SelectionModel<OrgItemFlatNode>(true /* multiple */);

  getLevel = (node: OrgItemFlatNode) => node.level;

  isExpandable = (node: OrgItemFlatNode) => node.expandable;

  getChildren = (node: OrgItemNode): OrgItemNode[] => node.children;

  hasChild = (_: number, _nodeData: OrgItemFlatNode) => _nodeData.expandable;

  hasNoContent = (_: number, _nodeData: OrgItemFlatNode) => _nodeData.item === '';

  /**
   * Transformer to convert nested node to flat node. Record the nodes in maps for later use.
   */
  transformer = (node: OrgItemNode, level: number) => {
    const existingNode = this.nestedNodeMap.get(node);
    const flatNode = existingNode && existingNode.item === node.item
      ? existingNode
      : new OrgItemFlatNode();
    flatNode.item = node.item;
    flatNode.level = level;
    if (node.children!=undefined)
      flatNode.expandable = node.children.length>0;
    this.flatNodeMap.set(flatNode, node);
    this.nestedNodeMap.set(node, flatNode);
    return flatNode;
  }

  /** Whether all the descendants of the node are selected. */
  descendantsAllSelected(node: OrgItemFlatNode): boolean {
    const descendants = this.treeControl.getDescendants(node);
    const descAllSelected = descendants.length > 0 && descendants.every(child => {
      return this.checklistSelection.isSelected(child);
    });
    return descAllSelected;
  }

  /** Whether part of the descendants are selected */
  descendantsPartiallySelected(node: OrgItemFlatNode): boolean {
    const descendants = this.treeControl.getDescendants(node);
    const result = descendants.some(child => this.checklistSelection.isSelected(child));
    return result && !this.descendantsAllSelected(node);
  }

  /** Toggle the orgitem selection. Select/deselect all the descendants node */
  OrgItemSelectionToggle(node: OrgItemFlatNode): void {
    this.checklistSelection.toggle(node);
    const descendants = this.treeControl.getDescendants(node);
    this.checklistSelection.isSelected(node)
      ? this.checklistSelection.select(...descendants)
      : this.checklistSelection.deselect(...descendants);

    // Force update for the parent
    descendants.forEach(child => this.checklistSelection.isSelected(child));
    this.checkAllParentsSelection(node);

    this.refreshDashboard();
  }

  /** Toggle a leaf orgitem selection. Check all the parents to see if they changed */
  OrgLeafItemSelectionToggle(node: OrgItemFlatNode): void {
    this.checklistSelection.toggle(node);
    this.checkAllParentsSelection(node);

    this.refreshDashboard();
  }

  /* Checks all the parents when a leaf node is selected/unselected */
  checkAllParentsSelection(node: OrgItemFlatNode): void {
    let parent: OrgItemFlatNode | null = this.getParentNode(node);
    while (parent) {
      this.checkRootNodeSelection(parent);
      parent = this.getParentNode(parent);
    }
  }

  /** Check root node checked state and change it accordingly */
  checkRootNodeSelection(node: OrgItemFlatNode): void {
    const nodeSelected = this.checklistSelection.isSelected(node);
    const descendants = this.treeControl.getDescendants(node);
    const descAllSelected = descendants.length > 0 && descendants.every(child => {
      return this.checklistSelection.isSelected(child);
    });
    if (nodeSelected && !descAllSelected) {
      this.checklistSelection.deselect(node);
    } else if (!nodeSelected && descAllSelected) {
      //this.checklistSelection.select(node);
    }
  }

  /* Get the parent node of a node */
  getParentNode(node: OrgItemFlatNode): OrgItemFlatNode | null {
    const currentLevel = this.getLevel(node);

    if (currentLevel < 1) {
      return null;
    }

    const startIndex = this.treeControl.dataNodes.indexOf(node) - 1;

    for (let i = startIndex; i >= 0; i--) {
      const currentNode = this.treeControl.dataNodes[i];

      if (this.getLevel(currentNode) < currentLevel) {
        return currentNode;
      }
    }
    return null;
  }
}
