package com.kyc.app.controller;

import jakarta.servlet.http.HttpServletResponse;

public class HxTrigger {

    public enum Toast { success, error, warning, info }

    public static void toast(HttpServletResponse response, Toast type, String message) {
        response.setHeader("HX-Trigger",
                "{\"showtoast\":{\"type\":\"%s\",\"message\":\"%s\"}}".formatted(type, message));
    }
}
