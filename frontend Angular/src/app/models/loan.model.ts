import { LoanId } from './loan-id.model';
import { User } from './user.model';
import { Book } from './book.model';

export interface Loan {
  id: LoanId;
  user: User;
  book: Book;
  loanDate: string; // Using ISO string format for dates
  returnDate: string; // Using ISO string format for dates
  isReturned: boolean;
}
