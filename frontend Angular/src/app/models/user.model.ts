import { Loan } from './loan.model';
import { Role } from './role';

export interface User {
  id: number;
  username: string;
  email: string;
  password: string;
  role: Role;
  loanHistory?: Loan[]; // Optional field to avoid unnecessary data load
}
