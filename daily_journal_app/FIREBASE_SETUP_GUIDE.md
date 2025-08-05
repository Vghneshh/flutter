# Firebase Setup Guide

## 🔧 **Current Issues & Solutions**

### **Issue 1: Missing Web App in Firebase Console**
**Problem:** Your Firebase project doesn't have a web app configured.

**Solution:**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `flutter07-1ac78`
3. Click **"Add app"** → **"Web"**
4. Register app with name: `daily-journal-web`
5. Copy the web app configuration

### **Issue 2: Firebase Services Not Enabled**
**Problem:** Authentication and Firestore might not be enabled.

**Solution:**
1. **Enable Authentication:**
   - Go to Firebase Console → Authentication
   - Click **"Get started"**
   - Enable **"Email/Password"** provider
   - Save

2. **Enable Firestore:**
   - Go to Firebase Console → Firestore Database
   - Click **"Create database"**
   - Choose **"Start in test mode"** (for development)
   - Select a location (choose closest to you)
   - Click **"Done"**

### **Issue 3: Security Rules**
**Problem:** Firestore might have restrictive rules.

**Solution:**
1. Go to Firestore Database → Rules
2. Replace with these test rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;  // WARNING: Only for development!
    }
  }
}
```

## 🚀 **Quick Fix Steps:**

### **Step 1: Add Web App to Firebase**
1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select project: `flutter07-1ac78`
3. Click **"Add app"** → **"Web"**
4. App nickname: `daily-journal-web`
5. Copy the config and update `firebase_options.dart`

### **Step 2: Enable Services**
1. **Authentication** → Enable Email/Password
2. **Firestore** → Create database in test mode

### **Step 3: Test Configuration**
After setup, test with:
```
Email: test@example.com
Password: Test123456
```

## 📋 **Current Configuration Status:**

✅ **Project ID:** `flutter07-1ac78`  
✅ **API Key:** `AIzaSyDm9xxiuj5yhetcvyDkjD54YRd_SUmf8aY`  
❌ **Web App:** Not configured  
❌ **Authentication:** May not be enabled  
❌ **Firestore:** May not be enabled  

## 🎯 **Next Steps:**

1. **Follow the setup guide above**
2. **Update the web app configuration**
3. **Test the signup again**

**Let me know once you've completed these steps!** 