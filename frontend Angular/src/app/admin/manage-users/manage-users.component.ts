import { Component, OnInit } from '@angular/core';
import { UserService } from '../../services/user.service';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

export interface User {
  id?: number;
  username: string;
  email: string;
  password: string;
  role: 'ADMIN' | 'USER';
}

@Component({
  selector: 'app-manage-users',
  templateUrl: './manage-users.component.html',
  styleUrls: ['./manage-users.component.css'],
  standalone: true,
  imports: [FormsModule, CommonModule],
})
export class ManageUsersComponent implements OnInit {
  users: User[] = []; // List of users
  newUser: User = {
    username: '',
    email: '',
    password: '',
    role: 'USER',
  };

  searchQuery: string = ''; // Search query

  constructor(private userService: UserService) {}

  ngOnInit(): void {
    this.loadUsers();
  }

  // Load all users
  loadUsers(): void {
    this.userService.getAllUsers().subscribe((data) => {
      this.users = data;
    });
  }

  // Add a new user
  addUser(): void {
    this.userService.createUser(this.newUser).subscribe(() => {
      this.loadUsers();
      this.resetForm();
    });
  }

  // Reset form after adding a user
  resetForm(): void {
    this.newUser = {
      username: '',
      email: '',
      password: '',
      role: 'USER',
    };
  }

  // Delete a user by ID
  deleteUser(id: number): void {
    this.userService.deleteUser(id).subscribe(() => {
      this.loadUsers();
    });
  }

  // Search users by username
  searchByUsername(): void {
    if (this.searchQuery) {
      this.userService.searchByUsername(this.searchQuery).subscribe((data) => {
        this.users = data;
      });
    } else {
      this.loadUsers(); // Reload all users if search is cleared
    }
  }
}
