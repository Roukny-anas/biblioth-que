import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AdminDashboardComponent } from './admin-dashboard/admin-dashboard.component';
import { ManageBooksComponent } from './manage-books/manage-books.component';
import { ManageUsersComponent } from './manage-users/manage-users.component';
import { StatisticsComponent } from './statistics/statistics.component';
import { ManageCategoriesComponent } from './manage-categories/manage-categories.component';

const routes: Routes = [
  {
    path: '',
    component: AdminDashboardComponent,
    children: [
      { path: 'books', component: ManageBooksComponent },
      { path: 'categories', component: ManageCategoriesComponent }, 
      { path: 'users', component: ManageUsersComponent },
      { path: 'statistics', component: StatisticsComponent },
      { path: '', redirectTo: 'statistics', pathMatch: 'full' },
    ],
  },
];



@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class AdminRoutingModule {}
