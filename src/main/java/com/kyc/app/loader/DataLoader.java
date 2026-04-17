package com.kyc.app.loader;

import com.kyc.app.model.Address;
import com.kyc.app.model.AppUser;
import com.kyc.app.model.Contract;
import com.kyc.app.model.LegalEntity;
import com.kyc.app.model.NaturalPerson;
import com.kyc.app.repository.AppUserRepository;
import com.kyc.app.repository.ContractRepository;
import com.kyc.app.repository.LegalEntityRepository;
import com.kyc.app.repository.NaturalPersonRepository;
import dev.samstevens.totp.secret.DefaultSecretGenerator;
import dev.samstevens.totp.secret.SecretGenerator;
import dev.samstevens.totp.qr.QrData;
import dev.samstevens.totp.qr.QrGenerator;
import dev.samstevens.totp.qr.ZxingPngQrGenerator;
import dev.samstevens.totp.exceptions.QrGenerationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import java.time.LocalDate;
import java.util.Base64;
import java.util.List;

@Component
public class DataLoader implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DataLoader.class);

    private final AppUserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final NaturalPersonRepository naturalPersonRepository;
    private final LegalEntityRepository legalEntityRepository;
    private final ContractRepository contractRepository;

    public DataLoader(AppUserRepository userRepository, PasswordEncoder passwordEncoder,
                      NaturalPersonRepository naturalPersonRepository,
                      LegalEntityRepository legalEntityRepository,
                      ContractRepository contractRepository) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.naturalPersonRepository = naturalPersonRepository;
        this.legalEntityRepository = legalEntityRepository;
        this.contractRepository = contractRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        if (userRepository.findByUsername("admin").isEmpty()) {
            AppUser user = new AppUser();
            user.setUsername("admin");
            user.setPassword(passwordEncoder.encode("password"));
            
            SecretGenerator secretGenerator = new DefaultSecretGenerator();
            String secret = secretGenerator.generate();
            user.setTotpSecret(secret);
            
            userRepository.save(user);

            QrData data = new QrData.Builder()
                    .label("Admin KYC")
                    .secret(secret)
                    .issuer("KYC Backoffice")
                    .build();

            QrGenerator generator = new ZxingPngQrGenerator();
            byte[] imageData = generator.generate(data);
            String mimeType = generator.getImageMimeType();
            String dataUri = "data:" + mimeType + ";base64," + Base64.getEncoder().encodeToString(imageData);

            logger.info("=========================================================");
            logger.info("Test user created: admin / password");
            logger.info("TOTP Secret: {}", secret);
            logger.info("To add to Google Authenticator, use the following URL in browser to see the QR code:");
            logger.info("QR Code URL: \n{}", dataUri);
            logger.info("=========================================================");
        }

        if (naturalPersonRepository.count() == 0) {
            Address address1 = new Address("12", "Rue de la Paix", "A", "Appt 4", "75002", "Paris", "France");
            Address address2 = new Address("45", "Avenue des Champs", null, null, "75008", "Paris", "France");
            
            naturalPersonRepository.saveAll(List.of(
                new NaturalPerson("Jean", "Dupont", "Française", LocalDate.of(1980, 5, 12), address1),
                new NaturalPerson("Marie", "Martin", "Française", LocalDate.of(1992, 11, 23), address2)
            ));
        }

        if (legalEntityRepository.count() == 0) {
            Address addressOrg1 = new Address("1", "Boulevard Haussmann", "Tour A", "Etage 10", "75009", "Paris", "France");
            Address addressOrg2 = new Address("15", "Rue de Londres", null, null, "75009", "Paris", "France");
            
            legalEntityRepository.saveAll(List.of(
                new LegalEntity("France", "Tech Corp SAS", "France", "123456789", addressOrg1),
                new LegalEntity("Italie", "Finance Innovate SA", "France", "987654321", addressOrg2)
            ));
        }

        if (contractRepository.count() == 0) {
            contractRepository.saveAll(List.of(
                new Contract("Contrat d'ouverture de compte #1029", "ACTIVE"),
                new Contract("Pret Immobilier #901", "DRAFT")
            ));
        }
    }
}
