package group36.util;

import com.resend.Resend;
import com.resend.services.emails.model.CreateEmailOptions;
import com.resend.services.emails.model.CreateEmailResponse;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class EmailUtil {

    private static final ExecutorService EMAIL_EXECUTOR = Executors.newFixedThreadPool(4);

    public static void sendEmail(String to, String subject, String content) throws Exception {
        Resend resend = new Resend(FarmilyConstants.RESEND_API_KEY.trim());

        CreateEmailOptions params = CreateEmailOptions.builder()
                .from("onboarding@resend.dev")
                .to(to)
                .subject(subject)
                .html(content)
                .build();

        CreateEmailResponse data = resend.emails().send(params);
        System.out.println("Email sent successfully via Resend. ID: " + data.getId());
    }

    public static void sendEmailAsync(String to, String subject, String content) {
        EMAIL_EXECUTOR.submit(() -> {
            try {
                sendEmail(to, subject, content);
            } catch (Exception e) {
                System.err.println("[EmailUtil] Async email to " + to + " failed: " + e.getMessage());
            }
        });
    }
}
