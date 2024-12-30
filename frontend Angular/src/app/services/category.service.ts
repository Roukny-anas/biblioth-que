import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

// Interface for Category
export interface Category {
  id: number | null; // Matches the type expected in newBook
  name: string;
}


@Injectable({
  providedIn: 'root',
})
export class CategoryService {
  private apiUrl = 'http://localhost:8080/api/categories'; // Backend API URL

  constructor(private http: HttpClient) {}

  // Helper method to add the Authorization header
  private getAuthHeaders(): HttpHeaders {
    const token = localStorage.getItem('jwtToken'); // Token stored in localStorage
    if (!token) {
      console.error('No JWT token found!');
    }
    return new HttpHeaders({
      Authorization: 'Bearer ' + token, // Ensure 'Bearer ' prefix
    });
  }

  // Retrieve all categories
  getAllCategories(): Observable<Category[]> {
    return this.http.get<Category[]>(this.apiUrl, { headers: this.getAuthHeaders() });
  }

  // Retrieve a category by ID
  getCategoryById(id: number): Observable<Category> {
    return this.http.get<Category>(`${this.apiUrl}/${id}`, { headers: this.getAuthHeaders() });
  }

  // Retrieve a category by name
  getCategoryByName(name: string): Observable<Category> {
    return this.http.get<Category>(`${this.apiUrl}/search/${name}`, { headers: this.getAuthHeaders() });
  }

  // Create a new category (reserved for admins)
  createCategory(category: Category): Observable<Category> {
    return this.http.post<Category>(this.apiUrl, category, { headers: this.getAuthHeaders() });
  }

  // Delete a category by ID (reserved for admins)
  deleteCategory(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`, { headers: this.getAuthHeaders() });
  }
}
