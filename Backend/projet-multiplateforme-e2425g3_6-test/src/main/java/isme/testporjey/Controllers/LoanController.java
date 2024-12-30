package isme.testporjey.Controllers;

import isme.testporjey.Models.Book;
import isme.testporjey.Models.Loan;
import isme.testporjey.Models.LoanId;
import isme.testporjey.Models.User;
import isme.testporjey.Repositories.BookRepository;
import isme.testporjey.Services.LoanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/loans")
public class LoanController {

    private final LoanService loanService;

    @Autowired
    private BookRepository bookRepository;

    public LoanController(LoanService loanService) {
        this.loanService = loanService;
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping
    public List<Loan> getAllLoans() {
        return loanService.getAllLoans();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/{id}")
    public Optional<Loan> getLoanById(@PathVariable LoanId id) {
        return loanService.getLoanById(id);
    }
    @PreAuthorize("hasRole('USER')")
    @GetMapping("/check/{userId}/{bookId}")
    public ResponseEntity<Boolean> checkIfBookAlreadyBorrowed(@PathVariable Long userId, @PathVariable Long bookId) {
        boolean hasBorrowed = loanService.checkIfBookAlreadyBorrowed(userId, bookId);
        return ResponseEntity.ok(hasBorrowed);
    }


    @PreAuthorize("hasRole('USER')")
    @PostMapping("/create")
    public ResponseEntity<Loan> createLoan(@RequestBody Loan loan) {
        // Ensure the Book reference is not null
        if (loan.getBook() == null || loan.getBook().getId() == null) {
            return ResponseEntity.badRequest().body(null);
        }

        // Retrieve the Book entity from the database
        Optional<Book> bookOpt = bookRepository.findById(loan.getBook().getId());
        if (bookOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(null); // Book not found
        }

        // Ensure the Book is set correctly on the Loan
        loan.setBook(bookOpt.get());
        loan.setPhoto(bookOpt.get().getPhoto());

        // Set the LoanId for the Loan object (if not set yet)
        if (loan.getId() == null) {
            LoanId loanId = new LoanId();
            loanId.setBookId(loan.getBook().getId());
            loanId.setUserId(loan.getUser().getId());
            loan.setId(loanId);
        }

        // Save and return the Loan object
        Loan savedLoan = loanService.saveLoan(loan);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedLoan); // Return created status
    }



    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public void deleteLoan(@PathVariable LoanId id) {
        loanService.deleteLoan(id);
    }

    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')")
    @GetMapping("/user/{userId}")
    public List<Loan> getLoansByUserId(@PathVariable Long userId) {
        return loanService.getLoansByUserId(userId);
    }
}
