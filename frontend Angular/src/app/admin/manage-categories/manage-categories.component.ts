import { Component, OnInit } from '@angular/core';
import { CategoryService, Category } from '../../services/category.service';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-manage-categories',
  templateUrl: './manage-categories.component.html',
  styleUrls: ['./manage-categories.component.css'],
  standalone: true,
  imports: [FormsModule, CommonModule],
})
export class ManageCategoriesComponent implements OnInit {
  categories: Category[] = [];
  newCategory: Category = { id: null, name: '' };
  editingCategory: Category | null = null;

  constructor(private categoryService: CategoryService) {}

  ngOnInit(): void {
    this.loadCategories();
  }

  // Load all categories
  loadCategories(): void {
    this.categoryService.getAllCategories().subscribe((data) => {
      this.categories = data;
    });
  }

  // Add or Edit a Category
  saveCategory(): void {
    if (this.newCategory.name.trim()) {
      this.categoryService.createCategory(this.newCategory).subscribe(() => {
        this.loadCategories();
        this.resetCategoryForm();
      });
    }
  }

  // Edit a category
  editCategory(category: Category): void {
    this.editingCategory = category;
    this.newCategory = { ...category };
  }

  // Delete a category
  deleteCategory(id: number): void {
    this.categoryService.deleteCategory(id).subscribe(() => this.loadCategories());
  }

  // Reset the category form
  resetCategoryForm(): void {
    this.newCategory = { id: null, name: '' };
    this.editingCategory = null;
  }
}
