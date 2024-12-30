package isme.testporjey.Services;

import isme.testporjey.Models.Book;
import isme.testporjey.Models.Loan;
import isme.testporjey.Models.LoanId;
import isme.testporjey.Models.User;
import isme.testporjey.Repositories.BookRepository;
import isme.testporjey.Repositories.LoanRepository;
import isme.testporjey.Repositories.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class LoanService {

    private final LoanRepository loanRepository;
    private final BookRepository bookRepository;
    public LoanService(LoanRepository loanRepository, BookRepository bookRepository) {
        this.bookRepository = bookRepository;
        this.loanRepository = loanRepository;
    }

    public List<Loan> getAllLoans() {
        return loanRepository.findAll();
    }

    public Optional<Loan> getLoanById(LoanId id) {
        return loanRepository.findById(id);
    }

    public boolean checkIfBookAlreadyBorrowed(Long userId, Long bookId) {
        Optional<Loan> loan = loanRepository.findByUserIdAndBookIdAndIsReturnedFalse(userId, bookId);
        return loan.isPresent();
    }


    public Loan saveLoan(Loan loan) {
        // Ensure the loan object has a valid book
        if (loan.getBook() == null || loan.getBook().getId() == null) {
            throw new IllegalArgumentException("Book cannot be null");
        }

        // Retrieve the book from the database
        Optional<Book> bookOpt = bookRepository.findById(loan.getBook().getId());
        if (bookOpt.isEmpty()) {
            throw new RuntimeException("Book not found with ID: " + loan.getBook().getId());
        }

        // Set the book's photo on the loan
        loan.setPhoto(bookOpt.get().getPhoto());

        // Save and return the loan
        Loan savedLoan= loanRepository.save(loan);

        // Decrement the available copies of the book
        Book book = loan.getBook();
        if (book.getAvailableCopies() > 0) {
            book.setAvailableCopies(book.getAvailableCopies() - 1);
            bookRepository.save(book);
        } else {
            throw new IllegalStateException("No available copies left for this book.");
        }

        return savedLoan;
    }

    public List<Loan> getLoansByUserId(Long userId) {
        return loanRepository.findByUserId(userId);
    }

    public void deleteLoan(LoanId id) {
        loanRepository.deleteById(id);
    }
}
