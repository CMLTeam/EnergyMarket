package com.cmlteam.energymarket.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Controller
public class MainController {
    @RequestMapping("/")
    public void root(HttpServletResponse response) throws IOException {
        response.sendRedirect("/login.html");
    }
}
