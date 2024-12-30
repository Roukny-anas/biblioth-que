import { Component } from '@angular/core';
import { AuthService } from '../../services/auth.service';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css'],
})
export class RegisterComponent {
  user = {
    username: '',
    email: '',
    password: '',
    role: 'USER', // Default role is USER
  };

  errorMessage: string | null = null;

  constructor(private authService: AuthService, private router: Router) {}

  onRegister() {
    if (this.user.email.endsWith('@admin.ma')) {
      this.user.role = 'ADMIN';
    } else {
      this.user.role = 'USER';
    }
  
    this.authService.signup(this.user).subscribe({
      next: (response) => {
        alert(response.message); // Display the success message
        this.router.navigate(['/dashboard']); // Redirect to login page
      },
      error: (error) => {
        this.errorMessage = 'Une erreur est survenue lors de l’inscription.';
        console.error(error);
      },
    });
  }
  
  
}