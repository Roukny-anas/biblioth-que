package isme.testporjey.Controllers;

import isme.testporjey.JWT.JwtService;
import isme.testporjey.Models.AuthRequest;
import isme.testporjey.Models.Role;
import isme.testporjey.Models.User;
import isme.testporjey.Repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    private final JwtService jwtService;

    public AuthController(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }
    @PostMapping("/signup")
    public ResponseEntity<String> signUp(@RequestBody User user) {
        if (user.getEmail().endsWith("@admin.ma")) {
            user.setRole(Role.ADMIN);
        } else {
            user.setRole(Role.USER);
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userRepository.save(user);


        return ResponseEntity.ok("{\"message\": \"User registered successfully\"}");
    }

    @PostMapping("/signin")
    public ResponseEntity<Map<String, String>> signIn(@RequestBody AuthRequest authRequest) {
        System.out.println("Signin request received for email: " + authRequest.getEmail());
        System.out.println("Password: " + authRequest.getPassword());

        User user = userRepository.findByEmail(authRequest.getEmail())
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        if (!passwordEncoder.matches(authRequest.getPassword(), user.getPassword())) {
            System.out.println("Invalid password for user: " + authRequest.getEmail());
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", "Invalid password");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
        }

        String token = jwtService.generateToken(
                new org.springframework.security.core.userdetails.User(
                        user.getEmail(),
                        user.getPassword(),
                        user.getRole().equals(Role.ADMIN) ?
                                List.of(new SimpleGrantedAuthority("ROLE_ADMIN")) :
                                List.of(new SimpleGrantedAuthority("ROLE_USER"))
                )
        );

        System.out.println("Token generated: " + token);

        // Return token as JSON
        Map<String, String> response = new HashMap<>();
        response.put("token", token);
        response.put("userId", String.valueOf(user.getId()));
        return ResponseEntity.ok(response);
    }
}
