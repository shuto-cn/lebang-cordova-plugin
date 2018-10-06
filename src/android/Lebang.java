package lebang;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

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
          callbackContext.success(new JSONObject(ret));
        }
      }
      callbackContext.error("can not get user");
    } catch (Exception e) {
      String err = e.getLocalizedMessage();
      callbackContext.error(err);
    }
  }

}
