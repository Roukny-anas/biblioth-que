class LoanId {
  final int userId;
  final int bookId;

  LoanId({
    required this.userId,
    required this.bookId,
  });

  factory LoanId.fromJson(Map<String, dynamic> json) {
    return LoanId(
      userId: json['userId'],
      bookId: json['bookId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bookId': bookId,
    };
  }
}

class Loan {
  final LoanId id;
  final String? photo;
  final Map<String, dynamic> user;
  final Map<String, dynamic> book;
  final DateTime loanDate;
  final DateTime returnDate;
  final bool isReturned;

  Loan({
    required this.id,
    this.photo,
    required this.user,
    required this.book,
    required this.loanDate,
    required this.returnDate,
    required this.isReturned,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: LoanId.fromJson(json['id']),
      photo: json['photo'],
      user: json['user'],
      book: json['book'],
      loanDate: DateTime.parse(json['loanDate']),
      returnDate: DateTime.parse(json['returnDate']),
      isReturned: json['isReturned'] ?? false, // Default to false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      if (photo != null) 'photo': photo,
      'user': user,
      'book': book,
      'loanDate': loanDate.toIso8601String(),
      'returnDate': returnDate.toIso8601String(),
      'isReturned': isReturned,
    };
  }
}