package isme.testporjey.Models;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Loan {
    @EmbeddedId
    private LoanId id;
    private String photo;

    @ManyToOne
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @MapsId("bookId")
    @JoinColumn(name = "book_id")
    private Book book;

    @NotNull
    private LocalDate loanDate;  // Correct field name
    @NotNull
    private LocalDate returnDate; // Correct field name
    @NotNull
    private boolean isReturned;

    @Override
    public String toString() {
        return "Loan(id=" + id +
                ", user=User{id=" + user.getId() + "}" +
                ", book=Book{id=" + book.getId() + ", title=" + book.getTitle() + ", photo=" + book.getPhoto() + ", author=" + book.getAuthor() + ", description=" + book.getDescription() + ", availableCopies=" + book.getAvailableCopies() + "}" +
                ", loanDate=" + loanDate +
                ", returnDate=" + returnDate +
                ", isReturned=" + isReturned + ")";
    }
}
