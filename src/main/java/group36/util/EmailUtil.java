package group36.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {
    public static void sendEmail(String to, String subject, String content) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", FarmilyConstants.MAIL_HOST);
        props.put("mail.smtp.port", FarmilyConstants.MAIL_PORT);
        props.put("mail.smtp.auth", FarmilyConstants.MAIL_AUTH);
        props.put("mail.smtp.starttls.enable", FarmilyConstants.MAIL_STARTTLS);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FarmilyConstants.MAIL_USER, FarmilyConstants.MAIL_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FarmilyConstants.MAIL_USER));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setText(content);

        Transport.send(message);
        System.out.println("✅ Email sent successfully to: " + to);
    }
}
