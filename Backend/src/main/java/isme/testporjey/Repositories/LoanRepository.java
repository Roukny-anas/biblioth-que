package isme.testporjey.Repositories;

import isme.testporjey.Models.Book;
import isme.testporjey.Models.Loan;
import isme.testporjey.Models.LoanId;
import isme.testporjey.Models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LoanRepository extends JpaRepository<Loan, LoanId> {
    List<Loan> findByUserId(Long userId);

    Optional<Loan> findByUserIdAndBookIdAndIsReturnedFalse(Long userId, Long bookId);



}