import { Loan } from './loan.model';

export interface Book {
  id: number;
  title: string;
  author: string;
  type: string;
  description: string;
  availableCopies: number;
  loans?: Loan[]; // Optional field to prevent circular dependencies
}
