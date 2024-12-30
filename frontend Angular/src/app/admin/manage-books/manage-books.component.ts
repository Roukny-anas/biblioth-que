import { Component, OnInit } from '@angular/core';
import { BookService, Book } from '../../services/books.service';
import { CategoryService, Category } from '../../services/category.service';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-manage-books',
  templateUrl: './manage-books.component.html',
  styleUrls: ['./manage-books.component.css'],
  standalone: true,
  imports: [FormsModule, CommonModule],
})
export class ManageBooksComponent implements OnInit {
  books: Book[] = []; // List of books
  categories: Category[] = []; // List of categories for dropdown selection

  // New book object for addition or modification
  newBook: Book = {
    title: '',
    author: '',
    photo: '',
    description: '',
    availableCopies: 0,
    category: { id: null, name: '' },
  };

  searchQuery: string = '';
  selectedCategoryId: number | null = null;

  editingBook: Book | null = null; // Holds the book being edited

  constructor(
    private bookService: BookService,
    private categoryService: CategoryService
  ) {}

  ngOnInit(): void {
    this.loadBooks();
    this.loadCategories();
  }

  // Load all books
  loadBooks(): void {
    this.bookService.getAllBooks().subscribe((data) => {
      this.books = data;
    });
  }

  // Load categories for dropdown
  loadCategories(): void {
    this.categoryService.getAllCategories().subscribe((data) => {
      this.categories = data;
    });
  }

  // Add or Edit a Book
  saveBook(): void {
    if (!this.selectedCategoryId) {
      alert('Please select a category for the book.');
      return;
    }

    const selectedCategory = this.categories.find(
      (category) => category.id === +(this.selectedCategoryId || 0)
    );

    if (!selectedCategory) {
      alert('Invalid category selection.');
      return;
    }

    this.newBook.category = selectedCategory;

    if (this.editingBook) {
      // Edit existing book
      this.bookService.createBook(this.newBook).subscribe(() => {
        this.loadBooks();
        this.resetBookForm();
      });
    } else {
      // Add new book
      this.bookService.createBook(this.newBook).subscribe(() => {
        this.loadBooks();
        this.resetBookForm();
      });
    }
  }

  // Set book to edit mode
  editBook(book: Book): void {
    this.editingBook = book;
    this.newBook = { ...book };
    this.selectedCategoryId = book.category?.id || null;
  }

  // Delete a book
  deleteBook(id: number): void {
    this.bookService.deleteBook(id).subscribe(() => this.loadBooks());
  }

  // Reset the book form
  resetBookForm(): void {
    this.newBook = {
      title: '',
      author: '',
      photo: '',
      description: '',
      availableCopies: 0,
      category: { id: null, name: '' },
    };
    this.selectedCategoryId = null;
    this.editingBook = null;
  }

  // Search books by title
  searchByTitle(): void {
    if (this.searchQuery.trim()) {
      this.bookService.searchByTitle(this.searchQuery).subscribe((data) => {
        this.books = data;
      });
    } else {
      this.loadBooks();
    }
  }
}
