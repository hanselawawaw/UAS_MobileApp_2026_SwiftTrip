import '../models/airport_model.dart';

class AirportSearchService {
  static const List<Map<String, String>> commonAirports = [
    // --- INDONESIA (Core Hubs) ---
    {
      'iataCode': 'CGK',
      'name': 'Soekarno-Hatta International Airport',
      'cityName': 'Jakarta',
      'countryCode': 'ID',
      'lat': '-6.1256',
      'lng': '106.6560',
    },
    {
      'iataCode': 'DPS',
      'name': 'Ngurah Rai International Airport',
      'cityName': 'Denpasar',
      'countryCode': 'ID',
      'lat': '-8.7482',
      'lng': '115.1675',
    },
    {
      'iataCode': 'SUB',
      'name': 'Juanda International Airport',
      'cityName': 'Surabaya',
      'countryCode': 'ID',
      'lat': '-7.3797',
      'lng': '112.7875',
    },
    {
      'iataCode': 'KNO',
      'name': 'Kualanamu International Airport',
      'cityName': 'Medan',
      'countryCode': 'ID',
      'lat': '3.642',
      'lng': '98.885',
    },
    {
      'iataCode': 'UPG',
      'name': 'Sultan Hasanuddin International Airport',
      'cityName': 'Makassar',
      'countryCode': 'ID',
      'lat': '-5.062',
      'lng': '119.554',
    },
    {
      'iataCode': 'YIA',
      'name': 'Yogyakarta International Airport',
      'cityName': 'Yogyakarta',
      'countryCode': 'ID',
      'lat': '-7.900',
      'lng': '110.050',
    },
    {
      'iataCode': 'BPN',
      'name': 'Sultan Aji Muhammad Sulaiman Sepinggan Airport',
      'cityName': 'Balikpapan',
      'countryCode': 'ID',
      'lat': '-1.268',
      'lng': '116.895',
    },
    {
      'iataCode': 'BTH',
      'name': 'Hang Nadim International Airport',
      'cityName': 'Batam',
      'countryCode': 'ID',
      'lat': '1.121',
      'lng': '104.118',
    },
    {
      'iataCode': 'SRG',
      'name': 'Ahmad Yani International Airport',
      'cityName': 'Semarang',
      'countryCode': 'ID',
      'lat': '-6.984',
      'lng': '110.375',
    },
    {
      'iataCode': 'PLM',
      'name': 'Sultan Mahmud Badaruddin II Airport',
      'cityName': 'Palembang',
      'countryCode': 'ID',
      'lat': '-2.897',
      'lng': '104.701',
    },

    // --- ASIA ---
    {
      'iataCode': 'SIN',
      'name': 'Changi Airport',
      'cityName': 'Singapore',
      'countryCode': 'SG',
      'lat': '1.3644',
      'lng': '103.9915',
    },
    {
      'iataCode': 'KUL',
      'name': 'Kuala Lumpur International Airport',
      'cityName': 'Kuala Lumpur',
      'countryCode': 'MY',
      'lat': '2.7456',
      'lng': '101.7099',
    },
    {
      'iataCode': 'BKK',
      'name': 'Suvarnabhumi Airport',
      'cityName': 'Bangkok',
      'countryCode': 'TH',
      'lat': '13.6900',
      'lng': '100.7501',
    },
    {
      'iataCode': 'DMK',
      'name': 'Don Mueang International Airport',
      'cityName': 'Bangkok',
      'countryCode': 'TH',
    },
    {
      'iataCode': 'HKT',
      'name': 'Phuket International Airport',
      'cityName': 'Phuket',
      'countryCode': 'TH',
    },
    {
      'iataCode': 'CNX',
      'name': 'Chiang Mai International Airport',
      'cityName': 'Chiang Mai',
      'countryCode': 'TH',
    },
    {
      'iataCode': 'MNL',
      'name': 'Ninoy Aquino International Airport',
      'cityName': 'Manila',
      'countryCode': 'PH',
    },
    {
      'iataCode': 'CEB',
      'name': 'Mactan-Cebu International Airport',
      'cityName': 'Cebu',
      'countryCode': 'PH',
    },
    {
      'iataCode': 'SGN',
      'name': 'Tan Son Nhat International Airport',
      'cityName': 'Ho Chi Minh City',
      'countryCode': 'VN',
    },
    {
      'iataCode': 'HAN',
      'name': 'Noi Bai International Airport',
      'cityName': 'Hanoi',
      'countryCode': 'VN',
    },
    {
      'iataCode': 'DAD',
      'name': 'Da Nang International Airport',
      'cityName': 'Da Nang',
      'countryCode': 'VN',
    },
    {
      'iataCode': 'RGN',
      'name': 'Yangon International Airport',
      'cityName': 'Yangon',
      'countryCode': 'MM',
    },
    {
      'iataCode': 'PNH',
      'name': 'Phnom Penh International Airport',
      'cityName': 'Phnom Penh',
      'countryCode': 'KH',
    },
    {
      'iataCode': 'REP',
      'name': 'Siem Reap International Airport',
      'cityName': 'Siem Reap',
      'countryCode': 'KH',
    },
    {
      'iataCode': 'VTE',
      'name': 'Wattay International Airport',
      'cityName': 'Vientiane',
      'countryCode': 'LA',
    },
    {
      'iataCode': 'HND',
      'name': 'Haneda Airport',
      'cityName': 'Tokyo',
      'countryCode': 'JP',
    },
    {
      'iataCode': 'NRT',
      'name': 'Narita International Airport',
      'cityName': 'Tokyo',
      'countryCode': 'JP',
    },
    {
      'iataCode': 'KIX',
      'name': 'Kansai International Airport',
      'cityName': 'Osaka',
      'countryCode': 'JP',
    },
    {
      'iataCode': 'NGO',
      'name': 'Chubu Centrair International Airport',
      'cityName': 'Nagoya',
      'countryCode': 'JP',
    },
    {
      'iataCode': 'CTS',
      'name': 'New Chitose Airport',
      'cityName': 'Sapporo',
      'countryCode': 'JP',
    },
    {
      'iataCode': 'FUK',
      'name': 'Fukuoka Airport',
      'cityName': 'Fukuoka',
      'countryCode': 'JP',
    },
    {
      'iataCode': 'ICN',
      'name': 'Incheon International Airport',
      'cityName': 'Seoul',
      'countryCode': 'KR',
    },
    {
      'iataCode': 'GMP',
      'name': 'Gimpo International Airport',
      'cityName': 'Seoul',
      'countryCode': 'KR',
    },
    {
      'iataCode': 'CJU',
      'name': 'Jeju International Airport',
      'cityName': 'Jeju',
      'countryCode': 'KR',
    },
    {
      'iataCode': 'HKG',
      'name': 'Hong Kong International Airport',
      'cityName': 'Hong Kong',
      'countryCode': 'HK',
    },
    {
      'iataCode': 'TPE',
      'name': 'Taoyuan International Airport',
      'cityName': 'Taipei',
      'countryCode': 'TW',
    },
    {
      'iataCode': 'TSA',
      'name': 'Songshan Airport',
      'cityName': 'Taipei',
      'countryCode': 'TW',
    },
    {
      'iataCode': 'PVG',
      'name': 'Pudong International Airport',
      'cityName': 'Shanghai',
      'countryCode': 'CN',
    },
    {
      'iataCode': 'SHA',
      'name': 'Hongqiao International Airport',
      'cityName': 'Shanghai',
      'countryCode': 'CN',
    },
    {
      'iataCode': 'PEK',
      'name': 'Beijing Capital International Airport',
      'cityName': 'Beijing',
      'countryCode': 'CN',
    },
    {
      'iataCode': 'PKX',
      'name': 'Beijing Daxing International Airport',
      'cityName': 'Beijing',
      'countryCode': 'CN',
    },
    {
      'iataCode': 'CAN',
      'name': 'Guangzhou Baiyun International Airport',
      'cityName': 'Guangzhou',
      'countryCode': 'CN',
    },
    {
      'iataCode': 'SZX',
      'name': 'Shenzhen Bao\'an International Airport',
      'cityName': 'Shenzhen',
      'countryCode': 'CN',
    },
    {
      'iataCode': 'CTU',
      'name': 'Chengdu Tianfu International Airport',
      'cityName': 'Chengdu',
      'countryCode': 'CN',
    },
    {
      'iataCode': 'MFM',
      'name': 'Macau International Airport',
      'cityName': 'Macau',
      'countryCode': 'MO',
    },
    {
      'iataCode': 'DEL',
      'name': 'Indira Gandhi International Airport',
      'cityName': 'Delhi',
      'countryCode': 'IN',
    },
    {
      'iataCode': 'BOM',
      'name': 'Chhatrapati Shivaji Maharaj Intl Airport',
      'cityName': 'Mumbai',
      'countryCode': 'IN',
    },
    {
      'iataCode': 'BLR',
      'name': 'Kempegowda International Airport',
      'cityName': 'Bangalore',
      'countryCode': 'IN',
    },
    {
      'iataCode': 'MAA',
      'name': 'Chennai International Airport',
      'cityName': 'Chennai',
      'countryCode': 'IN',
    },
    {
      'iataCode': 'HYD',
      'name': 'Rajiv Gandhi International Airport',
      'cityName': 'Hyderabad',
      'countryCode': 'IN',
    },
    {
      'iataCode': 'CCU',
      'name': 'Netaji Subhas Chandra Bose Intl Airport',
      'cityName': 'Kolkata',
      'countryCode': 'IN',
    },
    {
      'iataCode': 'CMB',
      'name': 'Bandaranaike International Airport',
      'cityName': 'Colombo',
      'countryCode': 'LK',
    },
    {
      'iataCode': 'DAC',
      'name': 'Hazrat Shahjalal International Airport',
      'cityName': 'Dhaka',
      'countryCode': 'BD',
    },
    {
      'iataCode': 'KTM',
      'name': 'Tribhuvan International Airport',
      'cityName': 'Kathmandu',
      'countryCode': 'NP',
    },
    {
      'iataCode': 'MLE',
      'name': 'Velana International Airport',
      'cityName': 'Male',
      'countryCode': 'MV',
    },
    {
      'iataCode': 'PEN',
      'name': 'Penang International Airport',
      'cityName': 'Penang',
      'countryCode': 'MY',
    },
    {
      'iataCode': 'BKI',
      'name': 'Kota Kinabalu International Airport',
      'cityName': 'Kota Kinabalu',
      'countryCode': 'MY',
    },
    {
      'iataCode': 'PUS',
      'name': 'Gimhae International Airport',
      'cityName': 'Busan',
      'countryCode': 'KR',
    },
    {
      'iataCode': 'KMG',
      'name': 'Kunming Changshui International Airport',
      'cityName': 'Kunming',
      'countryCode': 'CN',
    },
    {
      'iataCode': 'XIY',
      'name': 'Xi\'an Xianyang International Airport',
      'cityName': 'Xi\'an',
      'countryCode': 'CN',
    },
    {
      'iataCode': 'HGH',
      'name': 'Hangzhou Xiaoshan International Airport',
      'cityName': 'Hangzhou',
      'countryCode': 'CN',
    },

    // --- MIDDLE EAST / WEST ASIA ---
    {
      'iataCode': 'DXB',
      'name': 'Dubai International Airport',
      'cityName': 'Dubai',
      'countryCode': 'AE',
      'lat': '25.2532',
      'lng': '55.3657',
    },
    {
      'iataCode': 'AUH',
      'name': 'Abu Dhabi International Airport',
      'cityName': 'Abu Dhabi',
      'countryCode': 'AE',
    },
    {
      'iataCode': 'DOH',
      'name': 'Hamad International Airport',
      'cityName': 'Doha',
      'countryCode': 'QA',
    },
    {
      'iataCode': 'KWI',
      'name': 'Kuwait International Airport',
      'cityName': 'Kuwait City',
      'countryCode': 'KW',
    },
    {
      'iataCode': 'RUH',
      'name': 'King Khalid International Airport',
      'cityName': 'Riyadh',
      'countryCode': 'SA',
    },
    {
      'iataCode': 'JED',
      'name': 'King Abdulaziz International Airport',
      'cityName': 'Jeddah',
      'countryCode': 'SA',
    },
    {
      'iataCode': 'MCT',
      'name': 'Muscat International Airport',
      'cityName': 'Muscat',
      'countryCode': 'OM',
    },
    {
      'iataCode': 'AMM',
      'name': 'Queen Alia International Airport',
      'cityName': 'Amman',
      'countryCode': 'JO',
    },

    // --- AUSTRALIA & OCEANIA (Study Destinations) ---
    {
      'iataCode': 'SYD',
      'name': 'Kingsford Smith Airport',
      'cityName': 'Sydney',
      'countryCode': 'AU',
      'lat': '-33.9399',
      'lng': '151.1753',
    },
    {
      'iataCode': 'MEL',
      'name': 'Melbourne Airport',
      'cityName': 'Melbourne',
      'countryCode': 'AU',
    },
    {
      'iataCode': 'PER',
      'name': 'Perth Airport',
      'cityName': 'Perth',
      'countryCode': 'AU',
    },
    {
      'iataCode': 'BNE',
      'name': 'Brisbane Airport',
      'cityName': 'Brisbane',
      'countryCode': 'AU',
    },
    {
      'iataCode': 'ADL',
      'name': 'Adelaide Airport',
      'cityName': 'Adelaide',
      'countryCode': 'AU',
    },
    {
      'iataCode': 'AKL',
      'name': 'Auckland Airport',
      'cityName': 'Auckland',
      'countryCode': 'NZ',
    },
    {
      'iataCode': 'CHC',
      'name': 'Christchurch International Airport',
      'cityName': 'Christchurch',
      'countryCode': 'NZ',
    },

    // --- EUROPE (Main Hubs) ---
    {
      'iataCode': 'IST',
      'name': 'Istanbul Airport',
      'cityName': 'Istanbul',
      'countryCode': 'TR',
    },
    {
      'iataCode': 'LHR',
      'name': 'Heathrow Airport',
      'cityName': 'London',
      'countryCode': 'GB',
      'lat': '51.4700',
      'lng': '-0.4543',
    },
    {
      'iataCode': 'CDG',
      'name': 'Charles de Gaulle Airport',
      'cityName': 'Paris',
      'countryCode': 'FR',
      'lat': '49.0097',
      'lng': '2.5479',
    },
    {
      'iataCode': 'AMS',
      'name': 'Schiphol Airport',
      'cityName': 'Amsterdam',
      'countryCode': 'NL',
      'lat': '52.311',
      'lng': '4.768',
    },
    {
      'iataCode': 'FRA',
      'name': 'Frankfurt Airport',
      'cityName': 'Frankfurt',
      'countryCode': 'DE',
      'lat': '50.033',
      'lng': '8.571',
    },
    {
      'iataCode': 'ZRH',
      'name': 'Zurich Airport',
      'cityName': 'Zurich',
      'countryCode': 'CH',
    },
    {
      'iataCode': 'FCO',
      'name': 'Leonardo da Vinci–Fiumicino Airport',
      'cityName': 'Rome',
      'countryCode': 'IT',
    },
    {
      'iataCode': 'MAD',
      'name': 'Adolfo Suárez Madrid–Barajas Airport',
      'cityName': 'Madrid',
      'countryCode': 'ES',
    },

    // --- AMERICAS & AFRICA ---
    {
      'iataCode': 'JFK',
      'name': 'John F. Kennedy International Airport',
      'cityName': 'New York',
      'countryCode': 'US',
      'lat': '40.6413',
      'lng': '-73.7781',
    },
    {
      'iataCode': 'LAX',
      'name': 'Los Angeles International Airport',
      'cityName': 'Los Angeles',
      'countryCode': 'US',
      'lat': '33.9416',
      'lng': '-118.4085',
    },
    {
      'iataCode': 'SFO',
      'name': 'San Francisco International Airport',
      'cityName': 'San Francisco',
      'countryCode': 'US',
    },
    {
      'iataCode': 'YYZ',
      'name': 'Toronto Pearson International Airport',
      'cityName': 'Toronto',
      'countryCode': 'CA',
    },
    {
      'iataCode': 'GRU',
      'name': 'Guarulhos–Governador André Franco Montoro Intl',
      'cityName': 'Sao Paulo',
      'countryCode': 'BR',
    },
    {
      'iataCode': 'JNB',
      'name': 'O. R. Tambo International Airport',
      'cityName': 'Johannesburg',
      'countryCode': 'ZA',
    },
    {
      'iataCode': 'CAI',
      'name': 'Cairo International Airport',
      'cityName': 'Cairo',
      'countryCode': 'EG',
    },
    {
      'iataCode': 'MEX',
      'name': 'Mexico City International Airport',
      'cityName': 'Mexico City',
      'countryCode': 'MX',
    },
  ];

  Future<List<AirportResult>> searchAirports(String query) async {
    if (query.trim().isEmpty) return [];

    final lowerQuery = query.trim().toLowerCase();

    final filtered = commonAirports.where((airport) {
      final cityName = (airport['cityName'] ?? '').toLowerCase();
      final iataCode = (airport['iataCode'] ?? '').toLowerCase();

      return cityName.contains(lowerQuery) || iataCode.contains(lowerQuery);
    }).toList();

    return filtered
        .map(
          (e) => AirportResult(
            iataCode: e['iataCode'] ?? '',
            name: e['name'] ?? '',
            cityName: e['cityName'] ?? '',
            countryCode: e['countryCode'] ?? '',
          ),
        )
        .toList();
  }
}
