import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';

// Define the Loan and LoanId interfaces for the payload
export interface Loan {
  id?: {
    userId: number;
    bookId: number;
  }; // Composite primary key
  userId: number;
  bookId: number;
  loanDate: string;
  returnDate: string;
  isReturned: boolean;
  photo?: string; // Book photo
}

export interface LoanId {
  userId: number;
  bookId: number;
}

@Injectable({
  providedIn: 'root',
})
export class LoanService {
  private apiUrl = 'http://localhost:8080/api/loans'; // API endpoint

  constructor(private http: HttpClient) {}

  // Helper to get Authorization headers
  private getAuthHeaders(): HttpHeaders {
    const token = localStorage.getItem('jwtToken');
    console.log('JWT Token:', token); // Debugging
    if (!token) {
      console.error('No JWT token found. Please log in.');
      return new HttpHeaders(); // Return empty headers if token is missing
    }
    return new HttpHeaders({ Authorization: 'Bearer ' + token });
  }

  // Create a new loan
  createLoan(loan: Loan): Observable<Loan> {
    const headers = this.getAuthHeaders();
    const formattedLoan = {
      user: { id: loan.userId }, // Wrap userId inside an object
      book: { id: loan.bookId }, // Wrap bookId inside an object
      loanDate: loan.loanDate,
      returnDate: loan.returnDate,
      isReturned: loan.isReturned,
    };
    return this.http.post<Loan>(`${this.apiUrl}/create`, formattedLoan, { headers }).pipe(
      catchError((error) => {
        console.error('Error creating loan:', error);
        return throwError(error);
      })
    );
  }

  // Check if a book is already borrowed by a user
  checkIfBookAlreadyBorrowed(userId: number, bookId: number): Observable<boolean> {
    return this.http.get<boolean>(`${this.apiUrl}/check/${userId}/${bookId}`, {
      headers: this.getAuthHeaders(),
    }).pipe(
      catchError((error) => {
        console.error('Error checking if book is borrowed:', error);
        return throwError(error);
      })
    );
  }

  // Get loans by user ID
  getLoansByUserId(userId: number): Observable<Loan[]> {
    return this.http.get<Loan[]>(`${this.apiUrl}/user/${userId}`, {
      headers: this.getAuthHeaders(),
    }).pipe(
      catchError((error) => {
        console.error('Error fetching loans:', error);
        return throwError(error);
      })
    );
  }

  // Get loan history by user ID
  getLoanHistoryByUserId(userId: number): Observable<Loan[]> {
    return this.http.get<Loan[]>(`${this.apiUrl}/user/${userId}/history`, {
      headers: this.getAuthHeaders(),
    }).pipe(
      catchError((error) => {
        console.error('Error fetching loan history:', error);
        return throwError(error);
      })
    );
  }

  // Update loan status (e.g., mark as returned

  // Delete a loan by LoanId
  deleteLoan(loanId: LoanId): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${loanId.userId}/${loanId.bookId}`, {
      headers: this.getAuthHeaders(),
    }).pipe(
      catchError((error) => {
        console.error('Error deleting loan:', error);
        return throwError(error);
      })
    );
  }

  // Get book details
  getBookDetails(bookId: number): Observable<{ id: number; title: string }> {
    const url = `http://localhost:8080/api/books/${bookId}`;
    return this.http.get<{ id: number; title: string }>(url, {
      headers: this.getAuthHeaders(),
    }).pipe(
      catchError((error) => {
        console.error(`Error fetching book details for bookId ${bookId}:`, error);
        return throwError(error);
      })
    );
  }

  // Fetch all loans
getAllLoans(): Observable<Loan[]> {
  return this.http.get<Loan[]>(`${this.apiUrl}`, {
    headers: this.getAuthHeaders(),
  }).pipe(
    catchError((error) => {
      console.error('Error fetching all loans:', error);
      return throwError(error);
    })
  );
}

updateLoanStatuses(): Observable<any> {
  const headers = this.getAuthHeaders();
  return this.http.post(`${this.apiUrl}/update-loans-status`, {}, { headers }).pipe(
    catchError((error) => {
      console.error('Error updating loan statuses:', error);
      return throwError(error);
    })
  );
}


}
