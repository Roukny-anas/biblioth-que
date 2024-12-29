package isme.testporjey.ControllersTest;

import isme.testporjey.Controllers.LoanController;
import isme.testporjey.JWT.JwtService;
import isme.testporjey.JWT.UserDetailsServiceImpl;
import isme.testporjey.Models.*;
import isme.testporjey.Repositories.BookRepository;
import isme.testporjey.Services.BookService;
import isme.testporjey.Services.LoanService;
import isme.testporjey.Services.UserService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.hamcrest.Matchers.is;
import static org.mockito.ArgumentMatchers.any;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

@WebMvcTest(LoanController.class)
@AutoConfigureMockMvc
public class LoanControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private LoanService loanService;

    @MockBean
    private BookRepository bookRepository;
    @MockBean
    private JwtService jwtService;

    @MockBean
    private UserDetailsServiceImpl userDetailsService;
    // Test pour getAllLoans()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetAllLoans() throws Exception {
        LoanId loanId1 = new LoanId(1L, 1L);
        LoanId loanId2 = new LoanId(2L, 2L);

        Loan loan1 = new Loan();
        loan1.setId(loanId1);
        loan1.setLoanDate(LocalDate.now());
        loan1.setReturnDate(LocalDate.now().plusDays(7));

        Loan loan2 = new Loan();
        loan2.setId(loanId2);
        loan2.setLoanDate(LocalDate.now());
        loan2.setReturnDate(LocalDate.now().plusDays(7));

        List<Loan> loans = Arrays.asList(loan1, loan2);

        Mockito.when(loanService.getAllLoans()).thenReturn(loans);

        mockMvc.perform(get("/api/loans")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id.bookId", is(1)))
                .andExpect(jsonPath("$[1].id.bookId", is(2)));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetLoanById() throws Exception {
        LoanId loanId = new LoanId(1L, 1L);

        Loan loan = new Loan();
        loan.setId(loanId);
        loan.setLoanDate(LocalDate.now());
        loan.setReturnDate(LocalDate.now().plusDays(7));

        Mockito.when(loanService.getLoanById(loanId)).thenReturn(Optional.of(loan));

        mockMvc.perform(get("/api/loans/LoanId(userId=1, bookId=1)")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id.bookId", is(1)))
                .andExpect(jsonPath("$.id.userId", is(1)))
                .andExpect(jsonPath("$.loanDate", is(LocalDate.now().toString())));
    }


    // Test pour checkIfBookAlreadyBorrowed()
    @Test
    @WithMockUser(roles = "USER")
    public void testCheckIfBookAlreadyBorrowed() throws Exception {
        Long userId = 1L;
        Long bookId = 1L;

        Mockito.when(loanService.checkIfBookAlreadyBorrowed(userId, bookId)).thenReturn(true);

        mockMvc.perform(get("/api/loans/check/{userId}/{bookId}", userId, bookId)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", is(true)));
    }

    // Test pour createLoan()
//    @Test
//    @WithMockUser(roles = "USER")
//    public void testCreateLoan() throws Exception {
//        // Création des objets nécessaires
//        Book book = new Book();
//        book.setId(1L);
//
//        User user = new User();
//        user.setId(1L);
//
//        Loan loan = new Loan();
//        loan.setBook(book);
//        loan.setUser(user);
//        loan.setLoanDate(LocalDate.parse("2024-12-23"));
//        loan.setReturnDate(LocalDate.parse("2024-12-30"));
//
//        // Configuration du mock pour le service
//        Mockito.when(loanService.saveLoan(any(Loan.class))).thenReturn(loan);
//
//        // Création de la requête pour tester l'endpoint
//        mockMvc.perform(post("/api/loans/create")
//                        .with(csrf())  // Ajout du token CSRF pour les requêtes sécurisées
//                        .contentType(MediaType.APPLICATION_JSON)
//                        .content("{\n" +
//                                "  \"id\": {\n" +
//                                "    \"bookId\": 1,\n" +
//                                "    \"userId\": 1\n" +
//                                "  },\n" +
//                                "  \"loanDate\": \"2024-12-23\",\n" +
//                                "  \"returnDate\": \"2024-12-30\",\n" +
//                                "  \"book\": {\n" +
//                                "    \"id\": 1\n" +
//                                "  },\n" +
//                                "  \"user\": {\n" +
//                                "    \"id\": 1\n" +
//                                "  }\n" +
//                                "}"))
//                .andExpect(status().isCreated())  // Vérifie que le code de statut est 201
//                .andExpect(jsonPath("$.loanDate").value("2024-12-23"))  // Vérifie la date du prêt
//                .andExpect(jsonPath("$.returnDate").value("2024-12-30"))  // Vérifie la date de retour
//                .andExpect(jsonPath("$.book.id").value(1))  // Vérifie que l'ID du livre est 1
//                .andExpect(jsonPath("$.user.id").value(1));  // Vérifie que l'ID de l'utilisateur est 1
//    }



    // Test pour deleteLoan()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testDeleteLoan() throws Exception {
        LoanId loanId = new LoanId(1L, 1L);

        mockMvc.perform(delete("/api/loans/{id}", loanId)
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());

        Mockito.verify(loanService, Mockito.times(1)).deleteLoan(loanId);
    }

    // Test pour getLoansByUserId()
    @Test
    @WithMockUser(roles = "USER")
    public void testGetLoansByUserId() throws Exception {
        LoanId loanId = new LoanId(1L, 1L);

        Loan loan = new Loan();
        loan.setId(loanId);
        loan.setLoanDate(LocalDate.now());
        loan.setReturnDate(LocalDate.now().plusDays(7));

        List<Loan> loans = Arrays.asList(loan);

        Mockito.when(loanService.getLoansByUserId(1L)).thenReturn(loans);

        mockMvc.perform(get("/api/loans/user/{userId}", 1L)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id.userId", is(1)))
                .andExpect(jsonPath("$[0].loanDate", is(LocalDate.now().toString())));
    }
}
