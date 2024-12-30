package isme.testporjey.ModelsTest;

import isme.testporjey.Models.Loan;
import isme.testporjey.Models.Book;
import isme.testporjey.Models.LoanId;
import isme.testporjey.Models.User;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class LoanTest {

    @Test
    public void testValues() {
        User user = new User();
        user.setId(1L);
        Book book = new Book(1L, "Test Title", "Test Photo", "Test Author", "Test Description", 5, null, null);

        Loan loan = new Loan();
        loan.setId(new LoanId(user.getId(), book.getId()));
        loan.setUser(user);
        loan.setBook(book);
        loan.setLoanDate(LocalDate.now());
        loan.setReturnDate(LocalDate.now().plusDays(7));
        loan.setReturned(false);

        assertEquals(user.getId(), loan.getUser().getId());
        assertEquals(book.getId(), loan.getBook().getId());
        assertEquals(LocalDate.now(), loan.getLoanDate());
        assertEquals(LocalDate.now().plusDays(7), loan.getReturnDate());
        assertFalse(loan.isReturned());
    }
    @Test
    public void testLoans() {
        User user = new User();
        user.setId(1L);
        Book book = new Book(1L, "Test Title", "Test Photo", "Test Author", "Test Description", 5, null, null);

        Loan loan = new Loan();
        loan.setId(new LoanId(user.getId(), book.getId()));
        loan.setUser(user);
        loan.setBook(book);
        loan.setLoanDate(LocalDate.now());
        loan.setReturnDate(LocalDate.now().plusDays(7));
        loan.setReturned(false);

        List<Loan> loans = new ArrayList<>();
        loans.add(loan);
        book.setLoans(loans);

        assertEquals(1, book.getLoans().size());
        assertEquals(loan, book.getLoans().get(0));
    }
    @Test
    public void testToString() {
        User user = new User();
        user.setId(1L);
        Book book = new Book(1L, "Test Title", "Test Photo", "Test Author", "Test Description", 5, null, null);

        Loan loan = new Loan();
        loan.setId(new LoanId(user.getId(), book.getId()));
        loan.setUser(user);
        loan.setBook(book);
        loan.setLoanDate(LocalDate.now());
        loan.setReturnDate(LocalDate.now().plusDays(7));
        loan.setReturned(false);

        String expected = "Loan(id=LoanId(userId=1, bookId=1), user=User{id=1}, book=Book{id=1, title=Test Title, photo=Test Photo, author=Test Author, description=Test Description, availableCopies=5}, loanDate=" + LocalDate.now() + ", returnDate=" + LocalDate.now().plusDays(7) + ", isReturned=false)";
        assertEquals(expected, loan.toString());
    }
    @Test
    public void testEqualsAndHashCode() {
        User user = new User();
        user.setId(1L);
        Book book = new Book(1L, "Test Title", "Test Photo", "Test Author", "Test Description", 5, null, null);

        Loan loan1 = new Loan();
        loan1.setId(new LoanId(user.getId(), book.getId()));
        loan1.setUser(user);
        loan1.setBook(book);
        loan1.setLoanDate(LocalDate.now());
        loan1.setReturnDate(LocalDate.now().plusDays(7));
        loan1.setReturned(false);

        Loan loan2 = new Loan();
        loan2.setId(new LoanId(user.getId(), book.getId()));
        loan2.setUser(user);
        loan2.setBook(book);
        loan2.setLoanDate(LocalDate.now());
        loan2.setReturnDate(LocalDate.now().plusDays(7));
        loan2.setReturned(false);

        assertEquals(loan1, loan2);
        assertEquals(loan1.hashCode(), loan2.hashCode());
    }



}