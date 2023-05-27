abstract class GrxRegexUtils {
  static const singleNameAvatarRgx = r'[A-Za-z]';
  static const fullNameAvatarRgx = r'\b[A-Za-z]';
  static const emailRgx =
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
  static const numericOnlyRgx = r'[^0-9]';
}
