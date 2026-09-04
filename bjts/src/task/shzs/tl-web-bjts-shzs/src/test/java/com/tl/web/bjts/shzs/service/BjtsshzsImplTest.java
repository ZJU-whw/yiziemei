package com.tl.web.bjts.shzs.service;

import com.tl.redis.shiro.PasswordManger;
import com.tl.web.bjts.shzs.controller.LoginController;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;


/**
 * 说明：${DESCRIPTION}
 * 作者：王兆阳
 * 日期：2017-05-16
 **/
@RunWith(SpringRunner.class)
@WebMvcTest(LoginController.class)
public class BjtsshzsImplTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserService userService;


    @Test
    public void test() throws Exception{
        this.mockMvc
                .perform((post("/login"))
                        .content("{\"czryDm\":\"01KFXY\",\"password\":\"1330191\"}")
                        .accept(MediaType.parseMediaType("application/json;charset=UTF-8"))
                )
                .andExpect(content().contentType("application/json;charset=UTF-8"))
                .andDo(print());
    }

    @Test
    public void encrypt(){
        System.out.println(PasswordManger.instance().encryptPassword("gs000000","tl-soft"));
    }
}
