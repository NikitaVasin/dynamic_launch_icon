# dynamic_launch_icon

Плагин для смены иконки приложения

## ANDROID

1. Добавить новые иконки в папку res/mipmap
2. Создать новый ```<activity-alias>``` (обязательно переносим интент фильтры с основного активити!)

```xml
<activity-alias
    android:name=".IconPremium"
    android:icon="@mipmap/ic_new_icon"
    android:exported="true"
    android:enabled="false"
    android:launchMode="singleInstance"
    android:theme="@style/LaunchTheme"
    android:targetActivity=".MainActivity">
    
    <!-- Дублируем интент фильтры основной активности ... -->

    <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
    </intent-filter>
</activity-alias>
```

3. Если необходимо красивое имя добавляем метадату

```xml
<meta-data
    android:name="dynamicIconName"
    android:value="New Icon"/>
```

4. Если необходимо отдельное превью для иконки

```xml
<meta-data
    android:name="dynamicIconPreview"
    android:resource="@drawable/premium_icon_preview"
    />
```

!ВАЖНО! Не удалять алиасы после публикации (иначе пользователи могут потерять свое приложение)

## IOS

1. Создать новую папку в проекте
2. Добавить новую иконку с @2 и @3 разрешением (можно и более детально)
3. в Info.plist добавить словарь

```plist
<key>CFBundleIcons</key> <!-- если нужно для ipad то продублировать словарь с ключем CFBundleIcons~ipad --> 
<dict>
 <key>CFBundlePrimaryIcon</key>
 <dict>
  <key>CFBundleIconName</key>
  <string></string>
  <key>CFBundleIconFiles</key>
  <array>
   <string></string>
  </array>
  <key>UIPrerenderedIcon</key>
  <false/>
 </dict>
 <key>CFBundleAlternateIcons</key> <!-- словарь в который добавляем новые иконки -->
 <dict>
  <key>NewIcon</key> <!-- имя изображения -->
  <dict>
   <key>UIPrerenderedIcon</key> <!-- ключ для того чтобы игнорировать разные разрешения -->
   <false/>
   <key>CFBundleIconFiles</key>
   <array>
    <string>second</string> <!-- обязательно дублируем имя изображения -->
   </array>
   <key>CFBundleIconName</key>
   <string>PrettyNewIconName</string> <!-- Красивое имя иконки -->
  </dict>
 </dict>
 <key>PrimaryIconName</key> <!-- (Ключ который присвоит красивое имя для основной иконки - поумолчанию имя Primary) -->
 <string>PRIMARY</string>
</dict>
```
