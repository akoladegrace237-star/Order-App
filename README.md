# 🎂 LaDun Cakes Order Management App

A professional cake order management system with automated email notifications and customer retention features.

![LaDun Cakes](https://via.placeholder.com/800x200/5f0f40/ffffff?text=LaDun+Cakes+Order+Management)

## ✨ Features

### 📧 Email Automation
- **EmailJS Integration** - Professional email notifications
- **Collection Notices** - Manual trigger when cakes are ready
- **Anniversary Marketing** - Automatic follow-up emails after 300 days
- **Social Media Integration** - Branded Instagram, TikTok, Facebook, and Google Review links

### 🎨 Professional Design
- **Brand-Consistent Styling** - Custom LaDun Cakes color palette
- **Montserrat Typography** - Modern, elegant font family
- **Responsive Design** - Works on desktop and mobile
- **Intuitive Interface** - Easy-to-use order management

### ⚙️ Smart Features
- **Local Storage** - Browser-based data persistence
- **Test Mode** - Rapid anniversary email testing (5 minutes vs 300 days)
- **Order Tracking** - Complete order lifecycle management
- **Configuration Management** - Collapsible setup section

## 🚀 Quick Start

### Prerequisites
- Modern web browser
- EmailJS account (free tier available)
- Internet connection

### Installation
1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/ladun-cakes-order-app.git
   ```

2. **Open the app:**
   - Open `mini-order-app.html` in your web browser
   - No build process required!

3. **Configure EmailJS:**
   - Sign up at [EmailJS.com](https://www.emailjs.com/)
   - Create two email templates (collection + anniversary)
   - Enter your credentials in the app's configuration section

## 📋 Usage

### Setting Up EmailJS Templates

#### Template 1: Collection Notice
```html
Subject: Your {{cake_type}} Awaits 🤍

Dear {{customer_name}},

Your {{cake_type}} has been lovingly handcrafted and will be ready for collection on {{collection_date}} at {{collection_time}}.

Order Details:
• Cake Type: {{cake_type}}
• Collection Date: {{collection_date}}
• Collection Time: {{collection_time}}
• Special Requests: {{order_details}}

{{instagram_link}}
{{tiktok_link}}
{{facebook_link}}
{{google_review_link}}

With love,
LaDun Cakes
```

#### Template 2: Anniversary Marketing
```html
Subject: A Sweet Reminder - Your Special Occasion is Coming Up ✨

Dear {{customer_name}},

It was such a joy to create your {{cake_type}} on {{original_collection_date}}, and we'd love to be part of your celebrations again!

{{instagram_link}}
{{tiktok_link}}
{{facebook_link}}

With love and sweet wishes,
LaDun Cakes
```

### Managing Orders
1. **Create Order** - Fill out customer details and cake information
2. **Send Collection Notice** - Click "Cake is Ready" when order is complete
3. **Automatic Follow-up** - System sends anniversary emails after 300 days

## 🛠️ Configuration

### EmailJS Setup
- **Public Key:** Your EmailJS public key
- **Service ID:** Your EmailJS service identifier
- **Template ID:** Collection notice template
- **Anniversary Template ID:** Marketing follow-up template

### Customization
- **Colors:** Update CSS variables in the `<style>` section
- **Social Links:** Modify URLs in JavaScript email functions
- **Timing:** Adjust anniversary delay (default: 300 days)

## 📧 Email Variables

### Available Template Variables
- `{{customer_name}}` - Customer's name
- `{{customer_email}}` - Customer's email
- `{{cake_type}}` - Type of cake ordered
- `{{collection_date}}` - Formatted collection date
- `{{collection_time}}` - Collection time
- `{{order_details}}` - Special requests
- `{{instagram_link}}` - Branded Instagram link
- `{{tiktok_link}}` - Branded TikTok link
- `{{facebook_link}}` - Branded Facebook link
- `{{google_review_link}}` - Branded Google Review link
- `{{business_name}}` - LaDun Cakes

## 🎨 Brand Colors

```css
Primary Header: #5f0f40 (Dark Burgundy)
Accent Pink: #F8C9CC (Soft Blush)
Gold Buttons: #C9A13C (Metallic Gold)
Background: #FFFFFF (Clean White)
Text: #2E2E2E (Charcoal Grey)
```

## 📱 Social Media

- **Instagram:** [@laduncakes](https://www.instagram.com/laduncakes)
- **TikTok:** [@laduncakes](https://www.tiktok.com/@laduncakes)
- **Facebook:** [LaDun Cakes](https://www.facebook.com/share/178PimAdRz/?mibextid=wwXIfr)
- **Google Reviews:** [Leave a Review](https://g.page/r/Cbv3t2r3bnosEAE/review)

## 🔧 Technical Details

### Dependencies
- **EmailJS SDK** - Email service integration
- **Google Fonts** - Montserrat typography
- **Vanilla JavaScript** - No frameworks required

### Browser Support
- Chrome 80+
- Firefox 75+
- Safari 13+
- Edge 80+

## 📊 Limitations

### Current Version
- **Storage:** Browser localStorage only
- **EmailJS Free Tier:** 200 emails/month
- **Single User:** Designed for one business
- **Automation:** Requires open browser tab

## 🚀 Future Enhancements

- [ ] Backend database integration
- [ ] Multi-user support
- [ ] Mobile app version
- [ ] Payment processing
- [ ] Advanced analytics
- [ ] Inventory management
- [ ] SMS notifications

## 📝 Documentation

- **Developer Notes:** See `DEVELOPER_NOTES.md` for technical documentation
- **EmailJS Docs:** [EmailJS Documentation](https://www.emailjs.com/docs/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💖 About LaDun Cakes

LaDun Cakes specializes in creating beautiful, handcrafted cakes for life's most special moments. Each cake is made with the finest ingredients, artistry, and care — designed to bring elegance and joy to your celebrations.

---

**Made with 💕 for LaDun Cakes**  
**Created by GitHub Copilot**  
**© 2025 LaDun Cakes**