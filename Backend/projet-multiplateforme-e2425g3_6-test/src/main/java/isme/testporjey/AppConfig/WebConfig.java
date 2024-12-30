package isme.testporjey.AppConfig;

import isme.testporjey.Converter.LoanIdConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.format.FormatterRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addFormatters(FormatterRegistry registry) {
        // Enregistrer le convertisseur
        registry.addConverter(new LoanIdConverter());
    }
}