package isme.testporjey.ControllersTest;

import isme.testporjey.Controllers.UserController;
import isme.testporjey.JWT.JwtService;
import isme.testporjey.JWT.UserDetailsServiceImpl;
import isme.testporjey.Models.Role;
import isme.testporjey.Models.User;
import isme.testporjey.Repositories.UserRepository;
import isme.testporjey.Services.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;
import java.util.Optional;

import static org.hamcrest.Matchers.is;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(UserController.class)
public class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserService userService;

    @MockBean
    private UserRepository userRepository;

    @MockBean
    private JwtService jwtService;

    @MockBean
    private UserDetailsServiceImpl userDetailsService;

    // Test for getUserWithMostLoans()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetUserWithMostLoans() throws Exception {
        User user = new User();
        user.setId(1L);
        user.setUsername("john");
        user.setEmail("john@example.com");
        user.setPassword("password123");
        user.setRole(Role.ADMIN);

        Mockito.when(userRepository.findUserWithMostLoans()).thenReturn(user);

        mockMvc.perform(get("/api/users/most-loans")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username", is("john")));
    }

    // Test for getAllUsers()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetAllUsers() throws Exception {
        User user1 = new User();
        user1.setId(1L);
        user1.setUsername("john");
        user1.setEmail("john@example.com");
        user1.setPassword("password123");
        user1.setRole(Role.ADMIN);

        User user2 = new User();
        user2.setId(2L);
        user2.setUsername("jane");
        user2.setEmail("jane@example.com");
        user2.setPassword("password123");
        user2.setRole(Role.USER);

        Mockito.when(userService.getAllUsers()).thenReturn(Arrays.asList(user1, user2));

        mockMvc.perform(get("/api/users")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].username", is("john")))
                .andExpect(jsonPath("$[1].username", is("jane")));
    }

    // Test for getUserById()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetUserById() throws Exception {
        User user = new User();
        user.setId(1L);
        user.setUsername("john");
        user.setEmail("john@example.com");
        user.setPassword("password123");
        user.setRole(Role.ADMIN);

        Mockito.when(userService.getUserById(1L)).thenReturn(Optional.of(user));

        mockMvc.perform(get("/api/users/1")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username", is("john")));
    }

    // Test for saveUser()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testSaveUser() throws Exception {
        User user = new User();
        user.setId(1L);
        user.setUsername("john");
        user.setEmail("john@example.com");
        user.setPassword("password123");
        user.setRole(Role.ADMIN);

        Mockito.when(userService.saveUser(Mockito.any(User.class))).thenReturn(user);

        mockMvc.perform(post("/api/users")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\": \"john\", \"email\": \"john@example.com\", \"password\": \"password123\", \"role\": \"ADMIN\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username", is("john")));
    }

    // Test for deleteUser()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testDeleteUser() throws Exception {
        mockMvc.perform(delete("/api/users/1")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());

        Mockito.verify(userService, Mockito.times(1)).deleteUser(1L);
    }

    // Test for getUserRole()
    @Test
    @WithMockUser(username = "john", roles = "ADMIN")
    public void testGetUserRole() throws Exception {
        mockMvc.perform(get("/api/users/role")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().string("ROLE_ADMIN"));
    }
}
