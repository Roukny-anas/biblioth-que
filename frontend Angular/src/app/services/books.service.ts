import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { catchError, Observable, throwError } from 'rxjs';
import { Category } from './category.service';

// Book Interface
export interface Book {
  id?: number;
  title: string;
  author: string;
  photo?: string;
  description: string;
  availableCopies: number;
  category?: Category;
  
}

@Injectable({
  providedIn: 'root',
})
export class BookService {
  private apiUrl = 'http://localhost:8080/api/books';

  constructor(private http: HttpClient) {}

  // Helper to get authorization headers
  private getAuthHeaders(): HttpHeaders {
    const token = localStorage.getItem('jwtToken');
    if (!token) {
      console.error('No JWT token found!');
      return new HttpHeaders(); // Return empty headers if token is missing
    }
    return new HttpHeaders({ Authorization: 'Bearer ' + token });
  }

  // Retrieve all books
  getAllBooks(): Observable<Book[]> {
    return this.http.get<Book[]>(this.apiUrl, { headers: this.getAuthHeaders() });
  }

  // Retrieve a book by ID
  getBookById(id: number): Observable<Book> {
    const headers = this.getAuthHeaders();
    console.log('Fetching book with ID:', id);
    console.log('Headers:', headers);
  
    return this.http.get<Book>(`${this.apiUrl}/${id}`, { headers }).pipe(
      catchError((error) => {
        console.error(`Error fetching book with ID ${id}:`, error);
        return throwError(error);
      })
    );
  }
  
  getMostLoanedBook(): Observable<Book> {
    return this.http.get<Book>(`${this.apiUrl}/most-loaned`, { headers: this.getAuthHeaders() }).pipe(
      catchError((error) => {
        console.error('Error fetching the most loaned book:', error);
        return throwError(() => new Error('Failed to fetch the most loaned book. Please try again later.'));
      })
    );
  }
  

  // Create a new book
  createBook(book: Book): Observable<Book> {
    return this.http.post<Book>(this.apiUrl, book, { headers: this.getAuthHeaders() });
  }

  // Delete a book
  deleteBook(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`, { headers: this.getAuthHeaders() });
  }

  // Search books by title
  searchByTitle(title: string): Observable<Book[]> {
    return this.http.get<Book[]>(
      `${this.apiUrl}/search/title?title=${encodeURIComponent(title.toLowerCase())}`,
      { headers: this.getAuthHeaders() }
    );
  }

  // Search books by author
  searchByAuthor(author: string): Observable<Book[]> {
    return this.http.get<Book[]>(
      `${this.apiUrl}/search/author?author=${encodeURIComponent(author.toLowerCase())}`,
      { headers: this.getAuthHeaders() }
    );
  }

  // Search books by category
  searchByCategory(category: string): Observable<Book[]> {
    return this.http.get<Book[]>(
      `${this.apiUrl}/search/category?category=${encodeURIComponent(category.toLowerCase())}`,
      { headers: this.getAuthHeaders() }
    );
  }

  // Get books grouped by category
  getBooksByCategory(): Observable<{ [key: string]: Book[] }> {
    return this.http.get<{ [key: string]: Book[] }>(
      `${this.apiUrl}/books-by-category`,
      { headers: this.getAuthHeaders() }
    );
  }
}
