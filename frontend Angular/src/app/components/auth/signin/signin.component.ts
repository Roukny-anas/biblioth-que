import { Component } from '@angular/core';

@Component({
  selector: 'app-signin',
  templateUrl: './signin.component.html',
  styleUrls: ['./signin.component.scss'], // Use SCSS here
})
export class SigninComponent {
  email: string = '';
  password: string = '';

  onSignin() {
    console.log('Signin:', { email: this.email, password: this.password });
    // Appeler un service d'authentification ici
  }
}
