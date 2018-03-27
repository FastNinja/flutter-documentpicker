package com.example.documentpicker;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.OpenableColumns;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;

import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Map;
import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import java.net.URI;

/**
 * DocumentpickerPlugin
 */
public class DocumentpickerPlugin implements MethodCallHandler, ActivityResultListener {
  /**
   * Plugin registration.
   */
  private static final String TAG = DocumentpickerPlugin.class.getCanonicalName();
  private final Registrar mRegistrar;

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "documentpicker");
    final DocumentpickerPlugin instance = new DocumentpickerPlugin(registrar);
    registrar.addActivityResultListener(instance);
    channel.setMethodCallHandler(instance);
  }

  private DocumentpickerPlugin(Registrar registrar) {
    this.mRegistrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    Context context = getActiveContext();
    String filePath = (String) call.argument("url");
    Log.i(TAG, "#**#file path is "+filePath);

    String path = context.getCacheDir().getPath();
    Log.i(TAG, "#**#path2 is "+path);
    File item = new File(path+"/"+"test111.pdf");

    Uri myUri = Uri.parse(filePath);
    Log.i(TAG, "Attempting to copy!!! ");
    try {
      copy(myUri, item);
      Log.i(TAG, "File Copied!!! ");
    } catch (IOException e) {
      e.printStackTrace();
    }

    Intent myIntent = new Intent(Intent.ACTION_VIEW);
    String mime= null;
    try {
      mime = URLConnection.guessContentTypeFromStream(new FileInputStream(item));
    } catch (IOException e) {
      e.printStackTrace();
    }
    if(mime==null) mime=URLConnection.guessContentTypeFromName(item.getName());

    myIntent.setDataAndType(Uri.fromFile(item), mime);
    myIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
    Log.i(TAG, "#**#mime is "+mime);
    context.startActivity(myIntent);


    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  public void copy(Uri uri, File dst) throws IOException {
    Log.i(TAG, "1 ");
    InputStream in = mRegistrar.activity().getContentResolver().openInputStream(uri);
    Log.i(TAG, "2 ");
    try {
      OutputStream out = new FileOutputStream(dst);
      Log.i(TAG, "3 ");
      try {
        // Transfer bytes from in to out
        byte[] buf = new byte[1024];
        int len;
        while ((len = in.read(buf)) > 0) {
          out.write(buf, 0, len);
        }
      } finally {
        out.close();
      }
    } finally {
      in.close();
    }
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    return true;
  }

  private Context getActiveContext() {
    return (mRegistrar.activity() != null) ? mRegistrar.activity() : mRegistrar.context();
  }
}
