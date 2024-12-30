import { Component, OnInit } from '@angular/core';
import { LoanService, Loan } from '../../services/loan.service';
import { BookService } from '../../services/books.service';
import { CommonModule } from '@angular/common';
import { forkJoin } from 'rxjs';

@Component({
  selector: 'app-history',
  templateUrl: './history.component.html',
  standalone: true,
  imports: [CommonModule],
  styleUrls: ['./history.component.css'],
})
export class HistoryComponent implements OnInit {
  loanHistory: Array<Loan & { bookTitle: string }> = []; // Loan history with book titles
  userId: number | null = null; // User ID retrieved from localStorage
  loading: boolean = true; // Loading indicator

  constructor(
    private loanService: LoanService,
    private bookService: BookService
  ) {}

  ngOnInit(): void {
    const storedUserId = localStorage.getItem('userId');
    if (storedUserId) {
      this.userId = Number(storedUserId);
      this.updateLoansStatus(); // Ensure statuses are updated before fetching
    } else {
      console.error('User ID not found. Please log in.');
      this.loading = false;
    }
  }

  // Utility to check if a loan is overdue
  isOverdue(returnDate: string): boolean {
    return new Date(returnDate).getTime() < Date.now();
  }

  // Update loan statuses and fetch loan history
  updateLoansStatus(): void {
    this.loanService.updateLoanStatuses().subscribe({
      next: () => {
        console.log('Loan statuses updated successfully.');
        this.fetchLoanHistory(); // Fetch updated loan history
      },
      error: (err) => {
        console.error('Error updating loan statuses:', err);
        this.fetchLoanHistory(); // Fetch loan history regardless
      },
    });
  }

  // Fetch loan history and populate book titles
  fetchLoanHistory(): void {
    this.loading = true;

    this.loanService.getLoanHistoryByUserId(this.userId!).subscribe({
      next: (loans) => {
        if (loans.length === 0) {
          this.loanHistory = [];
          this.loading = false;
          return;
        }

        const bookDetailsRequests = loans.map((loan) =>
          this.bookService.getBookById(loan.id?.bookId!)
        );

        forkJoin(bookDetailsRequests).subscribe({
          next: (books) => {
            this.loanHistory = loans.map((loan, index) => ({
              ...loan,
              bookTitle: books[index]?.title || 'Unknown Title',
            }));
            this.loading = false;
          },
          error: (err) => {
            console.error('Error fetching book details:', err);
            this.loanHistory = loans.map((loan) => ({
              ...loan,
              bookTitle: 'Unknown Title',
            }));
            this.loading = false;
          },
        });
      },
      error: (err) => {
        console.error('Error fetching loan history:', err);
        this.loading = false;
      },
    });
  }
}
