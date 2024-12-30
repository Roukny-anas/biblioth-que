import { Component, OnInit } from '@angular/core';
import { UserService, User } from '../../services/user.service';
import { BookService, Book } from '../../services/books.service';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-statistics',
  standalone: true,
  imports: [RouterModule, CommonModule],
  templateUrl: './statistics.component.html',
  styleUrls: ['./statistics.component.css'],
})
export class StatisticsComponent implements OnInit {
  mostLoanedBook: Book | null = null;
  userWithMostLoans: User | null = null;
  isLoading: boolean = true;
  totalUsers: number = 0;
  totalBooks: number = 0;

  constructor(private bookService: BookService, private userService: UserService) {}

  ngOnInit(): void {
    this.loadStatistics();
  }

  loadStatistics(): void {
    this.isLoading = true;
    this.loadMostLoanedBook();
    this.loadUserWithMostLoans();

    this.userService.getAllUsers().subscribe(
      (users) => {
        this.totalUsers = users.length; // Assuming `getAllUsers` returns an array of users
      },
      (error) => {
        console.error('Error fetching total users:', error);
        this.totalUsers = 0; // Default in case of error
      }
    );

    this.bookService.getAllBooks().subscribe(
      (books) => {
        this.totalBooks = books.length; // Assuming `getAllBooks` returns an array of books
      },
      (error) => {
        console.error('Error fetching total books:', error);
        this.totalBooks = 0; // Default in case of error
      },
      () => {
        this.isLoading = false; // Only set loading to false after all the data is loaded
      }
    );
  }

  loadMostLoanedBook(): void {
    this.bookService.getMostLoanedBook().subscribe(
      (book) => {
        this.mostLoanedBook = book;
        console.log('Most Loaned Book:', book);
      },
      (error) => {
        console.error('Error fetching most loaned book:', error);
        this.mostLoanedBook = null;
      }
    );
  }

  loadUserWithMostLoans(): void {
    this.userService.getUserWithMostLoans().subscribe(
      (user) => {
        this.userWithMostLoans = user;
        console.log('User with Most Loans:', user);
      },
      (error) => {
        console.error('Error fetching user with most loans:', error);
        this.userWithMostLoans = null;
      }
    );
  }
}
