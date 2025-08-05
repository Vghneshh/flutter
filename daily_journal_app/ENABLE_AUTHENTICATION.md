# Enable Firebase Authentication

## 🔧 **Step 1: Enable Authentication**

1. **Go to Firebase Console:**
   - Open [Firebase Console](https://console.firebase.google.com/)
   - Select project: `flutter07-1ac78`

2. **Enable Authentication:**
   - Click **"Authentication"** in the left sidebar
   - Click **"Get started"**
   - Go to **"Sign-in method"** tab
   - Click **"Email/Password"**
   - **Enable** it
   - Click **"Save"**

## 🔧 **Step 2: Enable Billing (Optional for Firestore)**

**Option A: Enable Billing**
1. Click the link: `https://console.developers.google.com/billing/enable?project=flutter07-1ac78`
2. Add a billing account
3. Then create Firestore database

**Option B: Use Authentication Only (Recommended for now)**
- The app will work with just Authentication
- User data will be stored locally
- Firestore can be added later

## 🧪 **Test the Signup**

After enabling Authentication, test with:
```
Full Name: "John Doe"
Email: "john.doe@test.com"
Password: "Test123456"
Confirm Password: "Test123456"
```

## ✅ **What Will Work:**

✅ **User Registration** - Users can create accounts  
✅ **User Login** - Users can sign in  
✅ **Authentication** - Firebase Auth will work  
⚠️ **Data Storage** - Will work locally (Firestore optional)  

## 🎯 **Next Steps:**

1. **Enable Authentication** in Firebase Console
2. **Test the signup** with the credentials above
3. **Check if it works** - should create user account successfully

**The app should now work for basic authentication!** 