package isme.testporjey.ControllersTest;

import isme.testporjey.Controllers.CategoryController;
import isme.testporjey.JWT.JwtService;
import isme.testporjey.JWT.UserDetailsServiceImpl;
import isme.testporjey.Models.Category;
import isme.testporjey.Services.CategoryService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.hamcrest.Matchers.is;
import static org.mockito.ArgumentMatchers.any;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(CategoryController.class)
@AutoConfigureMockMvc
public class CategoryControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private CategoryService categoryService;
    @MockBean
    private JwtService jwtService;

    @MockBean
    private UserDetailsServiceImpl userDetailsService;

    @Test
    @WithMockUser(roles = "ADMIN")
    public void testCreateCategory() throws Exception {
        Category category = new Category();
        category.setName("Science");

        // Simulate the saveCategory method
        Mockito.when(categoryService.saveCategory(any(Category.class))).thenReturn(category);

        // Perform the POST request to create a new category
        mockMvc.perform(post("/api/categories")
                        .with(csrf())  // Include CSRF token for security
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"name\": \"Science\"}"))
                .andExpect(status().isCreated())  // Expect status code 201 (Created)
                .andExpect(jsonPath("$.name", is("Science")));  // Check that the returned category name is "Science"
    }

    // Test for getAllCategories()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetAllCategories() throws Exception {
        Category category1 = new Category();
        category1.setId(1L);
        category1.setName("Science");

        Category category2 = new Category();
        category2.setId(2L);
        category2.setName("Arts");

        List<Category> categories = Arrays.asList(category1, category2);

        Mockito.when(categoryService.getAllCategories()).thenReturn(categories);

        mockMvc.perform(get("/api/categories")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].name", is("Science")))
                .andExpect(jsonPath("$[1].name", is("Arts")));
    }
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetCategoryById() throws Exception {
        Category category = new Category();
        category.setId(1L);
        category.setName("Science");

        Mockito.when(categoryService.getCategoryById(1L)).thenReturn(Optional.of(category));

        mockMvc.perform(get("/api/categories/1")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name", is("Science")));
    }
    // Test for deleteCategory()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testDeleteCategory() throws Exception {
        mockMvc.perform(delete("/api/categories/1")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNoContent());

        Mockito.verify(categoryService, Mockito.times(1)).deleteCategory(1L);
    }

    // Test for getCategoryByName()
    @Test
    @WithMockUser(roles = "ADMIN")
    public void testGetCategoryByName() throws Exception {
        Category category = new Category();
        category.setId(1L);
        category.setName("Science");

        Mockito.when(categoryService.getCategoryByName("Science")).thenReturn(Optional.of(category));

        mockMvc.perform(get("/api/categories/search/Science")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name", is("Science")));
    }
}
