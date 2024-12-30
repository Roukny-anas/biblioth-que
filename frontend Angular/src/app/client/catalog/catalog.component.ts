import { Component, OnInit } from '@angular/core';
import { BookService, Book } from '../../services/books.service';
import { CategoryService, Category } from '../../services/category.service';
import { LoanService, Loan } from '../../services/loan.service';
import { UserService } from '../../services/user.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Subject } from 'rxjs';
import { debounceTime, distinctUntilChanged, switchMap } from 'rxjs/operators';

@Component({
  selector: 'app-catalog',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './catalog.component.html',
  styleUrls: ['./catalog.component.css'],
})
export class CatalogComponent implements OnInit {
  bookCategories: { [key: string]: Book[] } = {};
  categories: Category[] = [];
  books: Book[] = [];
  searchType: string = 'title';
  userId: number = 0; // Default value
  private searchTerms = new Subject<string>();

  constructor(
    private bookService: BookService,
    private categoryService: CategoryService,
    private loanService: LoanService,
    private userService: UserService
  ) {}

  ngOnInit(): void {
    this.userId = this.getLoggedInUserId();

    if (!this.userId) {
      alert('User not logged in. Please login to continue.');
      return;
    }

    this.fetchBooksByCategory();
    this.loadCategories();

    this.initializeSearch();
  }

  

  // Initialize search handling
  private initializeSearch(): void {
    this.searchTerms
      .pipe(
        debounceTime(300),
        distinctUntilChanged(),
        switchMap((term: string) => this.performSearch(term))
      )
      .subscribe({
        next: (books) => this.updateCategories(books),
        error: (err) => console.error('Error during search:', err),
      });
  }

  // Handle user search input
  onSearch(term: string): void {
    if (term.length < 2) {
      this.fetchBooksByCategory();
      return;
    }
    this.searchTerms.next(term.toLowerCase());
  }

  onSearchInput(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input) {
      this.onSearch(input.value);
    }
  }

  // Reset the catalog view
  resetCatalog(): void {
    this.searchTerms.next('');
    const inputElement = document.querySelector('.search-input') as HTMLInputElement;
    if (inputElement) {
      inputElement.value = '';
    }
    this.fetchBooksByCategory();
  }

  // Borrow a book
  borrowBook(bookId: number): void {
    if (!this.userId) {
      alert('Please login to borrow books.');
      return;
    }
  
    // Check if the user has already borrowed this book
    this.loanService.checkIfBookAlreadyBorrowed(this.userId, bookId).subscribe({
      next: (alreadyBorrowed) => {
        if (alreadyBorrowed) {
          alert('Vous avez déjà emprunté ce livre et ne pouvez pas le réemprunter.');
          return;
        }
  
        // If not already borrowed, proceed to borrow the book
        const loanDuration = 14;
        const returnDate = new Date(
          new Date().setDate(new Date().getDate() + loanDuration)
        )
          .toISOString()
          .split('T')[0];
  
        // Fetch the book details from the books array
        const book = this.books.find((b) => b.id === bookId);
  
        if (!book) {
          alert('Book not found!');
          console.log('Book not found with id:', bookId); // Debugging log to see the missing book ID
          return;
        }
  
        // Check if the book is available
        if (book.availableCopies === 0) {
          alert('Sorry, this book is not available for borrowing.');
          return;
        }
  
        const loan: Loan = {
          userId: this.userId,
          bookId: bookId,
          loanDate: new Date().toISOString().split('T')[0],
          returnDate: returnDate,
          isReturned: false,
        };
  
        this.loanService.createLoan(loan).subscribe({
          next: () => {
            const message = `Vous avez emprunté ce livre avec succès ! La durée de l'emprunt est de ${loanDuration} jours, vous devez le rendre avant le ${returnDate}.`;
            alert(message);
            this.fetchBooksByCategory(); // Refresh the catalog
          },
          error: (err) => {
            console.error('Error borrowing book:', err);
            alert('Failed to borrow the book.');
          },
        });
      },
      error: (err) => {
        console.error('Error checking if book is already borrowed:', err);
        alert('Failed to verify if the book is already borrowed.');
      },
    });
  }
  
  
  
  
  

  // Fetch books grouped by category
  fetchBooksByCategory(): void {
    this.bookService.getBooksByCategory().subscribe({
      next: (data) => {
        console.log('Books by category response:', data); // Log the full response
        this.bookCategories = data;
        this.books = Object.values(data).flat(); // Flatten categories into a single array of books
        console.log('Flattened books:', this.books); // Log the flattened books
      },
      error: (err) => {
        console.error('Error fetching books by category:', err);
      },
    });
  }
  

  // Load available categories
  loadCategories(): void {
    this.categoryService.getAllCategories().subscribe({
      next: (categories) => (this.categories = categories),
      error: (err) => console.error('Error fetching categories:', err),
    });
  }

  // Perform search based on selected type
  private performSearch(term: string) {
    switch (this.searchType) {
      case 'title':
        return this.bookService.searchByTitle(term);
      case 'author':
        return this.bookService.searchByAuthor(term);
      case 'category':
        return this.bookService.searchByCategory(term);
      default:
        return this.bookService.getAllBooks();
    }
  }

  // Update book categories after search
  updateCategories(books: Book[]): void {
    this.bookCategories = books.reduce((acc, book) => {
      const categoryName = book.category?.name || 'Uncategorized';
      if (!acc[categoryName]) {
        acc[categoryName] = [];
      }
      acc[categoryName].push(book);
      return acc;
    }, {} as { [key: string]: Book[] });
  }

  // Fetch the logged-in user's ID
  private getLoggedInUserId(): number {
    const userId = localStorage.getItem('userId');
    return userId ? parseInt(userId, 10) : 0;
  }

  // Search by category after clicking on a category
  onCategoryClick(categoryName: string): void {
    this.bookService.searchByCategory(categoryName).subscribe({
      next: (books) => this.updateCategories(books),
      error: (err) => console.error('Error searching by category:', err),
    });
  }
}
