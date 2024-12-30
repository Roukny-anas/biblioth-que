package isme.testporjey.ControllersTest;

import com.fasterxml.jackson.databind.ObjectMapper;
import isme.testporjey.Controllers.LoanController;
import isme.testporjey.JWT.JwtService;
import isme.testporjey.JWT.UserDetailsServiceImpl;
import isme.testporjey.Models.Book;
import isme.testporjey.Models.Loan;
import isme.testporjey.Models.LoanId;
import isme.testporjey.Models.User;
import isme.testporjey.Repositories.BookRepository;
import isme.testporjey.Services.LoanService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDate;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(LoanController.class)
public class LoanControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private LoanService loanService;

    @MockBean
    private BookRepository bookRepository;

    @MockBean
    private JwtService jwtService;

    @MockBean
    private UserDetailsServiceImpl userDetailsService;

    @Test
    @WithMockUser(roles = "USER")
    public void testCreateLoan() throws Exception {
        // Create test data
        Book book = new Book();
        book.setId(1L);
        book.setTitle("Test Book");
        book.setAvailableCopies(5);

        User user = new User();
        user.setId(1L);

        LoanId loanId = new LoanId();
        loanId.setBookId(1L);
        loanId.setUserId(1L);

        Loan loan = new Loan();
        loan.setId(loanId);
        loan.setBook(book);
        loan.setUser(user);
        loan.setLoanDate(LocalDate.now());
        loan.setReturnDate(LocalDate.now().plusDays(14));
        loan.setReturned(false);

        // Mock repository response
        Mockito.when(bookRepository.findById(1L)).thenReturn(Optional.of(book));
        Mockito.when(loanService.saveLoan(any(Loan.class))).thenReturn(loan);

        // Perform the request
        mockMvc.perform(post("/api/loans/create")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loan)))
                .andExpect(status().isCreated());
    }
}