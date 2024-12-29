package isme.testporjey.ServicesTest;


import isme.testporjey.Models.Book;
import isme.testporjey.Models.Loan;
import isme.testporjey.Models.LoanId;
import isme.testporjey.Repositories.BookRepository;
import isme.testporjey.Repositories.LoanRepository;
import isme.testporjey.Services.LoanService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Optional;
import java.util.List;
import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class LoanServiceTest {

    @Mock
    private LoanRepository loanRepository;

    @Mock
    private BookRepository bookRepository;

    @InjectMocks
    private LoanService loanService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testGetAllLoans() {
        List<Loan> loans = new ArrayList<>();
        when(loanRepository.findAll()).thenReturn(loans);

        List<Loan> result = loanService.getAllLoans();
        assertEquals(loans, result);
        verify(loanRepository, times(1)).findAll();
    }

    @Test
    public void testGetLoanById() {
        LoanId loanId = new LoanId(1L, 1L);
        Loan loan = new Loan();
        when(loanRepository.findById(loanId)).thenReturn(Optional.of(loan));

        Optional<Loan> result = loanService.getLoanById(loanId);
        assertTrue(result.isPresent());
        assertEquals(loan, result.get());
        verify(loanRepository, times(1)).findById(loanId);
    }

    @Test
    public void testCheckIfBookAlreadyBorrowed() {
        Long userId = 1L;
        Long bookId = 1L;
        Loan loan = new Loan();
        when(loanRepository.findByUserIdAndBookIdAndIsReturnedFalse(userId, bookId)).thenReturn(Optional.of(loan));

        boolean result = loanService.checkIfBookAlreadyBorrowed(userId, bookId);
        assertTrue(result);
        verify(loanRepository, times(1)).findByUserIdAndBookIdAndIsReturnedFalse(userId, bookId);
    }

    @Test
    public void testSaveLoan() {
        Book book = new Book();
        book.setId(1L);
        book.setAvailableCopies(5);
        Loan loan = new Loan();
        loan.setBook(book);

        when(bookRepository.findById(1L)).thenReturn(Optional.of(book));
        when(loanRepository.save(loan)).thenReturn(loan);

        Loan result = loanService.saveLoan(loan);
        assertEquals(loan, result);
        verify(bookRepository, times(1)).findById(1L);
        verify(loanRepository, times(1)).save(loan);
        verify(bookRepository, times(1)).save(book);
    }

    @Test
    public void testGetLoansByUserId() {
        Long userId = 1L;
        List<Loan> loans = new ArrayList<>();
        when(loanRepository.findByUserId(userId)).thenReturn(loans);

        List<Loan> result = loanService.getLoansByUserId(userId);
        assertEquals(loans, result);
        verify(loanRepository, times(1)).findByUserId(userId);
    }

    @Test
    public void testDeleteLoan() {
        LoanId loanId = new LoanId(1L, 1L);
        doNothing().when(loanRepository).deleteById(loanId);

        loanService.deleteLoan(loanId);
        verify(loanRepository, times(1)).deleteById(loanId);
    }
}