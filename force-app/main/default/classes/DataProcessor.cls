public class DataProcessor {
        // Translation map
        private static Map<String, String> countryTranslations = new Map<String, String>{
                'États-Unis' => 'United States',
                'Canada' => 'Canada',
                'Afghanistan' => 'Afghanistan',
                'Iles Åland' => 'Aland Islands',
                'Albanie' => 'Albania',
                'Algérie' => 'Algeria',
                'Andorre' => 'Andorra',
                'Angola' => 'Angola',
                'Anguilla' => 'Anguilla',
                'Antarctique' => 'Antarctica',
                'Antigua-et-Barbuda' => 'Antigua and Barbuda',
                'Argentine' => 'Argentina',
                'Arménie' => 'Armenia',
                'Aruba' => 'Aruba',
                'Australie' => 'Australia',
                'Autriche' => 'Austria',
                'Azerbaïdjan' => 'Azerbaijan',
                'Bahamas' => 'Bahamas',
                'Bahreïn' => 'Bahrain',
                'Bangladesh' => 'Bangladesh',
                'Barbade' => 'Barbados',
                'Biélorussie' => 'Belarus',
                'Belgique' => 'Belgium',
                'Belize' => 'Belize',
                'Bénin' => 'Benin',
                'Bermudes' => 'Bermuda',
                'Bhoutan' => 'Bhutan',
                'Bolivie' => 'Bolivia',
                'Bosnie-Herzégovine' => 'Bosnia and Herzegovina',
                'Botswana' => 'Botswana',
                'Brésil' => 'Brazil',
                'Territoire britannique de l\'océan Indien' => 'British Indian Ocean Territory',
                'Brunéi Darussalam' => 'Brunei Darussalam',
                'Bulgarie' => 'Bulgaria',
                'Burkina Faso' => 'Burkina Faso',
                'Burundi' => 'Burundi',
                'Cambodge' => 'Cambodia',
                'Cameroun' => 'Cameroon',
                'Cap-Vert' => 'Cape Verde',
                'Iles Caïmans' => 'Cayman Islands',
                'République centrafricaine' => 'Central African Republic',
                'Tchad' => 'Chad',
                'Chili' => 'Chile',
                'Chine' => 'China',
                'Iles Christmas' => 'Christmas Island',
                'Colombie' => 'Colombia',
                'Comores' => 'Comoros',
                'Congo' => 'Congo',
                'République démocratique du Congo' => 'Congo (Brazzaville)',
                'Iles Cook' => 'Cook Islands',
                'Costa Rica' => 'Costa Rica',
                'Côte d\'Ivoire' => 'Cote d\'Ivoire',
                'Croatie' => 'Croatia',
                'Cuba' => 'Cuba',
                'Chypre' => 'Cyprus',
                'République tchèque' => 'Czech Republic',
                'Danemark' => 'Denmark',
                'Djibouti' => 'Djibouti',
                'Dominique' => 'Dominica',
                'République dominicaine' => 'Dominican Republic',
                'Équateur' => 'Ecuador',
                'Égypte' => 'Egypt',
                'El Salvador' => 'El Salvador',
                'Guinée équatoriale' => 'Equatorial Guinea',
                'Érythrée' => 'Eritrea',
                'Estonie' => 'Estonia',
                'Eswatini' => 'Eswatini',
                'Éthiopie' => 'Ethiopia',
                'Iles Malouines' => 'Falkland Islands (Malvinas)',
                'Iles Féroé' => 'Faroe Islands',
                'Fidji' => 'Fiji',
                'Finlande' => 'Finland',
                'France' => 'France',
                'Guyane française' => 'French Guiana',
                'Polynésie française' => 'French Polynesia',
                'Gabon' => 'Gabon',
                'Gambie' => 'Gambia',
                'Géorgie' => 'Georgia',
                'Allemagne' => 'Germany',
                'Ghana' => 'Ghana',
                'Gibraltar' => 'Gibraltar',
                'Grèce' => 'Greece',
                'Groenland' => 'Greenland',
                'Grenade' => 'Grenada',
                'Guadeloupe' => 'Guadeloupe',
                'Guam' => 'Guam',
                'Guatemala' => 'Guatemala',
                'Guernesey' => 'Guernsey',
                'Guinée' => 'Guinea',
                'Guinée-Bissau' => 'Guinea-Bissau',
                'Guyana' => 'Guyana',
                'Haïti' => 'Haiti',
                'Ile Heard et Iles McDonald' => 'Heard and McDonald Islands',
                'Saint-Siège' => 'Holy See (Vatican City State)',
                'Honduras' => 'Honduras',
                'Hong Kong' => 'Hong Kong, SAR China',
                'Hongrie' => 'Hungary',
                'Islande' => 'Iceland',
                'Inde' => 'India',
                'Indonésie' => 'Indonesia',
                'Iran' => 'Iran, Islamic Republic of',
                'Irak' => 'Iraq',
                'Irlande' => 'Ireland',
                'Ile de Man' => 'Isle of Man',
                'Israël' => 'Israel',
                'Italie' => 'Italy',
                'Jamaïque' => 'Jamaica',
                'Japon' => 'Japan',
                'Jersey' => 'Jersey',
                'Jordanie' => 'Jordan',
                'Kazakhstan' => 'Kazakhstan',
                'Kenya' => 'Kenya',
                'Kiribati' => 'Kiribati',
                'Corée, République populaire démocratique de' => 'Korea, Dem People\'s Rep of',
                'Corée, République de' => 'Korea, Republic of',
                'Koweït' => 'Kuwait',
                'Kirghizistan' => 'Kyrgyzstan',
                'Laos' => 'Lao',
                'Lettonie' => 'Latvia',
                'Liban' => 'Lebanon',
                'Lesotho' => 'Lesotho',
                'Libéria' => 'Liberia',
                'Libye' => 'Libya',
                'Liechtenstein' => 'Liechtenstein',
                'Lituanie' => 'Lithuania',
                'Luxembourg' => 'Luxembourg',
                'Macao' => 'Macao',
                'Macédoine, République de' => 'Macedonia, the former Yugoslav Republic of',
                'Madagascar' => 'Madagascar',
                'Malawi' => 'Malawi',
                'Malaisie' => 'Malaysia',
                'Maldives' => 'Maldives',
                'Mali' => 'Mali',
                'Malte' => 'Malta',
                'Iles Marshall' => 'Marshall Islands',
                'Martinique' => 'Martinique',
                'Mauritanie' => 'Mauritania',
                'Maurice' => 'Mauritius',
                'Mayotte' => 'Mayotte',
                'Mexique' => 'Mexico',
                'Micronésie, États fédérés de' => 'Micronesia, Federated States of',
                'Moldavie, République de' => 'Moldova, Republic of',
                'Monaco' => 'Monaco',
                'Mongolie' => 'Mongolia',
                'Monténégro' => 'Montenegro',
                'Montserrat' => 'Montserrat',
                'Maroc' => 'Morocco',
                'Mozambique' => 'Mozambique',
                'Myanmar' => 'Myanmar',
                'Namibie' => 'Namibia',
                'Nauru' => 'Nauru',
                'Népal' => 'Nepal',
                'Pays-Bas' => 'Netherlands',
                'Nouvelle-Calédonie' => 'New Caledonia',
                'Nouvelle-Zélande' => 'New Zealand',
                'Nicaragua' => 'Nicaragua',
                'Niger' => 'Niger',
                'Nigéria' => 'Nigeria',
                'Niue' => 'Niue',
                'Ile Norfolk' => 'Norfolk Island',
                'Iles Mariannes du Nord' => 'Northern Mariana Islands',
                'Norvège' => 'Norway',
                'Oman' => 'Oman',
                'Pakistan' => 'Pakistan',
                'Palaos' => 'Palau',
                'Palestine, État de' => 'Palestinian',
                'Panama' => 'Panama',
                'Papouasie-Nouvelle-Guinée' => 'Papua New Guinea',
                'Paraguay' => 'Paraguay',
                'Pérou' => 'Peru',
                'Philippines' => 'Philippines',
                'Pitcairn' => 'Pitcairn',
                'Pologne' => 'Poland',
                'Portugal' => 'Portugal',
                'Porto Rico' => 'Puerto Rico',
                'Qatar' => 'Qatar',
                'Réunion' => 'Reunion',
                'Roumanie' => 'Romania',
                'Russie, Fédération de' => 'Russian Federation',
                'Rwanda' => 'Rwanda',
                'Saint-Barthélemy' => 'Saint-Barthelemy',
                'Sainte-Hélène, Ascension et Tristan da Cunha' => 'Saint Helena, Ascension and Tristan da Cunha',
                'Saint-Kitts-et-Nevis' => 'Saint Kitts and Nevis',
                'Sainte-Lucie' => 'Saint Lucia',
                'Saint-Martin (partie française)' => 'Saint Martin (French part)',
                'Saint-Pierre-et-Miquelon' => 'Saint Pierre and Miquelon',
                'Saint-Vincent-et-les-Grenadines' => 'Saint Vincent and the Grenadines',
                'Samoa' => 'Samoa',
                'Saint-Marin' => 'San Marino',
                'Sao Tomé-et-Principe' => 'Sao Tome and Principe',
                'Arabie saoudite' => 'Saudi Arabia',
                'Sénégal' => 'Senegal',
                'Serbie' => 'Serbia',
                'Seychelles' => 'Seychelles',
                'Sierra Leone' => 'Sierra Leone',
                'Singapour' => 'Singapore',
                'Saint-Martin (partie néerlandaise)' => 'Sint Maarten (Dutch part)',
                'Slovaquie' => 'Slovakia',
                'Slovénie' => 'Slovenia',
                'Iles Salomon' => 'Solomon Islands',
                'Somalie' => 'Somalia',
                'Afrique du Sud' => 'South Africa',
                'Géorgie du Sud-et-les Iles Sandwich du Sud' => 'South Georgia and the South Sandwich Islands',
                'Soudan du Sud' => 'South Sudan',
                'Espagne' => 'Spain',
                'Sri Lanka' => 'Sri Lanka',
                'Soudan' => 'Sudan',
                'Suriname' => 'Suriname',
                'Svalbard et Jan Mayen' => 'Svalbard and Jan Mayen Islands',
                'Suède' => 'Sweden',
                'Suisse' => 'Switzerland',
                'Syrie' => 'Syrian Arab Republic (Syria)',
                'Taïwan, Province de Chine' => 'Taiwan, Republic of China',
                'Tadjikistan' => 'Tajikistan',
                'Tanzanie, République-Unie de' => 'Tanzania, United Republic of',
                'Thaïlande' => 'Thailand',
                'Timor-Leste' => 'Timor-Leste',
                'Togo' => 'Togo',
                'Tokelau' => 'Tokelau',
                'Tonga' => 'Tonga',
                'Trinité-et-Tobago' => 'Trinidad and Tobago',
                'Tunisie' => 'Tunisia',
                'Turquie' => 'Turkey',
                'Turkménistan' => 'Turkmenistan',
                'Iles Turques-et-Caïques' => 'Turks and Caicos Islands',
                'Tuvalu' => 'Tuvalu',
                'Ouganda' => 'Uganda',
                'Ukraine' => 'Ukraine',
                'Émirats arabes unis' => 'United Arab Emirates',
                'Royaume-Uni' => 'United Kingdom',
                'Uruguay' => 'Uruguay',
                'Ouzbékistan' => 'Uzbekistan',
                'Vanuatu' => 'Vanuatu',
                'Venezuela (République bolivarienne de)' => 'Venezuela (Bolivarian Republic)',
                'Viet Nam' => 'Viet Nam',
                'Iles Vierges britanniques' => 'Virgin Islands, British',
                'Iles Vierges des États-Unis' => 'Virgin Islands, US',
                'Wallis-et-Futuna' => 'Wallis and Futuna Islands',
                'Sahara occidental' => 'Western Sahara',
                'Yémen' => 'Yemen',
                'Zambie' => 'Zambia',
                'Zimbabwe' => 'Zimbabwe'};
                
         private static Map<String, String> ambitionMap = new Map<String, String> {
                'Créer mon enterprise' => 'Develop my own business',
                'Un emploi salarié' => 'Paid employment',
                'Une autre formation / un autre type d\'études' => 'Another training / type of education',
                'Je ne sais pas encore' => 'I don`t know yet',
                'Autre' => 'Other'
        };
            
        private static Map<String, String> discoveryMap = new Map<String, String> {
            'Réseaux sociaux (Facebook, Instagram, LinkedIn, Twitter,...)' => 'Social media (Facebook, Instagram, LinkedIn, Twitter,...)',
            'Médias (article, interviews, TV,...)' => 'Media (article, interviews, TV....)',
            'Publicité (flyers, annonces sur sites internet, journal, radio,...)' => 'Publicity (flyers, ads on websites, journal, radio....)',
            'Recherche dans un moteur de recherche' => 'Search in a search engine (Ex. Google, Bing....)',
            'Organisation locale (Bruxelles Formation, VDAB, Forem, Missions locales, Maison de l\'emploi, CPAS,...)' => 'Local organization (Bruxelles Formation, VDAB, Forem, Missions locales, Maison de l`emploi, CPAS,....)',
            'Bouche à oreille (amis, famille, ancien apprenant Becode )' => 'Word to mouth (friends, family, former learner BeCode)',
            'Employeur' => 'Employer',
            'Autre' => 'Other'
        };
        
        private static Map<String, String> statusMap = new Map<String, String> {
            'Salarié (CDD)' => 'Employee (fixed-term contract)',
            'Salarié (intérim)' => 'Employee (interim)',
            'Salarié (CDI)' => 'Employee (permanent contract)',
            'Freelance / Indépendant' => 'Freelance / Self-employed',
            'Demandeur d\'emploi' => 'Job seeker',
            'Etudiant' => 'Student',
            'Sans statut / Autre' => 'No status / Other'
        };
            
        private static Map<String, String> householdMap = new Map<String, String> {
            'Je vis avec mes parents' => 'I live with my parents',
            'Je vis avec mon conjoint' => 'I live with my partner',
            'Je vis seul ou en colocation' => 'I live alone or in a shared flat'
        };
        
		private static Map<String, String> degreeMap = new Map<String, String> {
            'Ecole primaire' => 'Primary school',
            'Secondaire (infèrieur)' => 'High school (inferior)',
            'Secondaire (technique - professionnel)' => 'High school (technical - professional)',
            'Secondaire (supérieur - général)' => 'High school (superior - general)',
            'Bachelier' => 'Bachelor\'s degree',
            'Master' => 'Master\'s degree',
            'Doctorat' => 'PhD',
            'Pas de diplôme' => 'No degree'
        };
            
        private static Map<String, String> legalStatusMap = new Map<String, String> {
            'Célibataire' => 'Single',
            'Marié' => 'Married',
            'Cohabitant légal' => 'Legal cohabitant',
            'Divorcé/séparé' => 'Divorced/seperated',
			'Veuf/Veuve' => 'Widowed'
        };
            
        private static Map<String, String> grandparentsMap = new Map<String, String> {
            'Je ne sais pas' => 'I don`t know',
            'Oui, les deux' => 'Yes, both',
            'Oui, l\'un d\'eux' => 'Yes, one of them',
            'Non' => 'No'
        };

        private static Map<String, String> parentsMap = new Map<String, String> {
            // Here we add a map entry for the 'Oui' case.
            'Oui' => 'Yes',
            'Non' => 'No'
        };
            
        private static Map<String, String> reasonMap = new Map<String, String> {
            'Pour trouver un nouvel emploi (reconversion professionnelle)' => 'To find a new job (professional retraining)',
            'Pour acquèrir un premier diplôme ou un diplôme supèrieur' => 'To acquire a first qualification or a higher qualification',
            'Pour travailler dans une autre entreprise' => 'To work in another company',
            'Pour trouver un emploi plus facilement et plus rapidement' => 'To find a job more easily and quickly',
            'Pour avoir un meilleur salaire' => 'To have better wages',
            'Pour trouver un métier compatible avec votre handicap' => 'To find an occupation that is compatible with your disability',
            'Pour créer une entreprise ou devenir indépendant' => 'To start up a business or to become self-employed',
            'Pour s\'adapter aux évolutions techniques du métier' => 'To adapt to technical developments of the profession',
            'Autre' => 'Other'
        };
            
        private static Map<String, String> refugeeMap = new Map<String, String> {
            'Non' => 'No',
            'Oui' => 'Yes',
			'Je préfère ne pas répondre' => 'I don`t want to answer'
        };
        
        private static Map<String, String> transportationMap = new Map<String, String> {
            'Tram/Bus' => 'Tram/Bus',
            'Métro' => 'Metro',
            'Voiture' => 'Car',
            'A pied' => 'By foot',
            'Train' => 'Train',
            'Vélo' => 'Bike'
        };
        
        private static Map<String, String> experienceMap = new Map<String, String> {
            'Bachelier (diplômé)' => 'Bachelor`s degree (graduated)',
            'Bachelier (commencé mais pas terminé)' => 'Bachelor`s degree (started but not finished)',
            'Formation courte dans le secteur informatique (terminé)' => 'Short training in the IT sector (finished)',
            'Formation courte dans le secteur informatique (commencé mais pas terminé)' => 'Short training in the IT sector (started, but not finished)',
            'Autre type de formation' => 'Other educational type'
        };
            
        private static Map<String, String> workingAdultsMap = new Map<String, String> {
            'L\'un de nous' => '1',
            'Aucun de nous' => '0',
            'Nous deux' => '2'
        };
            
        private static Map<String, String> genreMap = new Map<String, String> {
            'Femme' => 'Female',
            'Homme' => 'Male',
            'Autre' => 'Neutral'
        };
            
        private static Map<String, String> campusMap = new Map<String, String> {
            'Ghent' => 'Ghent',
            'Genk' => 'Ghent',
            'Brussels' => 'Brussels',
            'Antwerpen' => 'Antwerpen',
            'Liège' => 'Liege',
			'Liege' => 'Liege',
            'Charleroi' => 'Charleroi'
        };
            
        public static String slugify(String username) {
            // Lowercase the username
            username = username.toLowerCase();
    
            // Replace spaces with hyphens
            username = username.replace(' ', '-');
    
            // Remove non-alphanumeric characters
            username = username.replaceAll('[^a-z0-9-]', '');
    
            return username;
        }
        // Method to map Sphinx API data to Salesforce Account object
        // mapResponseToAccount(response, recordId, learnerId, internId, hiringId, classId, trainingId)
        // 
        public static Account mapResponseToAccount(Map<String, Object> response, String recordId, String learnerId, String internId, String hiringId, String classId, String trainingId ) {
			System.debug(classId);
            Account account = new Account();
            account.BECODE_AMBITION_AFTER_BECODE_OTHER__C = (String) response.get('Ambition_after_BeCode_Autre');
            account.BECODE_AMBITION_AFTER_BECODE__C = (String) ambitionMap.get((String) response.get('Ambition_after_BeCode'));
            account.BECODE_BECODE_DISCOVERY__C = (String) discoveryMap.get((String) response.get('BeCode_discovery'));
            account.BECODE_CAMPUS__C = (String) campusMap.get((String) response.get('Campus'));
			account.BECODE_CLASS__C = classId;
            account.BECODE_CONTRACT_PROVIDER__C = (String) response.get('Contract_provider');
            account.BECODE_CURRENT_STATUS__C = (String) statusMap.get((String) response.get('Last_status'));
            account.BECODE_DISCORD_USERNAME__C = (String) response.get('discord');
			account.RecordTypeId = recordId;
            account.BECODE_DROP_OUT__C = response.get('0M_Dropout_reason') != '';
            account.BECODE_DUTCH_LEVEL__C = (String) response.get('Dutch_level');
			account.BECODE_EMERGENCY_CONTACT__C = (String) response.get('Emergency_contact_-_Phone');
          	account.BECODE_ENGLISH_LEVEL__C = (String) response.get('English_level');
            account.BECODE_FRENCH_LEVEL__C = (String) response.get('French_level');
            account.BECODE_GITHUB_ACCOUNT_USERNAME__C = (String) response.get('Github_account_username');
			account.BECODE_HIRED_BY_COMPANY__C = hiringId;
            account.BECODE_HOBBIES__C = (String) response.get('Passion');
            account.BECODE_HOUSEHOLD_COMPOSITION__C = householdMap.get((String) response.get('Household_composition'));
            if (internId != Null) {
                account.BECODE_INTERNSHIP_AT_COMPANY__C = internId;
            	account.BECODE_INTERNSHIP_START_DATE__C  = (response.get('0M_Internship_start_date') != Null) ? date.parse((String) response.get('0M_Internship_start_date')) : Null;
				account.BECODE_INTERNSHIP_END_DATE__C  = (response.get('0M_Internship_start_end') != Null) ? date.parse((String) response.get('0M_Internship_start_end')) : Null;
            }            
            account.BECODE_LAST_DEGREE__C = degreeMap.get((String) response.get('Last_degree'));
            account.BECODE_LEARNER_ID__C = slugify((String) response.get('BeCode_ID'));
            account.BECODE_LINKEDIN__C = (String) response.get('LinkedIn');
            account.BECODE_MARITAL_STATUS__C = statusMap.get((String) response.get('Legal_status'));
            account.BECODE_NATIONAL_REGISTRY_NUMBER__C = (response.get('National_Registry_number') != Null) ? (((String) response.get('National_Registry_number')).length() > 14) ? ((String) response.get('National_Registry_number')).SubString(0,14) : (String) response.get('National_Registry_number') : Null;
            account.BECODE_NATIONALITY__C = (String) response.get('Nationality');
            account.BECODE_BIRTH_COUNTRY__C = countryTranslations.get((String) response.get('Birth_country'));
            account.BECODE_PAR_GRANDPAR_BORN_OUTSIDE_BE__C = grandParentsMap.get((String) response.get('Parent_or_Grandparent_born_outside_EU'));
            account.BECODE_PARENTS_BORN_OUTSIDE_BE__C = parentsMap.get((String) response.get('Parents_born_outside_BE'));
            account.BECODE_PREVIOUS_TRAINING__C = (response.get('What_previous_training') != Null) ? (((String) response.get('What_previous_training')).length() > 255) ? ((String) response.get('What_previous_training')).SubString(0,254) : (String) response.get('What_previous_training') : Null;
            account.BECODE_REASON_FOR_BECODE_OTHER__C = (String) response.get('Reason_for_BeCode_Other');
            account.BECODE_REASON_FOR_BECODE__C = reasonMap.get((String) response.get('Reason_for_BeCode'));
            account.BECODE_REFUGEE__C = (String) refugeeMap.get((String) response.get('Refugee'));
            account.BECODE_T_SHIRT_SIZE__C = (String) response.get('T-Shirt_size');
            if (response.get('How_long_jobseeker') != Null){
                if (((String) response.get('How_long_jobseeker')).isNumeric()) {
                 	account.BECODE_TIME_SPENT_AS_JOB_SEEKER__C = Integer.valueOf((String) response.get('How_long_jobseeker'));
                }
            }
			account.BECODE_TRAINING__C = trainingId;
            account.BECODE_TRANSPORTATION__C = transportationMap.get((String) response.get('Transportation'));
            account.BECODE_WHAT_EXPERIENCE__C = experienceMap.get((String) response.get('What_experience'));
            account.BECODE_WORKING_ADULTS__C = workingAdultsMap.get((String) response.get('working_adults'));
            account.BECODE_YEARS_IN_BE__C = (String) response.get('years_in_BE');
            account.GENDER__PC = genreMap.get((String) response.get('Gender'));
            account.LASTNAME = (String) response.get('Last_name');
            account.FIRSTNAME = (String) response.get('First_name');
			if (!String.isBlank((String) response.get('Date_of_birth'))){
                account.PERSONBIRTHDATE = date.parse((String) response.get('Date_of_birth'));
            }
            account.PERSONEMAIL = (String) response.get('Email');
            account.SHIPPINGCITY = (String) response.get('City_if_Belgium');
            //account.SHIPPINGCOUNTRY = (String) response.get('Country');
			//account.SHIPPINGPOSTALCODE = (response.get('Postal_code_if_Belgium') != Null) ? (((String) response.get('Postal_code_if_Belgium')).length() > 4) ? ((String) response.get('Postal_code_if_Belgium')).SubString(0,4) : (String) response.get('Postal_code_if_Belgium') : Null;

            account.SHIPPINGSTREET = (String) response.get('Street_and_number');
            account.PHONE = (String) response.get('Phone');
            
            return account;
        }
}