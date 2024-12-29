import { Component } from '@angular/core';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss'], // Use SCSS here
})
export class SignupComponent {
  email: string = '';
  password: string = '';
  confirmPassword: string = '';

  onSignup() {
    if (this.password !== this.confirmPassword) {
      alert('Passwords do not match!');
      return;
    }
    console.log('Signup:', { email: this.email, password: this.password });
    // Appeler un service d'inscription ici
  }
}
