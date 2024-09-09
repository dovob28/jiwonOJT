package com.example.jiwontest;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@MapperScan
@SpringBootApplication
public class JiwonTestApplication {

    public static void main(String[] args) {
        SpringApplication.run(JiwonTestApplication.class, args);
    }

}
