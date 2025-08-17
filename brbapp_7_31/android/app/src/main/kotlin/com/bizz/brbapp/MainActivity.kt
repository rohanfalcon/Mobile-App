package com.bizz.brbapp
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()
                        {

                            override fun onCreate(savedInstanceState: Bundle?) {
                                super.onCreate(savedInstanceState)

                                try {
                                    val ai = packageManager.getApplicationInfo(packageName, PackageManager.GET_META_DATA)
                                    val bundle = ai.metaData
                                    val apiKey = bundle?.getString("com.google.android.geo.API_KEY")
                                    Log.d("API_KEY_TEST", "Manifest API Key: $apiKey")
                                } catch (e: Exception) {
                                    Log.e("API_KEY_TEST", "Error reading API key from manifest", e)
                                }
                            }
                                // Optional: your custom code
}
