package services;

import dao.UserDAO;
import models.User;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;
import java.util.UUID;

public class UserService {

    private final UserDAO userDAO = new UserDAO();

    public User login(String username, String password) {
        return userDAO.login(username, password);
    }

    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    public List<User> searchUserByName(String keyword) {
        return userDAO.searchUserByName(keyword);
    }

    public User findById(Integer userId) {
        return userDAO.findById(userId);
    }

    public User findByUsername(String username) {
        return userDAO.findByUsername(username);
    }

    public User findByEmail(String email) {
        return userDAO.findByEmail(email);
    }

    /**
     * Register a new user with role "user".
     * Returns the persisted User with verificationCode and verificationToken set.
     */
    public User register(String username, String password,
                         String name, String gender, LocalDate dateOfBirth,
                         String phone, String email) {
        validateUsername(username);
        if (password == null || password.length() < 3) {
            throw new IllegalArgumentException("Password must be at least 3 characters");
        }
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Full name is required");
        }
        if (gender == null || (!"male".equals(gender) && !"female".equals(gender) && !"other".equals(gender))) {
            throw new IllegalArgumentException("Gender must be male, female, or other");
        }
        if (dateOfBirth == null) {
            throw new IllegalArgumentException("Date of birth is required");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email is required");
        }
        if (findByUsername(username) != null) {
            throw new IllegalArgumentException("Username already exists");
        }
        if (findByEmail(email.trim()) != null) {
            throw new IllegalArgumentException("Email already registered");
        }
        User user = new User(username.trim(), password, "user",
                             name.trim(), gender, dateOfBirth,
                             (phone != null && !phone.trim().isEmpty()) ? phone.trim() : null,
                             email.trim());
        user.setVerified(false);
        applyNewVerification(user);
        userDAO.insertUser(user);
        return user;
    }

    /** Generate a new 6-digit code + UUID token valid for 24 hours and save to DB. */
    public User refreshVerification(String email) {
        User user = findByEmail(email);
        if (user == null) throw new IllegalArgumentException("Email not found");
        if (user.isVerified()) throw new IllegalArgumentException("Account is already verified");
        applyNewVerification(user);
        userDAO.updateUser(user);
        return user;
    }

    /** Verify account using the 6-digit code sent to the user's email. */
    public boolean verifyByCode(String email, String code) {
        User user = findByEmail(email);
        if (user == null || user.isVerified()) return false;
        if (code == null || !code.equals(user.getVerificationCode())) return false;
        if (user.getVerificationExpiry() == null || LocalDateTime.now().isAfter(user.getVerificationExpiry())) return false;
        clearVerification(user);
        userDAO.updateUser(user);
        return true;
    }

    /** Verify account using the one-click token link from the email. */
    public boolean verifyByToken(String token) {
        User user = userDAO.findByVerificationToken(token);
        if (user == null || user.isVerified()) return false;
        if (user.getVerificationExpiry() == null || LocalDateTime.now().isAfter(user.getVerificationExpiry())) return false;
        clearVerification(user);
        userDAO.updateUser(user);
        return true;
    }

    private void applyNewVerification(User user) {
        String code = String.format("%06d", new Random().nextInt(1_000_000));
        String token = UUID.randomUUID().toString().replace("-", "");
        user.setVerificationCode(code);
        user.setVerificationToken(token);
        user.setVerificationExpiry(LocalDateTime.now().plusHours(24));
    }

    private void clearVerification(User user) {
        user.setVerified(true);
        user.setVerificationCode(null);
        user.setVerificationToken(null);
        user.setVerificationExpiry(null);
    }

    /**
     * Admin: create a user with any role.
     */
    public void createUser(String username, String password, String role,
                           String name, String gender, LocalDate dateOfBirth,
                           String phone, String email) {
        validateUserInput(username, password, role);
        validateProfileInput(name, gender, dateOfBirth, email);
        if (findByUsername(username) != null) {
            throw new IllegalArgumentException("Username already exists");
        }
        if (findByEmail(email.trim()) != null) {
            throw new IllegalArgumentException("Email already registered");
        }
        userDAO.insertUser(new User(username.trim(), password, role.trim().toLowerCase(),
                name.trim(), gender, dateOfBirth,
                (phone != null && !phone.trim().isEmpty()) ? phone.trim() : null,
                email.trim()));
    }

    /**
     * Admin: update any user.
     */
    public void updateUser(Integer userId, String username, String password, String role,
                           String name, String gender, LocalDate dateOfBirth,
                           String phone, String email) {
        if (userId == null) throw new IllegalArgumentException("User ID is required");
        validateUserInput(username, password, role);
        validateProfileInput(name, gender, dateOfBirth, email);
        User existing = findById(userId);
        if (existing == null) throw new IllegalArgumentException("User not found");
        User byUsername = findByUsername(username.trim());
        if (byUsername != null && !byUsername.getUserId().equals(userId)) {
            throw new IllegalArgumentException("Username already exists");
        }
        User byEmail = findByEmail(email.trim());
        if (byEmail != null && !byEmail.getUserId().equals(userId)) {
            throw new IllegalArgumentException("Email already registered");
        }
        existing.setUsername(username.trim());
        existing.setPassword(password);
        existing.setRole(role.trim().toLowerCase());
        existing.setName(name.trim());
        existing.setGender(gender);
        existing.setDateOfBirth(dateOfBirth);
        existing.setPhone((phone != null && !phone.trim().isEmpty()) ? phone.trim() : null);
        existing.setEmail(email.trim());
        userDAO.updateUser(existing);
    }

    /**
     * User: update own profile (role unchanged).
     */
    public void updateOwnProfile(Integer userId, String username, String password,
                                  String name, String gender, LocalDate dateOfBirth,
                                  String phone, String email) {
        if (userId == null) throw new IllegalArgumentException("User ID is required");
        validateUsername(username);
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }
        validateProfileInput(name, gender, dateOfBirth, email);
        User existing = findById(userId);
        if (existing == null) throw new IllegalArgumentException("User not found");
        User byUsername = findByUsername(username.trim());
        if (byUsername != null && !byUsername.getUserId().equals(userId)) {
            throw new IllegalArgumentException("Username already exists");
        }
        User byEmail = findByEmail(email.trim());
        if (byEmail != null && !byEmail.getUserId().equals(userId)) {
            throw new IllegalArgumentException("Email already registered");
        }
        existing.setUsername(username.trim());
        existing.setPassword(password);
        existing.setName(name.trim());
        existing.setGender(gender);
        existing.setDateOfBirth(dateOfBirth);
        existing.setPhone((phone != null && !phone.trim().isEmpty()) ? phone.trim() : null);
        existing.setEmail(email.trim());
        userDAO.updateUser(existing);
    }

    /**
     * User deletes their own account (self-deletion allowed).
     */
    public void deleteOwnAccount(Integer userId) {
        if (userId == null) throw new IllegalArgumentException("User ID is required");
        userDAO.deleteUser(userId);
    }

    /**
     * Delete user, preventing self-deletion.
     */
    public void deleteUser(Integer userId, Integer currentUserId) {
        if (userId == null) throw new IllegalArgumentException("User ID is required");
        if (currentUserId != null && currentUserId.equals(userId)) {
            throw new IllegalArgumentException("You cannot delete yourself");
        }
        userDAO.deleteUser(userId);
    }

    // ----------------------------------------------------------------
    // Password reset methods
    // ----------------------------------------------------------------

    /**
     * Initiates password reset process. Generates a reset token valid for 30 minutes.
     * @return The User object with reset token set (null if email not found)
     */
    public User initiatePasswordReset(String email) {
        User user = findByEmail(email);
        if (user == null) return null;

        String token = UUID.randomUUID().toString().replace("-", "");
        user.setResetToken(token);
        user.setResetTokenExpiry(LocalDateTime.now().plusMinutes(30));
        userDAO.updateUser(user);
        return user;
    }

    /**
     * Validates reset token and checks expiry.
     * @return The User if token is valid, null otherwise
     */
    public User validateResetToken(String token) {
        User user = userDAO.findByResetToken(token);
        if (user == null) return null;
        if (user.getResetTokenExpiry() == null || LocalDateTime.now().isAfter(user.getResetTokenExpiry())) {
            return null;
        }
        return user;
    }

    /**
     * Resets password and clears reset token.
     * @return true if successful, false if token invalid/expired
     */
    public boolean resetPassword(String token, String newPassword) {
        User user = validateResetToken(token);
        if (user == null) return false;

        user.setPassword(newPassword);
        user.setResetToken(null);
        user.setResetTokenExpiry(null);
        userDAO.updateUser(user);
        return true;
    }

    private void validateProfileInput(String name, String gender, LocalDate dateOfBirth, String email) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Full name is required");
        }
        if (gender == null || (!"male".equals(gender) && !"female".equals(gender) && !"other".equals(gender))) {
            throw new IllegalArgumentException("Gender must be male, female, or other");
        }
        if (dateOfBirth == null) {
            throw new IllegalArgumentException("Date of birth is required");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email is required");
        }
    }

    private void validateUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username is required");
        }
    }

    private void validateUserInput(String username, String password, String role) {
        validateUsername(username);
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }
        if (role == null || role.trim().isEmpty()) {
            throw new IllegalArgumentException("Role is required");
        }
        String r = role.trim().toLowerCase();
        if (!"admin".equals(r) && !"user".equals(r)) {
            throw new IllegalArgumentException("Role must be 'admin' or 'user'");
        }
    }
}
