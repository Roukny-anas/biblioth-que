import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./user-dashboard/user-dashboard.component').then(m => m.UserDashboardComponent),
    children: [
      { 
        path: 'catalog', 
        loadComponent: () => import('./catalog/catalog.component').then(m => m.CatalogComponent) 
      },
      { 
        path: 'loans', 
        loadComponent: () => import('./loans/loans.component').then(m => m.LoansComponent) 
      },
      { 
        path: 'history', 
        loadComponent: () => import('./history/history.component').then(m => m.HistoryComponent) 
      },
      { path: '', redirectTo: 'catalog', pathMatch: 'full' },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ClientRoutingModule {}
