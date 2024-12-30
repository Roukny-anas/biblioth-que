import { Component, OnInit } from '@angular/core';
import { LoanService, Loan } from '../../services/loan.service';
import { BookService, Book } from '../../services/books.service';
import { CommonModule } from '@angular/common';
import { forkJoin } from 'rxjs';

@Component({
  selector: 'app-loans',
  templateUrl: './loans.component.html',
  standalone: true,
  imports: [CommonModule],
  styleUrls: ['./loans.component.css']
})
export class LoansComponent implements OnInit {
  borrowedBooks: Array<Loan & { bookTitle: string }> = []; // Borrowed books with titles
  userId: number | null = null; // User ID, fetched from local storage

  constructor(
    private loanService: LoanService,
    private bookService: BookService
  ) {}

  ngOnInit(): void {
    const storedUserId = localStorage.getItem('userId');
    if (storedUserId) {
      this.userId = Number(storedUserId); // Convert userId to a number
      this.fetchBorrowedBooks();
    } else {
      console.error('User ID not found. Please log in.');
    }
  }
  

  fetchBorrowedBooks(): void {
    this.loanService.getLoansByUserId(this.userId!).subscribe({
      next: (loans) => {
        this.borrowedBooks = [];
        loans.forEach((loan) => {
          // Extract the bookId from the nested id field
          const bookId = loan.id?.bookId; // Safely access bookId
  
          console.log('Loan data:', loan);
          console.log('Book ID:', bookId);
  
          if (bookId) {
            this.bookService.getBookById(bookId).subscribe({
              next: (book: Book) => {
                this.borrowedBooks.push({
                  ...loan,
                  bookTitle: book.title, // Add the book title to the loan object
                });
              },
              error: (err) => {
                console.error(`Error fetching book details for bookId ${bookId}:`, err);
                // Fallback in case book details fetching fails
                this.borrowedBooks.push({
                  ...loan,
                  bookTitle: 'Unknown Title',
                });
              },
            });
          } else {
            console.error('Loan object is missing bookId:', loan);
          }
        });
      },
      error: (err) => {
        console.error('Error fetching loans:', err);
      },
    });
  }
  
  

  // Calculate the number of days remaining for a loan
  daysLeft(returnDate: string): number {
    const today = new Date();
    const returnDay = new Date(returnDate);
    const timeDifference = returnDay.getTime() - today.getTime();
    return Math.ceil(timeDifference / (1000 * 60 * 60 * 24)); // Convert milliseconds to days
  }
}
