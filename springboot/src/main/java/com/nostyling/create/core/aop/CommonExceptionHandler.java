package com.nostyling.create.core.aop;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.apache.shiro.authc.*;
import java.lang.reflect.UndeclaredThrowableException;

/**
 * @ outhor: by com.nostyling.create.core.aop
 * @ Created by shili on 2018/9/14 11:10.
 * @ 类的描述：全局的的异常拦截器（拦截所有的控制器）（带有@RequestMapping注解的方法上都会拦截）
 */
@ControllerAdvice
@Order(-1)
public class CommonExceptionHandler {
    private Logger log = LoggerFactory.getLogger(this.getClass());

    /**
     * 拦截业务异常
     */
    //@ExceptionHandler(GunsException.class)
    //@ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    //@ResponseBody
    //public ErrorTip notFount(GunsException e) {
    //    LogManager.me().executeLog(LogTaskFactory.exceptionLog(ShiroKit.getUser().getId(), e));
    //    getRequest().setAttribute("tip", e.getMessage());
    //    log.error("业务异常:", e);
    //    return new ErrorTip(e.getCode(), e.getMessage());
    //}

    /**
     * 用户未登录异常
     */
    @ExceptionHandler(AuthenticationException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public String unAuth(AuthenticationException e) {
        log.error("用户未登陆：", e);
        return "/login.html";
    }

    /**
     * 账号被冻结异常
     */
    @ExceptionHandler(LockedAccountException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public String accountLocked(LockedAccountException e, Model model) {
        model.addAttribute("tips", "账号被冻结");
        return "/login.html";
    }
    /**
     * 账号被删除异常
     */
    @ExceptionHandler(DisabledAccountException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public String disabledAccount(DisabledAccountException e, Model model) {
        model.addAttribute("tips", "账号被删除");
        return "/login.html";
    }

    /**
     * 账号不存在异常
     */
    @ExceptionHandler(UnknownAccountException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public String credentials(UnknownAccountException e, Model model) {
        model.addAttribute("tips", "账号不存在");
        return "/login.html";
    }

    /**
     * 密码错误异常
     */
    @ExceptionHandler(IncorrectCredentialsException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public String incorrectCredentials(IncorrectCredentialsException  e, Model model) {
        model.addAttribute("tips", "密码错误");
        return "/login.html";
    }

    /**
     * 验证码错误异常
     */
    //@ExceptionHandler(InvalidKaptchaException.class)
    //@ResponseStatus(HttpStatus.BAD_REQUEST)
    //public String credentials(InvalidKaptchaException e, Model model) {
    //    model.addAttribute("tips", "验证码错误");
    //    return "/login.html";
    //}

    /**
     * 无权限访问该资源异常
     */
    @ExceptionHandler(UndeclaredThrowableException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public String credentials(UndeclaredThrowableException e, Model model) {
        model.addAttribute("tip", "无权限访问该资源/功能");
        log.error("无权限访问该资源/功能!", e.getMessage());
        return "/login.html";
    }

    /**
     * 拦截未知的运行时异常
     */
    @ExceptionHandler(RuntimeException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ResponseBody
    public Model notFount(RuntimeException e, Model model) {
        model.addAttribute("tip", "服务器未知运行时异常");
        log.error("运行时异常:", e);
        return model;
    }

}
