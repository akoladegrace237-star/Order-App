# 🔧 Google Sheets Cloud Sync Setup Guide

This guide will help you set up cloud sync for your LaDun Cakes Order App so your data is always backed up and accessible from any device.

## Step 1: Create the Google Sheet

1. Go to [Google Sheets](https://sheets.google.com)
2. Click **+ Blank** to create a new spreadsheet
3. Name it: `LaDun Cakes Orders Database`
4. Rename the first sheet tab to: `Orders` (click on "Sheet1" at bottom and rename)
5. Add these headers in Row 1 (copy exactly):

```
id | customerName | customerPhone | customerEmail | cakeType | orderDetails | collectionDate | collectionTime | orderDate | timestamp | emailSent | thankYouSent | thankYouSentTime | anniversaryDate | anniversarySent | anniversarySentDate | anniversarySkipped | anniversarySkippedDate
```

6. Create a second sheet tab called: `Config`
7. In the Config sheet, add in Row 1:
```
key | value
```

## Step 2: Create the Google Apps Script

1. In your Google Sheet, click **Extensions** → **Apps Script**
2. Delete any code in the editor
3. Copy and paste this entire script:

```javascript
// Google Apps Script for LaDun Cakes Order Sync
// This creates a web API for your order app

const SHEET_NAME = 'Orders';
const CONFIG_SHEET = 'Config';

// Handle GET requests (fetch orders)
function doGet(e) {
  try {
    const action = e.parameter.action || 'getOrders';
    let result;
    
    if (action === 'getOrders') {
      result = getAllOrders();
    } else if (action === 'getConfig') {
      result = getConfig();
    } else {
      result = { error: 'Unknown action' };
    }
    
    return createResponse(result);
  } catch (error) {
    return createResponse({ error: error.message });
  }
}

// Handle POST requests (save orders)
function doPost(e) {
  try {
    const data = JSON.parse(e.postData.contents);
    const action = data.action || 'saveOrders';
    let result;
    
    if (action === 'saveOrders') {
      result = saveAllOrders(data.orders);
    } else if (action === 'saveConfig') {
      result = saveConfig(data.config);
    } else if (action === 'syncOrders') {
      result = syncOrders(data.orders);
    } else {
      result = { error: 'Unknown action' };
    }
    
    return createResponse(result);
  } catch (error) {
    return createResponse({ error: error.message });
  }
}

// Get all orders from sheet
function getAllOrders() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(SHEET_NAME);
  const data = sheet.getDataRange().getValues();
  
  if (data.length <= 1) {
    return { orders: [], lastSync: new Date().toISOString() };
  }
  
  const headers = data[0];
  const orders = [];
  
  for (let i = 1; i < data.length; i++) {
    const row = data[i];
    if (!row[0]) continue; // Skip empty rows
    
    const order = {};
    headers.forEach((header, index) => {
      let value = row[index];
      // Convert boolean strings
      if (value === 'TRUE' || value === true) value = true;
      else if (value === 'FALSE' || value === false) value = false;
      else if (value === '') value = null;
      order[header] = value;
    });
    orders.push(order);
  }
  
  return { orders: orders, lastSync: new Date().toISOString() };
}

// Save all orders (replaces everything)
function saveAllOrders(orders) {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(SHEET_NAME);
  
  // Clear existing data except headers
  const lastRow = sheet.getLastRow();
  if (lastRow > 1) {
    sheet.getRange(2, 1, lastRow - 1, sheet.getLastColumn()).clearContent();
  }
  
  if (!orders || orders.length === 0) {
    return { success: true, count: 0, lastSync: new Date().toISOString() };
  }
  
  // Get headers
  const headers = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0].filter(h => h);
  
  // Prepare data rows
  const rows = orders.map(order => {
    return headers.map(header => {
      const value = order[header];
      if (value === null || value === undefined) return '';
      if (typeof value === 'boolean') return value ? 'TRUE' : 'FALSE';
      return value;
    });
  });
  
  // Write data
  if (rows.length > 0) {
    sheet.getRange(2, 1, rows.length, headers.length).setValues(rows);
  }
  
  return { success: true, count: orders.length, lastSync: new Date().toISOString() };
}

// Smart sync - merge local and cloud orders
function syncOrders(localOrders) {
  const cloudData = getAllOrders();
  const cloudOrders = cloudData.orders;
  
  // Create a map of cloud orders by ID
  const cloudMap = new Map();
  cloudOrders.forEach(order => cloudMap.set(order.id, order));
  
  // Merge: local orders take priority for conflicts
  const mergedOrders = [...localOrders];
  
  // Add cloud orders that don't exist locally
  cloudOrders.forEach(cloudOrder => {
    const existsLocally = localOrders.some(local => local.id === cloudOrder.id);
    if (!existsLocally) {
      mergedOrders.push(cloudOrder);
    }
  });
  
  // Save merged orders back to cloud
  saveAllOrders(mergedOrders);
  
  return { 
    success: true, 
    orders: mergedOrders, 
    localCount: localOrders.length,
    cloudCount: cloudOrders.length,
    mergedCount: mergedOrders.length,
    lastSync: new Date().toISOString()
  };
}

// Get config from Config sheet
function getConfig() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(CONFIG_SHEET);
  if (!sheet) return { config: {} };
  
  const data = sheet.getDataRange().getValues();
  const config = {};
  
  for (let i = 1; i < data.length; i++) {
    if (data[i][0]) {
      config[data[i][0]] = data[i][1];
    }
  }
  
  return { config: config };
}

// Save config to Config sheet
function saveConfig(config) {
  let sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(CONFIG_SHEET);
  if (!sheet) {
    sheet = SpreadsheetApp.getActiveSpreadsheet().insertSheet(CONFIG_SHEET);
    sheet.getRange(1, 1, 1, 2).setValues([['key', 'value']]);
  }
  
  // Clear and rewrite
  const lastRow = sheet.getLastRow();
  if (lastRow > 1) {
    sheet.getRange(2, 1, lastRow - 1, 2).clearContent();
  }
  
  const rows = Object.entries(config).map(([key, value]) => [key, value]);
  if (rows.length > 0) {
    sheet.getRange(2, 1, rows.length, 2).setValues(rows);
  }
  
  return { success: true };
}

// Create CORS-enabled JSON response
function createResponse(data) {
  return ContentService
    .createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);
}
```

## Step 3: Deploy the Script as Web App

1. Click **Deploy** → **New deployment**
2. Click the gear icon ⚙️ next to "Select type" → choose **Web app**
3. Fill in:
   - Description: `LaDun Cakes Order API`
   - Execute as: **Me**
   - Who has access: **Anyone**
4. Click **Deploy**
5. Click **Authorize access** and allow permissions
6. **COPY THE WEB APP URL** - it looks like:
   ```
   https://script.google.com/macros/s/AKfycbx.../exec
   ```
7. Save this URL! You'll need it for the app.

## Step 4: Configure Your App

1. Open the LaDun Cakes app
2. Click **Show Settings** or **Show Config**
3. Paste your Web App URL in the **Google Sheets API URL** field
4. Click **Test Connection** to verify it works
5. Click **Sync Now** to upload your existing orders

## 🎉 Done!

Your app will now:
- ✅ Automatically sync orders to Google Sheets
- ✅ Work on any device with the same URL
- ✅ Keep offline backup in localStorage
- ✅ Show sync status indicator
- ✅ Allow manual sync anytime

## Troubleshooting

**"Authorization required" error:**
- Re-deploy the script and authorize again

**"Cannot read property" error:**
- Make sure sheet is named exactly `Orders` 
- Make sure headers match exactly

**Data not syncing:**
- Check the Web App URL is correct
- Make sure you deployed as "Anyone" can access

**To view your data:**
- Open your Google Sheet anytime to see all orders!
