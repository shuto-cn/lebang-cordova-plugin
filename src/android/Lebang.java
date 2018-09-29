package lebang;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * This class echoes a string called from JavaScript.
 */
public class Lebang extends CordovaPlugin {

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    if (action.equals("user")) {
      this.getLBUserInfo(callbackContext);
      return true;
    }
    return false;
  }

  private void getLBUserInfo(CallbackContext callbackContext) {
    try {
      Class c = Class.forName("com.vanke.wyguide.jgapi.LB");
      Object inst = c.getMethod("getInstance").invoke(null);
      if (inst != null) {
        Object obj = c.getMethod("getLBUserInfo").invoke(inst);
        if (obj != null && obj instanceof Map) {
          Map<String, Object> ret = (Map<String, Object>) obj;
          callbackContext.success(toJson(ret));
        }
      }
      callbackContext.error("can not get user");
    } catch (Exception e) {
      String err = e.getLocalizedMessage();
      callbackContext.error(err);
    }
  }


  public static String toJson(Object obj) throws IllegalAccessException, JSONException {
    JSONObject json = new JSONObject();
    Field[] fields = obj.getClass().getDeclaredFields();
    for (Field field : fields) {
      switch (getType(field.getType())) {
        case 0:
          json.put(field.getName(), (field.get(obj) == null ? "" : field.get(obj)));
          break;
        case 1:
          json.put(field.getName(), (int) (field.get(obj) == null ? 0 : field.get(obj)));
          break;
        case 2:
          json.put(field.getName(), (long) (field.get(obj) == null ? 0 : field.get(obj)));
          break;
        case 3:
          json.put(field.getName(), (float) (field.get(obj) == null ? 0 : field.get(obj)));
          break;
        case 4:
          json.put(field.getName(), (double) (field.get(obj) == null ? 0 : field.get(obj)));
          break;
        case 5:
          json.put(field.getName(), (boolean) (field.get(obj) == null ? false : field.get(obj)));
          break;
        case 6:
        case 7:
        case 8://JsonArray型
          json.put(field.getName(), (field.get(obj) == null ? null : field.get(obj)));
          break;
        case 9:
          json.put(field.getName(), new JSONArray((List<?>) field.get(obj)));
          break;
        case 10:
          json.put(field.getName(), new JSONObject((HashMap<?, ?>) field.get(obj)));
          break;
      }
    }
    return json.toString();
  }

  public static int getType(Class<?> type) {
    if (type != null && (String.class.isAssignableFrom(type) || Character.class.isAssignableFrom(type) || Character.TYPE.isAssignableFrom(type) || char.class.isAssignableFrom(type)))
      return 0;
    if (type != null && (Byte.TYPE.isAssignableFrom(type) || Short.TYPE.isAssignableFrom(type) || Integer.TYPE.isAssignableFrom(type) || Integer.class.isAssignableFrom(type) || Number.class.isAssignableFrom(type) || int.class.isAssignableFrom(type) || byte.class.isAssignableFrom(type) || short.class.isAssignableFrom(type)))
      return 1;
    if (type != null && (Long.TYPE.isAssignableFrom(type) || long.class.isAssignableFrom(type)))
      return 2;
    if (type != null && (Float.TYPE.isAssignableFrom(type) || float.class.isAssignableFrom(type)))
      return 3;
    if (type != null && (Double.TYPE.isAssignableFrom(type) || double.class.isAssignableFrom(type)))
      return 4;
    if (type != null && (Boolean.TYPE.isAssignableFrom(type) || Boolean.class.isAssignableFrom(type) || boolean.class.isAssignableFrom(type)))
      return 5;
    if (type != null && type.isArray())
      return 6;
    if (type != null && JSONArray.class.isAssignableFrom(type))
      return 8;
    if (type != null && List.class.isAssignableFrom(type))
      return 9;
    if (type != null && Map.class.isAssignableFrom(type))
      return 10;
    return 11;
  }
}
