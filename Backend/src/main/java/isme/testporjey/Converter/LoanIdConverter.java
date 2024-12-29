package isme.testporjey.Converter;

import isme.testporjey.Models.LoanId;
import org.springframework.core.convert.converter.Converter;

public class LoanIdConverter implements Converter<String, LoanId> {
    @Override
    public LoanId convert(String source) {
        // Extraire les valeurs de userId et bookId de la chaîne
        String[] parts = source.replace("LoanId(", "").replace(")", "").split(", ");
        Long userId = Long.parseLong(parts[0].split("=")[1]);
        Long bookId = Long.parseLong(parts[1].split("=")[1]);

        // Retourner un nouvel objet LoanId
        LoanId loanId = new LoanId();
        loanId.setUserId(userId);
        loanId.setBookId(bookId);
        return loanId;
    }
}