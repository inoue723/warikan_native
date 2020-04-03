class APIPath {
  static String cost(String uid, String costId) => "users/$uid/costs/$costId";
  static String costs(String uid) => "users/$uid/costs";
  static String user(String uid) => "users/$uid";
}