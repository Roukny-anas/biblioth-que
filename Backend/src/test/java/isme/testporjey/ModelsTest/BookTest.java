package isme.testporjey.ModelsTest;

import isme.testporjey.Models.Book;
import isme.testporjey.Models.Category;
import isme.testporjey.Models.Loan;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class BookTest {

    @Test
    public void testValues() {
        Category category = new Category();
        Book book = new Book(1L, "Test Title", "Test Photo", "Test Author", "Test Description", 5, category, null);

        assertEquals(1L, book.getId());
        assertEquals("Test Title", book.getTitle());
        assertEquals("Test Photo", book.getPhoto());
        assertEquals("Test Author", book.getAuthor());
        assertEquals("Test Description", book.getDescription());
        assertEquals(5, book.getAvailableCopies());
        assertEquals(category, book.getCategory());
    }

    @Test
    public void testLoans() {
        Book book = new Book();
        List<Loan> loans = new ArrayList<>();
        Loan loan = new Loan();
        loans.add(loan);
        book.setLoans(loans);

        assertEquals(1, book.getLoans().size());
        assertEquals(loan, book.getLoans().get(0));
    }

    @Test
    public void testToString() {
        Category category = new Category();
        Book book = new Book(1L, "Test Title", "Test Photo", "Test Author", "Test Description", 5, category, null);

        String expected = "Book(id=1, title=Test Title, photo=Test Photo, author=Test Author, description=Test Description, availableCopies=5, category=" + category + ", loans=null)";
        assertEquals(expected, book.toString());
    }

    @Test
    public void testEqualsAndHashCode() {
        Category category = new Category();
        Book book1 = new Book(1L, "Test Title", "Test Photo", "Test Author", "Test Description", 5, category, null);
        Book book2 = new Book(1L, "Test Title", "Test Photo", "Test Author", "Test Description", 5, category, null);

        assertEquals(book1, book2);
        assertEquals(book1.hashCode(), book2.hashCode());
    }
}