# LaDun Cakes Mini Order App - Developer Notes

## 📋 Project Overview
**Project Name:** LaDun Cakes Order Management & Email System  
**Version:** 1.0  
**Created:** October 2025  
**Framework:** Vanilla HTML/CSS/JavaScript  
**Email Service:** EmailJS  
**Storage:** Browser LocalStorage  

---

## 🏗️ Architecture

### Core Files
- `mini-order-app.html` - Single-page application with embedded CSS and JavaScript
- `DEVELOPER_NOTES.md` - This documentation file

### Dependencies
- **EmailJS SDK:** `https://cdn.emailjs.com/dist/email.min.js`
- **Google Fonts:** Montserrat font family
- **No build process:** Pure vanilla implementation

---

## 🎨 Brand Identity

### Color Palette
```css
Primary Header: #5f0f40 (Dark Burgundy)
Background: #FFFFFF (Clean White)
Accent Pink: #F8C9CC (Soft Blush)
Gold Buttons: #C9A13C (Metallic Gold)
Hover Gold: #D4AF47 (Lighter Gold)
Taupe: #BFAEA1 (Neutral Secondary)
Text: #2E2E2E (Charcoal Grey)
```

### Typography
- **Font Family:** Montserrat (300, 400, 500, 600, 700 weights)
- **Logo Filter:** `filter: invert(1) brightness(2)` (white logo on dark background)

---

## 📧 EmailJS Integration

### Service Configuration
```javascript
Public Key: elytg58ftKBMdGS1G
Service ID: service_i1yme2l
Template ID 1: Collection Notices
Template ID 2: Anniversary Marketing
Account Limit: 200 emails/month (Free tier)
```

### Email Template Variables
#### Template 1 (Collection Notices)
```javascript
{
  customer_name: string,
  customer_email: string, 
  cake_type: string,
  order_details: string,
  collection_date: string,
  collection_time: string,
  to_email: string,
  reply_to: string,
  instagram_link: string,
  tiktok_link: string,
  facebook_link: string,
  google_review_link: string,
  business_name: string
}
```

#### Template 2 (Anniversary Marketing)
```javascript
{
  customer_name: string,
  customer_email: string,
  cake_type: string,
  order_details: string,
  original_collection_date: string,
  anniversary_date: string,
  to_email: string,
  reply_to: string,
  instagram_link: string,
  tiktok_link: string,
  facebook_link: string,
  google_review_link: string,
  business_name: string
}
```

### Social Media Links (Auto-formatted)
```javascript
instagram_link: '📸 Follow us on Instagram: https://www.instagram.com/laduncakes'
tiktok_link: '🎵 Watch us on TikTok: https://www.tiktok.com/@laduncakes'
facebook_link: '👍 Like us on Facebook: https://www.facebook.com/share/178PimAdRz/?mibextid=wwXIfr'
google_review_link: '⭐ Google Review: https://g.page/r/Cbv3t2r3bnosEAE/review'
```

---

## 💾 Data Management

### LocalStorage Structure
```javascript
// Email Configuration
emailConfig: {
  publicKey: string,
  serviceId: string,
  templateId: string,
  followUpTemplateId: string
}

// Orders Array
orders: [{
  id: string (timestamp-based),
  customerName: string,
  customerEmail: string,
  cakeType: string,
  orderDetails: string,
  collectionDate: string (YYYY-MM-DD),
  collectionTime: string (HH:MM),
  timestamp: number,
  thankYouSent: boolean,
  anniversarySent: boolean
}]

// Settings
testMode: boolean
```

---

## ⚙️ Core Functions

### Email Functions
```javascript
submitOrder() - Handles form submission and initial order creation
sendThankYouEmail(orderId) - Manual collection notice sending
sendAnniversaryEmail(orderId) - Manual anniversary email sending
sendAutomaticThankYouEmail(orderId) - Automated collection notices
sendAutomaticAnniversaryEmail(orderId) - Automated anniversary emails
```

### Utility Functions
```javascript
formatDate(dateString) - Formats dates for display
generateOrderId() - Creates timestamp-based IDs
showStatus(message, type) - User feedback display
loadOrders() - Retrieves orders from localStorage
saveOrders() - Persists orders to localStorage
renderOrders() - Updates UI with current orders
```

### Automation System
```javascript
checkForEmails() - Runs every 5 minutes to check for due emails
startEmailChecker() - Initializes the automation interval
```

---

## 🔄 Workflow Logic

### Order Lifecycle
1. **Order Creation:** Form submission → localStorage → UI update
2. **Collection Ready:** Manual trigger → collection notice email
3. **Order Archival:** Moves to completed orders (hidden from active view)
4. **Anniversary Follow-up:** Automatic email after 300 days (or 5 minutes in test mode)

### Email Automation
- **Interval:** 5-minute checks via `setInterval()`
- **Collection Notices:** Manual trigger only
- **Anniversary Emails:** Automatic after 300 days from collection date
- **Test Mode:** Reduces 300 days to 5 minutes for rapid testing

---

## 🧪 Testing & Development

### Test Mode Features
- Accelerated anniversary timing (5 minutes vs 300 days)
- Enabled via checkbox in configuration
- Persists in localStorage
- Useful for testing email flow

### Development Environment
- Open `mini-order-app.html` in any modern browser
- No build process required
- Browser developer tools for debugging
- Console logs available for email sending status

### Configuration Management
- Collapsible setup section in UI
- All EmailJS credentials configurable
- Test mode toggle
- Clear orders functionality for cleanup

---

## 🔧 Customization Points

### Branding Updates
1. **Colors:** Update CSS variables in `<style>` section
2. **Logo:** Replace logo URL in header
3. **Social Links:** Update URLs in email template parameter functions
4. **Business Name:** Update in template parameters

### Email Template Modifications
1. **EmailJS Dashboard:** Edit templates directly
2. **Variable Names:** Must match JavaScript parameter names
3. **New Variables:** Add to all email sending functions

### Timing Adjustments
```javascript
// Anniversary timing (line ~1175)
anniversaryDate.setDate(anniversaryDate.getDate() + 300); // Change 300 to desired days

// Check interval (line ~1220)
setInterval(checkForEmails, 5 * 60 * 1000); // 5 minutes, adjust as needed
```

---

## 🚀 Deployment

### Requirements
- Modern web browser
- Internet connection (for EmailJS API)
- EmailJS account with valid service/templates

### Setup Steps
1. Configure EmailJS account and templates
2. Update configuration in app settings
3. Test with personal email addresses
4. Deploy HTML file to web server or use locally

### Browser Compatibility
- Chrome 80+
- Firefox 75+
- Safari 13+
- Edge 80+

---

## 🐛 Troubleshooting

### Common Issues
```javascript
// EmailJS Errors
"Service ID not found" → Check EmailJS dashboard for correct service ID
"Template not found" → Verify template IDs match EmailJS templates
"Public key invalid" → Confirm public key from EmailJS account

// Email Not Sending
- Check browser console for errors
- Verify internet connection
- Confirm EmailJS monthly limit not exceeded
- Test with different email addresses

// Anniversary Emails Not Working
- Ensure browser tab stays open
- Check test mode setting
- Verify order has collection date
- Check console for automation errors
```

### Debug Mode
```javascript
// Add to console for debugging
console.log('Orders:', JSON.parse(localStorage.getItem('orders')));
console.log('Email Config:', JSON.parse(localStorage.getItem('emailConfig')));
console.log('Test Mode:', localStorage.getItem('testMode'));
```

---

## 📈 Scaling Considerations

### Current Limitations
- Browser-based storage (lost on cache clear)
- EmailJS free tier (200 emails/month)
- Single-user system
- Requires open browser for automation

### Future Enhancements
- Backend database integration
- Multi-user support
- Advanced email scheduling
- Order analytics
- Mobile app version
- Payment integration
- Inventory management

---

## 📞 Support

### EmailJS Documentation
- [EmailJS Docs](https://www.emailjs.com/docs/)
- [Template Variables](https://www.emailjs.com/docs/user-guide/dynamic-variables-templating/)
- [JavaScript SDK](https://www.emailjs.com/docs/sdk/installation/)

### Browser Developer Tools
- **Console:** Error tracking and debugging
- **Network:** Monitor EmailJS API calls
- **Application:** Inspect localStorage data
- **Sources:** JavaScript debugging with breakpoints

---

## 📝 Version History

### v1.0 (October 2025)
- Initial release
- EmailJS integration
- Manual and automatic email system
- Anniversary marketing automation
- Professional LaDun Cakes branding
- Montserrat typography
- Collection time field
- Social media link integration
- Test mode functionality

---

**Created for LaDun Cakes**  
**Developer: GitHub Copilot**  
**Last Updated: October 19, 2025**