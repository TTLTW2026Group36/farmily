package group36.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import group36.util.CloudinaryConfig;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

public class CloudinaryService {

    public enum MediaType {
        IMAGE("image"),
        VIDEO("video");

        private final String value;

        MediaType(String value) {
            this.value = value;
        }

        public String value() {
            return value;
        }
    }

    public static class UploadResult {
        private final String url;
        private final String publicId;
        private final MediaType type;

        public UploadResult(String url, String publicId, MediaType type) {
            this.url = url;
            this.publicId = publicId;
            this.type = type;
        }

        public String getUrl() { return url; }
        public String getPublicId() { return publicId; }
        public MediaType getType() { return type; }
    }

    public UploadResult upload(InputStream stream, int reviewId, MediaType type) throws IOException {
        Cloudinary cloudinary = CloudinaryConfig.get();
        Map<String, Object> options = ObjectUtils.asMap(
                "folder", "farmily/reviews/" + reviewId,
                "resource_type", type.value(),
                "use_filename", false,
                "unique_filename", true,
                "overwrite", false);

        byte[] bytes = readAllBytes(stream);
        Map<?, ?> result = cloudinary.uploader().upload(bytes, options);

        String secureUrl = (String) result.get("secure_url");
        String publicId = (String) result.get("public_id");
        return new UploadResult(secureUrl, publicId, type);
    }

    public void delete(String publicId, MediaType type) throws IOException {
        Cloudinary cloudinary = CloudinaryConfig.get();
        cloudinary.uploader().destroy(publicId, ObjectUtils.asMap(
                "resource_type", type.value()));
    }

    public static MediaType detectType(String contentType) {
        if (contentType == null) return null;
        if (contentType.startsWith("image/")) return MediaType.IMAGE;
        if (contentType.startsWith("video/")) return MediaType.VIDEO;
        return null;
    }

    private static byte[] readAllBytes(InputStream stream) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        byte[] data = new byte[8192];
        int n;
        while ((n = stream.read(data)) != -1) {
            buffer.write(data, 0, n);
        }
        return buffer.toByteArray();
    }
}
