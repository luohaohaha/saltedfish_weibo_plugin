package com.saltedfish.weibo.saltedfishweiboplugin;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.TextUtils;

import com.sina.weibo.sdk.WbSdk;
import com.sina.weibo.sdk.api.ImageObject;
import com.sina.weibo.sdk.api.TextObject;
import com.sina.weibo.sdk.api.WeiboMultiMessage;
import com.sina.weibo.sdk.auth.AuthInfo;
import com.sina.weibo.sdk.auth.Oauth2AccessToken;
import com.sina.weibo.sdk.auth.WbAuthListener;
import com.sina.weibo.sdk.auth.WbConnectErrorMessage;
import com.sina.weibo.sdk.auth.sso.SsoHandler;
import com.sina.weibo.sdk.share.WbShareCallback;
import com.sina.weibo.sdk.share.WbShareHandler;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * SaltedfishWeiboSharePlugin
 */
public class SaltedfishWeiboPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener, PluginRegistry.NewIntentListener {
  private Result mCurrentResult;
  private static Registrar mRegistrar;
  private SsoHandler mAuthHandler;
  private WbShareHandler mShareHandler;

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    mRegistrar = registrar;
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "saltedfish_weibo_plugin");
    channel.setMethodCallHandler(new SaltedfishWeiboPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    this.mCurrentResult = result;
    String method = call.method;
    Map<String,String> ag = (Map<String, String>) call.arguments;
    switch (method){
      case "install":
        install(ag.get("appId"),ag.get("redirectUrl"),ag.get("scope"));
        break;
      case "webAuth":
        webAuth();
        break;
      case "ssoAuth":
        ssoAuth();
        break;
      case "allInOneAuth":
        allInOneAuth();
        break;
      case "shareToWeibo":
        shareToWeibo(ag.get("title"),ag.get("content"),ag.get("imageUrl"));
        break;

    }

  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    checkAuthHandler();
    System.out.print("==========onActivityResult===========");
    mAuthHandler.authorizeCallBack(requestCode, resultCode, data);
    return false;
  }

  @Override
  public boolean onNewIntent(Intent intent) {
    checkShareHandler();
    System.out.print("==========onNewIntent===========");
    mShareHandler.doResultIntent(intent, mShareCallback);
    return false;
  }

  private WbShareCallback mShareCallback = new WbShareCallback() {
    @Override
    public void onWbShareSuccess() {
      if (null == mCurrentResult)
        return;
      System.out.print("==========onWbShareSuccess===========");
      Map<String, String> resultMap = new HashMap<String,String>();
      resultMap.put("type", "share");
      resultMap.put("resultCode", "0");
      mCurrentResult.success(resultMap);
    }

    @Override
    public void onWbShareCancel() {
      if (null == mCurrentResult)
        return;
      System.out.print("==========onWbShareCancel===========");
      Map<String, String> resultMap = new HashMap<String,String>();
      resultMap.put("type", "share");
      resultMap.put("resultCode", "-1");
      resultMap.put("resultMsg", "分享取消");
      mCurrentResult.error(null, null, resultMap);

    }

    @Override
    public void onWbShareFail() {
      if (null == mCurrentResult)
        return;
      System.out.print("==========onWbShareFail===========");
      Map<String, String> resultMap = new HashMap<String,String>();
      resultMap.put("type", "share");
      resultMap.put("resultCode", "1");
      resultMap.put("resultMsg", "分享错误");
      mCurrentResult.error(null, null, resultMap);
    }
  };


  private  WbAuthListener mAuthListener = new WbAuthListener() {
    @Override
    public void onSuccess(Oauth2AccessToken oauth2AccessToken) {
      if (null == mCurrentResult)
        return;
      System.out.print("==========onSuccess===========");
      Map<String, String> resultMap = new HashMap<String,String>();
      resultMap.put("type", "auth");
      resultMap.put("resultCode", "0");
      resultMap.put("resultMsg", oauth2AccessToken.toString());
      mCurrentResult.success(resultMap);
    }

    @Override
    public void cancel() {
      if (null == mCurrentResult)
        return;
      System.out.print("==========cancel===========");
      Map<String, String> resultMap = new HashMap<String,String>();
      resultMap.put("type", "auth");
      resultMap.put("resultCode", "-1");
      resultMap.put("resultMsg", "授权取消");
      mCurrentResult.error(null, null, resultMap);
    }

    @Override
    public void onFailure(WbConnectErrorMessage wbConnectErrorMessage) {
      if (null == mCurrentResult)
        return;
      System.out.print("==========onFailure==========="+wbConnectErrorMessage.getErrorCode()+wbConnectErrorMessage.getErrorMessage());
      Map<String, String> resultMap = new HashMap<String,String>();
      resultMap.put("type", "auth");
      resultMap.put("resultCode", wbConnectErrorMessage.getErrorCode());
      resultMap.put("resultMsg", wbConnectErrorMessage.getErrorMessage());
      mCurrentResult.error(null, null, resultMap);
    }
  };


  private void checkAuthHandler() {
    if (null == mAuthHandler) {
      mAuthHandler = new SsoHandler(mRegistrar.activity());
    }
  }

  private void checkShareHandler() {
    if (null == mShareHandler) {
      mShareHandler = new WbShareHandler(mRegistrar.activity());
      mShareHandler.registerApp();
    }
  }

  private void install(String appId, String redirectUrl, String scope) {
    boolean hasInstallSuccess = false;
    try {
      WbSdk.install(mRegistrar.context(), new AuthInfo(mRegistrar.context(), appId, redirectUrl, scope));
      hasInstallSuccess = true;
    } catch (Exception e) {

    } finally {
      if (null == mCurrentResult)
        return;
      Map<String, String> resultMap = new HashMap<String,String>();
      resultMap.put("type", "install ");
      resultMap.put("resultCode", hasInstallSuccess ? "0" : "1");
      mCurrentResult.success(resultMap);
    }
  }


  private void webAuth() {
    checkAuthHandler();
    mAuthHandler.authorizeWeb(mAuthListener);
  }

  private void ssoAuth() {
    checkAuthHandler();
    mAuthHandler.authorizeClientSso(mAuthListener);
  }

  private void allInOneAuth() {
    checkAuthHandler();
    mAuthHandler.authorize(mAuthListener);
  }

  private void shareToWeibo(String title, String content, final String imageUrl) {
    checkShareHandler();
    final WeiboMultiMessage weiboMessage = new WeiboMultiMessage();
    final ImageObject imageObject = new ImageObject();
    // 创建文本消息对象
    TextObject textObject = new TextObject();

    textObject.text = content;
    textObject.title = title;

    /*
     * WebpageObject mediaObject = new WebpageObject(); mediaObject.title = mTitle;
     * mediaObject.description = mDescription; // 设置 Bitmap 类型的图片到视频对象里 设置缩略图。
     * 注意：最终压缩过的缩略图大小不得超过 32kb。 mediaObject.setThumbImage(compressBitmap(bitmap, 32
     * * 1024)); mediaObject.actionUrl = mWebUrl; mediaObject.defaultText = mTitle;
     * weiboMessage.mediaObject = mediaObject;
     */

    weiboMessage.textObject = textObject;
    weiboMessage.imageObject = imageObject;
    if (!TextUtils.isEmpty(imageUrl)) {
      new Thread(new Runnable() {
        @Override
        public void run() {
          Bitmap bitmap = GetLocalOrNetBitmap(imageUrl);
          imageObject.setImageObject(bitmap);
          mRegistrar.activity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
              mShareHandler.shareMessage(weiboMessage, false);
            }
          });
        }
      }).start();
    } else {
      mShareHandler.shareMessage(weiboMessage, false);
    }
  }

  /**
   * Bitmap转换成byte[]并且进行压缩,压缩到不大于maxkb
   *
   * @param bitmap
   * @param maxkb
   * @return
   */
  private byte[] bmpToByteArray(Bitmap bitmap, int maxkb) {
    ByteArrayOutputStream output = new ByteArrayOutputStream();
    bitmap.compress(Bitmap.CompressFormat.JPEG, 100, output);
    int options = 100;
    while (output.toByteArray().length > maxkb && options >= 10) {
      output.reset(); //清空output
      bitmap.compress(Bitmap.CompressFormat.JPEG, options, output);//这里压缩options%，把压缩后的数据存放到output中
      options -= 10;
    }
    return output.toByteArray();
  }

  private Bitmap GetLocalOrNetBitmap(String url) {
    Bitmap bitmap = null;
    InputStream in = null;
    BufferedOutputStream out = null;
    try {
      in = new BufferedInputStream(new URL(url).openStream(), 1024);
      final ByteArrayOutputStream dataStream = new ByteArrayOutputStream();
      out = new BufferedOutputStream(dataStream, 1024);
      copy(in, out);
      out.flush();
      byte[] data = dataStream.toByteArray();
      bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
      return bitmap;
    } catch (IOException e) {
      e.printStackTrace();
      return null;
    }
  }

  private void copy(InputStream in, OutputStream out)
          throws IOException {
    byte[] b = new byte[1024];
    int read;
    while ((read = in.read(b)) != -1) {
      out.write(b, 0, read);
    }
  }
}
