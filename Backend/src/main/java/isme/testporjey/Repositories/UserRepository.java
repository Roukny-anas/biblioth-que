package isme.testporjey.Repositories;

import isme.testporjey.Models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User,Long> {
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    @Query(value = "SELECT u.* " +
            "FROM User u " +
            "WHERE u.id = (" +
            "  SELECT l.user_id " +
            "  FROM Loan l " +
            "  GROUP BY l.user_id " +
            "  ORDER BY COUNT(l.book_id) DESC " +
            "  LIMIT 1" +
            ")", nativeQuery = true)
    User findUserWithMostLoans();
}

