package isme.testporjey.ModelsTest;

import isme.testporjey.Models.Category;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

public class CategoryTest {

    @Test
    public void testCategoryConstructor() {
        Category category = new Category(1L, "Science");

        assertNotNull(category);
        assertEquals(1L, category.getId());
        assertEquals("Science", category.getName());
    }

    @Test
    public void testSettersAndGetters() {
        Category category = new Category();
        category.setId(1L);
        category.setName("Science");

        assertEquals(1L, category.getId());
        assertEquals("Science", category.getName());
    }





    @Test
    public void testEqualsAndHashCode() {
        Category category1 = new Category(1L, "Science");
        Category category2 = new Category(1L, "Science");

        assertEquals(category1, category2);
        assertEquals(category1.hashCode(), category2.hashCode());
    }
}