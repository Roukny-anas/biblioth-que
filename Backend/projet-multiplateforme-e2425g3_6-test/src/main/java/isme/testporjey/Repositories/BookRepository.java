package isme.testporjey.Repositories;


import isme.testporjey.Models.Book;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookRepository extends JpaRepository<Book,Long> {
    List<Book> findByTitle(String title);
    List<Book> findByAuthor(String author);

    List<Book> findByCategoryName(String category);

    @Query("SELECT b FROM Book b WHERE LOWER(b.title) LIKE LOWER(CONCAT('%', :title, '%'))")
    List<Book> findByTitleContainingIgnoreCase(@Param("title") String title);

    @Query("SELECT b FROM Book b WHERE LOWER(b.author) LIKE LOWER(CONCAT('%', :author, '%'))")
    List<Book> findByAuthorContainingIgnoreCase(@Param("author") String author);
    @Query(value = "SELECT b.* " +
            "FROM Book b " +
            "WHERE b.id = (" +
            "  SELECT l.book_id " +
            "  FROM Loan l " +
            "  GROUP BY l.book_id " +
            "  ORDER BY COUNT(l.book_id) DESC " +
            "  LIMIT 1" +
            ")", nativeQuery = true)
    Book findMostLoanedBook();
}