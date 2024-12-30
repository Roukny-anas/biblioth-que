package isme.testporjey.ControllersTest;

import isme.testporjey.Controllers.BookController;
import isme.testporjey.JWT.JwtService;
import isme.testporjey.JWT.UserDetailsServiceImpl;
import isme.testporjey.Models.Book;
import isme.testporjey.Models.Category;
import isme.testporjey.Models.Loan;
import isme.testporjey.Models.User;
import isme.testporjey.Services.BookService;
import isme.testporjey.Services.LoanService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.hamcrest.Matchers.is;
import static org.mockito.ArgumentMatchers.any;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(BookController.class)
@AutoConfigureMockMvc
public class BookControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private BookService bookService;
    @MockBean
    private LoanService loanService;

    @MockBean
    private JwtService jwtService;

    @MockBean
    private UserDetailsServiceImpl userDetailsService;
    // Test for getAllBooks()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetAllBooks() throws Exception {
        Category category = new Category();
        category.setName("Science");

        Book book1 = new Book();
        book1.setId(1L);
        book1.setTitle("Book 1");
        book1.setAuthor("Author 1");
        book1.setCategory(category);

        Book book2 = new Book();
        book2.setId(2L);
        book2.setTitle("Book 2");
        book2.setAuthor("Author 2");
        book2.setCategory(category);

        List<Book> books = Arrays.asList(book1, book2);

        Mockito.when(bookService.getAllBooks()).thenReturn(books);

        mockMvc.perform(get("/api/books")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].title", is("Book 1")))
                .andExpect(jsonPath("$[1].title", is("Book 2")));
    }

    // Test for getMostLoanedBook()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetMostLoanedBook() throws Exception {
        Category category = new Category();
        category.setName("Science");

        Book book = new Book();
        book.setId(1L);
        book.setTitle("Most Loaned Book");
        book.setAuthor("Author");
        book.setCategory(category);

        Mockito.when(bookService.getMostLoanedBook()).thenReturn(book);

        mockMvc.perform(get("/api/books/most-loaned")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title", is("Most Loaned Book")));
    }

    // Test for getBookById()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetBookById() throws Exception {
        Category category = new Category();
        category.setName("Science");

        Book book = new Book();
        book.setId(1L);
        book.setTitle("Book 1");
        book.setAuthor("Author 1");
        book.setCategory(category);

        Mockito.when(bookService.getBookById(1L)).thenReturn(Optional.of(book));

        mockMvc.perform(get("/api/books/1")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title", is("Book 1")));
    }


    // Test for deleteBook()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testDeleteBook() throws Exception {
        mockMvc.perform(delete("/api/books/1")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());

        Mockito.verify(bookService, Mockito.times(1)).deleteBook(1L);
    }

    // Test for searchByTitle()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testSearchByTitle() throws Exception {
        Category category = new Category();
        category.setName("Science");

        Book book = new Book();
        book.setId(1L);
        book.setTitle("Book with Title");
        book.setAuthor("Author");
        book.setCategory(category);

        List<Book> books = Arrays.asList(book);

        Mockito.when(bookService.searchByTitle("Book with Title")).thenReturn(books);

        mockMvc.perform(get("/api/books/search/title")
                        .param("title", "Book with Title")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].title", is("Book with Title")));
    }

    // Test for searchByAuthor()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testSearchByAuthor() throws Exception {
        Category category = new Category();
        category.setName("Science");

        Book book = new Book();
        book.setId(1L);
        book.setTitle("Book with Author");
        book.setAuthor("Author");
        book.setCategory(category);

        List<Book> books = Arrays.asList(book);

        Mockito.when(bookService.searchByAuthor("Author")).thenReturn(books);

        mockMvc.perform(get("/api/books/search/author")
                        .param("author", "Author")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].author", is("Author")));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    public void testSearchByCategory() throws Exception {
        // Mock the category and book response
        Category category = new Category();
        category.setName("Science");

        Book book = new Book();
        book.setId(1L);
        book.setTitle("Book in Category");
        book.setAuthor("Author");
        book.setCategory(category);

        Mockito.when(bookService.searchByCategory("Science")).thenReturn(Arrays.asList(book));

        // Perform the GET request
        mockMvc.perform(get("/api/books/search/category")
                        .param("category", "Science")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].category.name", is("Science")));  // Check the 'name' field of the 'category'
    }



    // Test for getBooksGroupedByCategory()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetBooksGroupedByCategory() throws Exception {
        Category category = new Category();
        category.setName("Science");

        Book book1 = new Book();
        book1.setId(1L);
        book1.setTitle("Book 1");
        book1.setCategory(category);

        Book book2 = new Book();
        book2.setId(2L);
        book2.setTitle("Book 2");
        book2.setCategory(category);

        List<Book> books = Arrays.asList(book1, book2);

        Mockito.when(bookService.getAllBooks()).thenReturn(books);

        mockMvc.perform(get("/api/books/books-by-category")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.Science[0].title", is("Book 1")))
                .andExpect(jsonPath("$.Science[1].title", is("Book 2")));
    }
}
