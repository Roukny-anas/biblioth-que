import { Component } from '@angular/core';
import { AuthService } from '../../services/auth.service';
import { Router, RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
})
export class LoginComponent {
  authRequest = {
    email: '',
    password: '',
  };
  errorMessage: string | null = null;

  constructor(private authService: AuthService, private router: Router) {}

  onLogin() {
    this.authService.signin(this.authRequest).subscribe({
      next: (response: any) => {
        console.log('Login Response:', response); // Debug the response object
  
        const token = response.token;
        localStorage.setItem('jwtToken', token);
  
        if (response.userId) {
          localStorage.setItem('userId', response.userId.toString());
        } else {
          console.error('userId is missing in the response.');
          alert('Login failed: Unable to retrieve user ID.');
          return;
        }
  
        // Decode the role
        const role = this.authService.getDecodedRole(token);
        console.log('Decoded Role:', role);
  
        if (role === 'ROLE_ADMIN') {
          this.router.navigate(['/admin']);
        } else if (role === 'ROLE_USER') {
          this.router.navigate(['/client']);
        } else {
          console.error('Role not recognized or is null.');
          alert('Unable to determine user role. Please contact support.');
        }
      },
      error: (error: any) => {
        console.error('Login Error:', error);
        this.errorMessage = 'Invalid email or password.';
      },
    });
  }
  
  
  
  
  
}
