package isme.testporjey.ServicesTest;

import isme.testporjey.Models.Book;
import isme.testporjey.Repositories.BookRepository;
import isme.testporjey.Services.BookService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

public class BookServiceTest {

    @Mock
    private BookRepository bookRepository;

    @InjectMocks
    private BookService bookService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testGetAllBooks() {
        Book book1 = new Book();
        Book book2 = new Book();
        List<Book> books = Arrays.asList(book1, book2);

        when(bookRepository.findAll()).thenReturn(books);

        List<Book> result = bookService.getAllBooks();
        assertEquals(2, result.size());
        verify(bookRepository, times(1)).findAll();
    }

    @Test
    public void testGetBookById() {
        Book book = new Book();
        when(bookRepository.findById(1L)).thenReturn(Optional.of(book));

        Optional<Book> result = bookService.getBookById(1L);
        assertEquals(book, result.orElse(null));
        verify(bookRepository, times(1)).findById(1L);
    }

    @Test
    public void testSaveBook() {
        Book book = new Book();
        when(bookRepository.save(any(Book.class))).thenReturn(book);

        Book result = bookService.saveBook(book);
        assertEquals(book, result);
        verify(bookRepository, times(1)).save(book);
    }

    @Test
    public void testDeleteBook() {
        doNothing().when(bookRepository).deleteById(1L);

        bookService.deleteBook(1L);
        verify(bookRepository, times(1)).deleteById(1L);
    }

    @Test
    public void testSearchByTitle() {
        Book book = new Book();
        List<Book> books = Arrays.asList(book);

        when(bookRepository.findByTitleContainingIgnoreCase("title")).thenReturn(books);

        List<Book> result = bookService.searchByTitle("title");
        assertEquals(1, result.size());
        verify(bookRepository, times(1)).findByTitleContainingIgnoreCase("title");
    }

    @Test
    public void testSearchByAuthor() {
        Book book = new Book();
        List<Book> books = Arrays.asList(book);

        when(bookRepository.findByAuthorContainingIgnoreCase("author")).thenReturn(books);

        List<Book> result = bookService.searchByAuthor("author");
        assertEquals(1, result.size());
        verify(bookRepository, times(1)).findByAuthorContainingIgnoreCase("author");
    }

    @Test
    public void testSearchByCategory() {
        Book book = new Book();
        List<Book> books = Arrays.asList(book);

        when(bookRepository.findByCategoryName("category")).thenReturn(books);

        List<Book> result = bookService.searchByCategory("category");
        assertEquals(1, result.size());
        verify(bookRepository, times(1)).findByCategoryName("category");
    }

    @Test
    public void testGetMostLoanedBook() {
        Book book = new Book();
        when(bookRepository.findMostLoanedBook()).thenReturn(book);

        Book result = bookService.getMostLoanedBook();
        assertEquals(book, result);
        verify(bookRepository, times(1)).findMostLoanedBook();
    }
}