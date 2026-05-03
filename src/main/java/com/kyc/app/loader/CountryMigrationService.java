package com.kyc.app.loader;

import com.kyc.app.model.Address;
import com.kyc.app.model.LegalEntity;
import com.kyc.app.model.NaturalPerson;
import com.kyc.app.repository.LegalEntityRepository;
import com.kyc.app.repository.NaturalPersonRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Migrates legacy country values (full names, French names) to ISO 3166-1 alpha-2 codes.
 * Runs after DataLoader (@Order(2)). Skips values that are already valid 2-letter codes.
 * Also ensures schema columns added in recent entity changes exist (guards against ddl-auto lag).
 */
@Component
@Order(2)
public class CountryMigrationService implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(CountryMigrationService.class);

    private static final Map<String, String> NAME_TO_CODE = new HashMap<>();

    static {
        // English names (from legacy countryDropdown.js)
        NAME_TO_CODE.put("afghanistan", "AF");
        NAME_TO_CODE.put("albania", "AL");
        NAME_TO_CODE.put("algeria", "DZ");
        NAME_TO_CODE.put("andorra", "AD");
        NAME_TO_CODE.put("angola", "AO");
        NAME_TO_CODE.put("antigua and barbuda", "AG");
        NAME_TO_CODE.put("argentina", "AR");
        NAME_TO_CODE.put("armenia", "AM");
        NAME_TO_CODE.put("australia", "AU");
        NAME_TO_CODE.put("austria", "AT");
        NAME_TO_CODE.put("azerbaijan", "AZ");
        NAME_TO_CODE.put("bahamas", "BS");
        NAME_TO_CODE.put("bahrain", "BH");
        NAME_TO_CODE.put("bangladesh", "BD");
        NAME_TO_CODE.put("barbados", "BB");
        NAME_TO_CODE.put("belarus", "BY");
        NAME_TO_CODE.put("belgium", "BE");
        NAME_TO_CODE.put("belize", "BZ");
        NAME_TO_CODE.put("benin", "BJ");
        NAME_TO_CODE.put("bhutan", "BT");
        NAME_TO_CODE.put("bolivia", "BO");
        NAME_TO_CODE.put("bosnia", "BA");
        NAME_TO_CODE.put("bosnia and herzegovina", "BA");
        NAME_TO_CODE.put("botswana", "BW");
        NAME_TO_CODE.put("brazil", "BR");
        NAME_TO_CODE.put("brunei", "BN");
        NAME_TO_CODE.put("bulgaria", "BG");
        NAME_TO_CODE.put("burkina faso", "BF");
        NAME_TO_CODE.put("burundi", "BI");
        NAME_TO_CODE.put("cape verde", "CV");
        NAME_TO_CODE.put("cambodia", "KH");
        NAME_TO_CODE.put("cameroon", "CM");
        NAME_TO_CODE.put("canada", "CA");
        NAME_TO_CODE.put("central african republic", "CF");
        NAME_TO_CODE.put("chad", "TD");
        NAME_TO_CODE.put("chile", "CL");
        NAME_TO_CODE.put("china", "CN");
        NAME_TO_CODE.put("colombia", "CO");
        NAME_TO_CODE.put("comoros", "KM");
        NAME_TO_CODE.put("congo", "CG");
        NAME_TO_CODE.put("congo (democratic republic)", "CD");
        NAME_TO_CODE.put("costa rica", "CR");
        NAME_TO_CODE.put("croatia", "HR");
        NAME_TO_CODE.put("cuba", "CU");
        NAME_TO_CODE.put("cyprus", "CY");
        NAME_TO_CODE.put("czech republic", "CZ");
        NAME_TO_CODE.put("denmark", "DK");
        NAME_TO_CODE.put("djibouti", "DJ");
        NAME_TO_CODE.put("dominica", "DM");
        NAME_TO_CODE.put("dominican republic", "DO");
        NAME_TO_CODE.put("ecuador", "EC");
        NAME_TO_CODE.put("egypt", "EG");
        NAME_TO_CODE.put("el salvador", "SV");
        NAME_TO_CODE.put("equatorial guinea", "GQ");
        NAME_TO_CODE.put("eritrea", "ER");
        NAME_TO_CODE.put("estonia", "EE");
        NAME_TO_CODE.put("eswatini", "SZ");
        NAME_TO_CODE.put("ethiopia", "ET");
        NAME_TO_CODE.put("fiji", "FJ");
        NAME_TO_CODE.put("finland", "FI");
        NAME_TO_CODE.put("france", "FR");
        NAME_TO_CODE.put("gabon", "GA");
        NAME_TO_CODE.put("gambia", "GM");
        NAME_TO_CODE.put("georgia", "GE");
        NAME_TO_CODE.put("germany", "DE");
        NAME_TO_CODE.put("ghana", "GH");
        NAME_TO_CODE.put("greece", "GR");
        NAME_TO_CODE.put("grenada", "GD");
        NAME_TO_CODE.put("guatemala", "GT");
        NAME_TO_CODE.put("guinea", "GN");
        NAME_TO_CODE.put("guinea-bissau", "GW");
        NAME_TO_CODE.put("guyana", "GY");
        NAME_TO_CODE.put("haiti", "HT");
        NAME_TO_CODE.put("honduras", "HN");
        NAME_TO_CODE.put("hungary", "HU");
        NAME_TO_CODE.put("iceland", "IS");
        NAME_TO_CODE.put("india", "IN");
        NAME_TO_CODE.put("indonesia", "ID");
        NAME_TO_CODE.put("iran", "IR");
        NAME_TO_CODE.put("iraq", "IQ");
        NAME_TO_CODE.put("ireland", "IE");
        NAME_TO_CODE.put("israel", "IL");
        NAME_TO_CODE.put("italy", "IT");
        NAME_TO_CODE.put("jamaica", "JM");
        NAME_TO_CODE.put("japan", "JP");
        NAME_TO_CODE.put("jordan", "JO");
        NAME_TO_CODE.put("kazakhstan", "KZ");
        NAME_TO_CODE.put("kenya", "KE");
        NAME_TO_CODE.put("kiribati", "KI");
        NAME_TO_CODE.put("korea (north)", "KP");
        NAME_TO_CODE.put("korea (south)", "KR");
        NAME_TO_CODE.put("south korea", "KR");
        NAME_TO_CODE.put("kuwait", "KW");
        NAME_TO_CODE.put("kyrgyzstan", "KG");
        NAME_TO_CODE.put("laos", "LA");
        NAME_TO_CODE.put("latvia", "LV");
        NAME_TO_CODE.put("lebanon", "LB");
        NAME_TO_CODE.put("lesotho", "LS");
        NAME_TO_CODE.put("liberia", "LR");
        NAME_TO_CODE.put("libya", "LY");
        NAME_TO_CODE.put("liechtenstein", "LI");
        NAME_TO_CODE.put("lithuania", "LT");
        NAME_TO_CODE.put("luxembourg", "LU");
        NAME_TO_CODE.put("madagascar", "MG");
        NAME_TO_CODE.put("malawi", "MW");
        NAME_TO_CODE.put("malaysia", "MY");
        NAME_TO_CODE.put("maldives", "MV");
        NAME_TO_CODE.put("mali", "ML");
        NAME_TO_CODE.put("malta", "MT");
        NAME_TO_CODE.put("marshall islands", "MH");
        NAME_TO_CODE.put("mauritania", "MR");
        NAME_TO_CODE.put("mauritius", "MU");
        NAME_TO_CODE.put("mexico", "MX");
        NAME_TO_CODE.put("micronesia", "FM");
        NAME_TO_CODE.put("moldova", "MD");
        NAME_TO_CODE.put("monaco", "MC");
        NAME_TO_CODE.put("mongolia", "MN");
        NAME_TO_CODE.put("montenegro", "ME");
        NAME_TO_CODE.put("morocco", "MA");
        NAME_TO_CODE.put("mozambique", "MZ");
        NAME_TO_CODE.put("myanmar", "MM");
        NAME_TO_CODE.put("namibia", "NA");
        NAME_TO_CODE.put("nauru", "NR");
        NAME_TO_CODE.put("nepal", "NP");
        NAME_TO_CODE.put("netherlands", "NL");
        NAME_TO_CODE.put("new zealand", "NZ");
        NAME_TO_CODE.put("nicaragua", "NI");
        NAME_TO_CODE.put("niger", "NE");
        NAME_TO_CODE.put("nigeria", "NG");
        NAME_TO_CODE.put("north macedonia", "MK");
        NAME_TO_CODE.put("norway", "NO");
        NAME_TO_CODE.put("oman", "OM");
        NAME_TO_CODE.put("pakistan", "PK");
        NAME_TO_CODE.put("palau", "PW");
        NAME_TO_CODE.put("panama", "PA");
        NAME_TO_CODE.put("papua new guinea", "PG");
        NAME_TO_CODE.put("paraguay", "PY");
        NAME_TO_CODE.put("peru", "PE");
        NAME_TO_CODE.put("philippines", "PH");
        NAME_TO_CODE.put("poland", "PL");
        NAME_TO_CODE.put("portugal", "PT");
        NAME_TO_CODE.put("qatar", "QA");
        NAME_TO_CODE.put("romania", "RO");
        NAME_TO_CODE.put("russia", "RU");
        NAME_TO_CODE.put("rwanda", "RW");
        NAME_TO_CODE.put("saint kitts and nevis", "KN");
        NAME_TO_CODE.put("saint lucia", "LC");
        NAME_TO_CODE.put("saint vincent and the grenadines", "VC");
        NAME_TO_CODE.put("samoa", "WS");
        NAME_TO_CODE.put("san marino", "SM");
        NAME_TO_CODE.put("sao tome and principe", "ST");
        NAME_TO_CODE.put("saudi arabia", "SA");
        NAME_TO_CODE.put("senegal", "SN");
        NAME_TO_CODE.put("serbia", "RS");
        NAME_TO_CODE.put("seychelles", "SC");
        NAME_TO_CODE.put("sierra leone", "SL");
        NAME_TO_CODE.put("singapore", "SG");
        NAME_TO_CODE.put("slovakia", "SK");
        NAME_TO_CODE.put("slovenia", "SI");
        NAME_TO_CODE.put("solomon islands", "SB");
        NAME_TO_CODE.put("somalia", "SO");
        NAME_TO_CODE.put("south africa", "ZA");
        NAME_TO_CODE.put("south sudan", "SS");
        NAME_TO_CODE.put("spain", "ES");
        NAME_TO_CODE.put("sri lanka", "LK");
        NAME_TO_CODE.put("sudan", "SD");
        NAME_TO_CODE.put("suriname", "SR");
        NAME_TO_CODE.put("sweden", "SE");
        NAME_TO_CODE.put("switzerland", "CH");
        NAME_TO_CODE.put("syria", "SY");
        NAME_TO_CODE.put("taiwan", "TW");
        NAME_TO_CODE.put("tajikistan", "TJ");
        NAME_TO_CODE.put("tanzania", "TZ");
        NAME_TO_CODE.put("thailand", "TH");
        NAME_TO_CODE.put("timor-leste", "TL");
        NAME_TO_CODE.put("togo", "TG");
        NAME_TO_CODE.put("tonga", "TO");
        NAME_TO_CODE.put("trinidad and tobago", "TT");
        NAME_TO_CODE.put("tunisia", "TN");
        NAME_TO_CODE.put("turkey", "TR");
        NAME_TO_CODE.put("turkmenistan", "TM");
        NAME_TO_CODE.put("tuvalu", "TV");
        NAME_TO_CODE.put("uganda", "UG");
        NAME_TO_CODE.put("ukraine", "UA");
        NAME_TO_CODE.put("united arab emirates", "AE");
        NAME_TO_CODE.put("united kingdom", "GB");
        NAME_TO_CODE.put("united states", "US");
        NAME_TO_CODE.put("usa", "US");
        NAME_TO_CODE.put("uruguay", "UY");
        NAME_TO_CODE.put("uzbekistan", "UZ");
        NAME_TO_CODE.put("vanuatu", "VU");
        NAME_TO_CODE.put("vatican city", "VA");
        NAME_TO_CODE.put("venezuela", "VE");
        NAME_TO_CODE.put("vietnam", "VN");
        NAME_TO_CODE.put("yemen", "YE");
        NAME_TO_CODE.put("zambia", "ZM");
        NAME_TO_CODE.put("zimbabwe", "ZW");

        // French names and nationality adjectives from legacy seed data
        NAME_TO_CODE.put("française", "FR");
        NAME_TO_CODE.put("francaise", "FR");
        NAME_TO_CODE.put("français", "FR");
        NAME_TO_CODE.put("francais", "FR");
        NAME_TO_CODE.put("allemand", "DE");
        NAME_TO_CODE.put("allemande", "DE");
        NAME_TO_CODE.put("allemagne", "DE");
        NAME_TO_CODE.put("espagnol", "ES");
        NAME_TO_CODE.put("espagnole", "ES");
        NAME_TO_CODE.put("espagne", "ES");
        NAME_TO_CODE.put("italien", "IT");
        NAME_TO_CODE.put("italienne", "IT");
        NAME_TO_CODE.put("italie", "IT");
        NAME_TO_CODE.put("belge", "BE");
        NAME_TO_CODE.put("belgique", "BE");
        NAME_TO_CODE.put("suisse", "CH");
        NAME_TO_CODE.put("luxembourgeois", "LU");
        NAME_TO_CODE.put("luxembourgeoise", "LU");
        NAME_TO_CODE.put("luxembourg", "LU");
        NAME_TO_CODE.put("britannique", "GB");
        NAME_TO_CODE.put("royaume-uni", "GB");
        NAME_TO_CODE.put("américain", "US");
        NAME_TO_CODE.put("americain", "US");
        NAME_TO_CODE.put("américaine", "US");
        NAME_TO_CODE.put("americaine", "US");
        NAME_TO_CODE.put("états-unis", "US");
        NAME_TO_CODE.put("etats-unis", "US");
        NAME_TO_CODE.put("maroc", "MA");
        NAME_TO_CODE.put("marocain", "MA");
        NAME_TO_CODE.put("marocaine", "MA");
        NAME_TO_CODE.put("tunisie", "TN");
        NAME_TO_CODE.put("tunisien", "TN");
        NAME_TO_CODE.put("tunisienne", "TN");
        NAME_TO_CODE.put("algérie", "DZ");
        NAME_TO_CODE.put("algerie", "DZ");
        NAME_TO_CODE.put("algérien", "DZ");
        NAME_TO_CODE.put("algerien", "DZ");
        NAME_TO_CODE.put("sénégal", "SN");
        NAME_TO_CODE.put("senegal", "SN");
        NAME_TO_CODE.put("côte d'ivoire", "CI");
        NAME_TO_CODE.put("cote d'ivoire", "CI");
        NAME_TO_CODE.put("cameroun", "CM");
        NAME_TO_CODE.put("chine", "CN");
        NAME_TO_CODE.put("chinois", "CN");
        NAME_TO_CODE.put("chinoise", "CN");
        NAME_TO_CODE.put("japon", "JP");
        NAME_TO_CODE.put("japonais", "JP");
        NAME_TO_CODE.put("japonaise", "JP");
        NAME_TO_CODE.put("brésil", "BR");
        NAME_TO_CODE.put("bresil", "BR");
        NAME_TO_CODE.put("brésilien", "BR");
        NAME_TO_CODE.put("bresilien", "BR");
        NAME_TO_CODE.put("polonais", "PL");
        NAME_TO_CODE.put("polonaise", "PL");
        NAME_TO_CODE.put("pologne", "PL");
        NAME_TO_CODE.put("portugal", "PT");
        NAME_TO_CODE.put("portugais", "PT");
        NAME_TO_CODE.put("portugaise", "PT");
        NAME_TO_CODE.put("grec", "GR");
        NAME_TO_CODE.put("grèce", "GR");
        NAME_TO_CODE.put("grece", "GR");
        NAME_TO_CODE.put("roumain", "RO");
        NAME_TO_CODE.put("roumaine", "RO");
        NAME_TO_CODE.put("roumanie", "RO");
        NAME_TO_CODE.put("russie", "RU");
        NAME_TO_CODE.put("russe", "RU");
        NAME_TO_CODE.put("ukrainien", "UA");
        NAME_TO_CODE.put("ukrainienne", "UA");
        NAME_TO_CODE.put("ukraine", "UA");
        NAME_TO_CODE.put("canadien", "CA");
        NAME_TO_CODE.put("canadienne", "CA");
        NAME_TO_CODE.put("canada", "CA");
        NAME_TO_CODE.put("mexicain", "MX");
        NAME_TO_CODE.put("mexicaine", "MX");
        NAME_TO_CODE.put("mexique", "MX");
        NAME_TO_CODE.put("inde", "IN");
        NAME_TO_CODE.put("indien", "IN");
        NAME_TO_CODE.put("indienne", "IN");
        NAME_TO_CODE.put("australien", "AU");
        NAME_TO_CODE.put("australienne", "AU");
        NAME_TO_CODE.put("australie", "AU");
        NAME_TO_CODE.put("pays-bas", "NL");
        NAME_TO_CODE.put("néerlandais", "NL");
        NAME_TO_CODE.put("neerlandais", "NL");
    }

    private final NaturalPersonRepository naturalPersonRepository;
    private final LegalEntityRepository legalEntityRepository;
    private final JdbcTemplate jdbcTemplate;

    public CountryMigrationService(NaturalPersonRepository naturalPersonRepository,
                                   LegalEntityRepository legalEntityRepository,
                                   JdbcTemplate jdbcTemplate) {
        this.naturalPersonRepository = naturalPersonRepository;
        this.legalEntityRepository = legalEntityRepository;
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void run(String... args) {
        ensureSchema();
        try {
            int naturalPersonCount = migrateNaturalPersons();
            int legalEntityCount = migrateLegalEntities();
            if (naturalPersonCount + legalEntityCount > 0) {
                logger.info("Country migration: {} natural person fields and {} legal entity fields updated to ISO codes.",
                        naturalPersonCount, legalEntityCount);
            }
        } catch (Exception e) {
            logger.warn("Country migration skipped: {}. Will retry on next startup.", e.getMessage());
        }
    }

    /**
     * Adds any columns that ddl-auto=update may have missed due to schema drift.
     */
    private void ensureSchema() {
        addColumnIfMissing("legal_entities", "jurisdiction", "VARCHAR(255)");
    }

    private void addColumnIfMissing(String table, String column, String type) {
        List<String> existing = jdbcTemplate.queryForList(
                "SELECT column_name FROM information_schema.columns WHERE table_name = ? AND column_name = ?",
                String.class, table, column);
        if (existing.isEmpty()) {
            jdbcTemplate.execute("ALTER TABLE " + table + " ADD COLUMN " + column + " " + type);
            logger.info("Schema repair: added column {}.{}", table, column);
        }
    }

    private int migrateNaturalPersons() {
        int count = 0;
        for (NaturalPerson person : naturalPersonRepository.findAll()) {
            boolean dirty = false;

            String migratedNationality = migrate(person.getNationality());
            if (migratedNationality != null) {
                person.setNationality(migratedNationality);
                dirty = true;
                count++;
            }

            String migratedCountryOfBirth = migrate(person.getCountryOfBirth());
            if (migratedCountryOfBirth != null) {
                person.setCountryOfBirth(migratedCountryOfBirth);
                dirty = true;
                count++;
            }

            if (person.getAddress() != null) {
                String migratedAddressCountry = migrate(person.getAddress().getCountry());
                if (migratedAddressCountry != null) {
                    person.getAddress().setCountry(migratedAddressCountry);
                    dirty = true;
                    count++;
                }
            }

            if (dirty) {
                naturalPersonRepository.save(person);
            }
        }
        return count;
    }

    private int migrateLegalEntities() {
        int count = 0;
        for (LegalEntity entity : legalEntityRepository.findAll()) {
            boolean dirty = false;

            String migratedJurisdiction = migrate(entity.getJurisdiction());
            if (migratedJurisdiction != null) {
                entity.setJurisdiction(migratedJurisdiction);
                dirty = true;
                count++;
            }

            String migratedCountry = migrate(entity.getCountry());
            if (migratedCountry != null) {
                entity.setCountry(migratedCountry);
                dirty = true;
                count++;
            }

            if (entity.getAddress() != null) {
                String migratedAddressCountry = migrate(entity.getAddress().getCountry());
                if (migratedAddressCountry != null) {
                    entity.getAddress().setCountry(migratedAddressCountry);
                    dirty = true;
                    count++;
                }
            }

            if (dirty) {
                legalEntityRepository.save(entity);
            }
        }
        return count;
    }

    /**
     * Returns the ISO code if the value needs migration, null if it should be left unchanged.
     * A value is skipped if it is null, blank, or already a 2-letter uppercase code.
     */
    private String migrate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        if (value.length() == 2 && value.equals(value.toUpperCase())) {
            return null; // Already an ISO code
        }
        return NAME_TO_CODE.get(value.toLowerCase().trim());
    }
}
