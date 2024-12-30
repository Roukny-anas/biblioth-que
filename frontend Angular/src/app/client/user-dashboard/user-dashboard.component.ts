import { Component, OnInit } from '@angular/core';
import { RouterModule } from '@angular/router';
import { Router } from '@angular/router';
@Component({
  selector: 'app-user-dashboard',
  templateUrl: './user-dashboard.component.html',
  styleUrls: ['./user-dashboard.component.css'],
  standalone: true, // Mark as standalone
  imports: [RouterModule], // Import necessary components/modules
})
export class UserDashboardComponent implements OnInit {
  userName: string = 'Guest';

  constructor(private router: Router) {}

  ngOnInit(): void {
    // Récupère le nom de l'utilisateur depuis le localStorage
    const role = localStorage.getItem('role');
    const name = localStorage.getItem('username'); // Assure-toi que le nom est stocké ici

    if (role === 'ROLE_ADMIN') {
      this.userName = 'Admin';
    } else if (name) {
      this.userName = name;
    }
  }

  logout(): void {
    // Nettoie le localStorage et redirige vers login
    localStorage.removeItem('role');
    localStorage.removeItem('username');
    this.router.navigate(['/login']);
  }
}