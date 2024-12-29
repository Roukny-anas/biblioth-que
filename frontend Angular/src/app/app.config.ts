import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';

import { AppComponent } from './app.component';
import { HeaderComponent } from './components/header/header.component';
import { SigninComponent } from './components/auth/signin/signin.component';
import { SignupComponent } from './components/auth/signup/signup.component';
import { appRoutes } from './app.routes';

@NgModule({
  declarations: [
    AppComponent, // Composant principal
    HeaderComponent, // Composant Header
    SigninComponent, // Composant Signin
    SignupComponent, // Composant Signup
  ],
  imports: [
    BrowserModule,
    FormsModule,
    RouterModule.forRoot(appRoutes), // Configuration des routes
  ],
  providers: [],
  bootstrap: [AppComponent], // Composant à démarrer
})
export class AppModule {}
