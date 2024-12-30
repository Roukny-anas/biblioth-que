import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { JwtHelperService } from '@auth0/angular-jwt';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private baseUrl = 'http://localhost:8080/api/auth'; // Update with your backend URL
  private jwtHelper = new JwtHelperService();

  constructor(private http: HttpClient) {}

  // Signup method
  signup(user: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/signup`, user);
  }

  // Signin method
  signin(authRequest: { email: string; password: string }): Observable<any> {
    return this.http.post(`${this.baseUrl}/signin`, authRequest);
  }

  getDecodedRole(token: string | null): string | null {
    if (!token) {
      console.error('Token is null or undefined.');
      return null;
    }
  
    try {
      const decodedToken = this.jwtHelper.decodeToken(token);
  
      // Extract roles from the decoded token
      const rolesArray = decodedToken?.roles || [];
      if (rolesArray.length > 0) {
        const role = rolesArray[0]?.authority || null; // Get the first role
        return role;
      } else {
        console.warn('No roles found in token.');
        return null;
      }
    } catch (error) {
      console.error('Error decoding token:', error);
      return null;
    }
  }
  
}
