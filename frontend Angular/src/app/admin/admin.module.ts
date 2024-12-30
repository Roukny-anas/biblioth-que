import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { AdminRoutingModule } from './admin-routing.module';
import { FormsModule } from '@angular/forms'; // Import FormsModule

@NgModule({
  imports: [
    AdminRoutingModule, // Import routing module
    FormsModule, // Ajoute FormsModule ici
  ],
  schemas: [CUSTOM_ELEMENTS_SCHEMA], // Allow standalone components
})
export class AdminModule {}
