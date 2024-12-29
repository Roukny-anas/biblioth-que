import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private apiUrl = 'http://votre-backend-api.com'; // Remplacez par l'URL de votre backend

  constructor(private http: HttpClient) {}

  signin(email: string, password: string) {
    return this.http.post(`${this.apiUrl}/signin`, { email, password });
  }

  signup(email: string, password: string) {
    return this.http.post(`${this.apiUrl}/signup`, { email, password });
  }
}
