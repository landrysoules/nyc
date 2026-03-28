package com.kyc.app.controller;

import com.kyc.app.model.AppUser;
import com.kyc.app.repository.AppUserRepository;
import com.kyc.app.security.CustomUserDetails;
import dev.samstevens.totp.code.CodeVerifier;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Optional;

@Controller
@RequestMapping("/auth")
public class AuthController {

    private final AppUserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final CodeVerifier codeVerifier;
    private final SecurityContextRepository securityContextRepository;

    public AuthController(AppUserRepository userRepository, PasswordEncoder passwordEncoder, 
                          CodeVerifier codeVerifier, SecurityContextRepository securityContextRepository) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.codeVerifier = codeVerifier;
        this.securityContextRepository = securityContextRepository;
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam String username, @RequestParam String password,
                               HttpSession session, Model model) {
                               
        Optional<AppUser> userOpt = userRepository.findByUsername(username);
        
        if (userOpt.isPresent() && passwordEncoder.matches(password, userOpt.get().getPassword())) {
            // Credentials are valid, store user temporarily in session for OTP step
            session.setAttribute("PRE_AUTH_USER", username);
            model.addAttribute("username", username);
            return "fragments/otp"; // Return the OTP input fragment
        } else {
            model.addAttribute("error", "Identifiants invalides");
            return "fragments/login-form"; // Assuming we extract login form to a fragment or handle error
        }
    }

    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam String otpCode, HttpServletRequest request, HttpServletResponse response, Model model) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("PRE_AUTH_USER") == null) {
            model.addAttribute("error", "Session expirée");
            return "fragments/login-form";
        }

        String username = (String) session.getAttribute("PRE_AUTH_USER");
        AppUser user = userRepository.findByUsername(username).orElse(null);

        if (user != null) {
            if (codeVerifier.isValidCode(user.getTotpSecret(), otpCode)) {
                // OTP valid! Authenticate user in Spring Security
                CustomUserDetails userDetails = new CustomUserDetails(user);
                UsernamePasswordAuthenticationToken authentication = 
                        new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                
                SecurityContext context = SecurityContextHolder.createEmptyContext();
                context.setAuthentication(authentication);
                SecurityContextHolder.setContext(context);
                securityContextRepository.saveContext(context, request, response);
                
                // Clear pre-auth
                session.removeAttribute("PRE_AUTH_USER");
                
                // Return empty response with HTMX redirect header
                response.setHeader("HX-Redirect", "/dashboard");
                return null;
            } else {
                model.addAttribute("error", "Code OTP invalide");
                return "fragments/otp";
            }
        }
        
        model.addAttribute("error", "Utilisateur non trouvé");
        return "fragments/login-form";
    }
}
