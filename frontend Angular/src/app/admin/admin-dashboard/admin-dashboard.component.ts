import { Component, OnInit } from '@angular/core';
import { RouterModule } from '@angular/router';
import { Router } from '@angular/router';

@Component({
  selector: 'app-admin-dashboard',
  templateUrl: './admin-dashboard.component.html',
  styleUrls: ['./admin-dashboard.component.css'],
  standalone: true, // Mark as standalone
  imports: [RouterModule], // Import necessary components/modules
})
export class AdminDashboardComponent implements OnInit {
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
    // Nettoie le localStorage et redirige vers la page de connexion
    localStorage.removeItem('role');
    localStorage.removeItem('username');
    localStorage.clear();
    this.router.navigate(['/login']);
  }
}
