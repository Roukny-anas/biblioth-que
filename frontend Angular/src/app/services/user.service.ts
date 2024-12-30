import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface User {
  id?: number;
  username: string;
  email: string;
  password: string;
  role: 'ADMIN' | 'USER';
}

@Injectable({
  providedIn: 'root',
})
export class UserService {
  private baseUrl = 'http://localhost:8080/api/users'; // Adjust this URL

  constructor(private http: HttpClient) {}

  // Helper method to get Authorization headers
  private getAuthHeaders(): HttpHeaders {
    const token = localStorage.getItem('jwtToken');
    return new HttpHeaders({
      Authorization: 'Bearer ' + token,
    });
  }

  // Get all users
  getAllUsers(): Observable<User[]> {
    return this.http.get<User[]>(this.baseUrl, { headers: this.getAuthHeaders() });
  }

  // Get user by ID
  getUserById(id: number): Observable<User> {
    return this.http.get<User>(`${this.baseUrl}/${id}`, { headers: this.getAuthHeaders() });
  }

  // Create a new user
  createUser(user: User): Observable<User> {
    return this.http.post<User>(this.baseUrl, user, { headers: this.getAuthHeaders() });
  }

  // Delete user by ID
  deleteUser(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`, { headers: this.getAuthHeaders() });
  }
  
  getUserWithMostLoans(): Observable<User> {
    return this.http.get<User>(`${this.baseUrl}/most-loans`, { headers: this.getAuthHeaders() });
  }

  // Search users by username (if implemented in backend)
  searchByUsername(username: string): Observable<User[]> {
    return this.http.get<User[]>(`${this.baseUrl}/search?username=${username}`, {
      headers: this.getAuthHeaders(),
    });
  }
}
