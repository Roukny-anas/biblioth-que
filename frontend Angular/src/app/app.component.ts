import { HttpClientModule } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { NavigationEnd, RouterModule } from '@angular/router';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { CommonModule, NgIf } from '@angular/common';
import { isPlatformBrowser } from '@angular/common';
import { PLATFORM_ID, Inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
@Component({
  selector: 'app-root',
  template: `
    <router-outlet></router-outlet>
  `,
  styleUrls: ['./app.component.css'],
  standalone: true,
  imports: [
    HttpClientModule,
    RouterModule,
    MatSidenavModule,
    MatListModule,
    CommonModule, 
    FormsModule,   
  ],
})
export class AppComponent implements OnInit {
  title(title: any) {
    throw new Error('Method not implemented.');
  }
  constructor(@Inject(PLATFORM_ID) private platformId: Object) {}

  ngOnInit() {
    // Optionnel : Débogage pour le rôle
    if (isPlatformBrowser(this.platformId)) {
      const role = localStorage.getItem('role');
      console.log('Role détecté:', role);
    }
  }
}
