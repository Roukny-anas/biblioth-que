package isme.testporjey.ModelsTest;

import isme.testporjey.Models.Loan;
import isme.testporjey.Models.Role;
import isme.testporjey.Models.User;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static isme.testporjey.Models.Role.USER;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class UserTest {

    @Test
    public void testValues() {
        User user = new User();
        user.setId(1L);
        user.setUsername("youssef");
        user.setEmail("youssef@gmail.com");
        user.setRole(USER);
        user.setPassword("password123");

        assertEquals(1L, user.getId());
        assertEquals("youssef", user.getUsername());
        assertEquals("youssef@gmail.com", user.getEmail());
        assertEquals(USER, user.getRole());
        assertEquals("password123", user.getPassword());
    }
    @Test
    public void testLoanHistory() {
        User user = new User();
        List<Loan> loans = new ArrayList<>();
        Loan loan = new Loan();
        loans.add(loan);
        user.setLoanHistory(loans);

        assertEquals(1, user.getLoanHistory().size());
        assertEquals(loan, user.getLoanHistory().get(0));
    }
    @Test
    public void testToString() {
        User user = new User();
        user.setId(1L);
        user.setUsername("youssef");
        user.setEmail("youssef@gmail.com");
        user.setPassword("password123");
        user.setRole(USER);

        String expected = "User(id=1, username=youssef, email=youssef@gmail.com, password=password123, role=USER, loanHistory=null)";
        assertEquals(expected, user.toString());
    }
    @Test
    public void testEqualsAndHashCode() {
        User user1 = new User();
        user1.setId(1L);
        user1.setUsername("youssef");
        user1.setEmail("youssef@gmail.com");
        user1.setPassword("password123");
        user1.setRole(USER);

        User user2 = new User();
        user2.setId(1L);
        user2.setUsername("youssef");
        user2.setEmail("youssef@gmail.com");
        user2.setPassword("password123");
        user2.setRole(USER);

        assertEquals(user1, user2);
        assertEquals(user1.hashCode(), user2.hashCode());
    }

}
