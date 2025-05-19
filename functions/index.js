/**
 * Firebase Functions for DormMate
 */

const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {onRequest} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const SibApiV3Sdk = require("@getbrevo/brevo");

// .env dosyasından ortam değişkenlerini yükle
require("dotenv").config();

admin.initializeApp();

// API anahtarını .env dosyasından al
const BREVO_API_KEY = process.env.BREVO_API_KEY || "";

// E-posta gönderim ayarları
const FROM_NAME = "DormMate";
const FROM_EMAIL = "dormatesu@gmail.com";

/**
 * Satın alma onayı e-postası gönderir
 */
exports.sendPurchaseConfirmationEmail = onDocumentCreated({
  document: "user_purchases/{purchaseId}",
  region: "europe-west1",
},
async (event) => {
  const purchaseData = event.data.data();

  if (!purchaseData) {
    console.error("No data associated with the event");
    return;
  }

  const userEmail = purchaseData.userEmail;
  const membershipType = purchaseData.membershipType;

  if (!userEmail || !membershipType) {
    console.error(
        "Missing email or membership type:",
        event.params.purchaseId,
    );
    return;
  }

  console.log(`Sending confirmation to ${userEmail} for ${membershipType}`);

  try {
    // Brevo API istemcisini yapılandır
    const apiInstance = new SibApiV3Sdk.TransactionalEmailsApi();
    const apiKey = apiInstance.authentications["apiKey"];
    apiKey.apiKey = BREVO_API_KEY;

    // E-posta içeriğini hazırla
    const sendSmtpEmail = new SibApiV3Sdk.SendSmtpEmail();
    sendSmtpEmail.subject = "DormMate Üyelik Satın Alma Onayı";
    sendSmtpEmail.htmlContent = `
        <p>Merhaba,</p>
        <p>DormMate uygulamasında <strong>${membershipType}</strong>
          üyeliğiniz başarıyla oluşturulmuştur.</p>
        <p>Uygulamamızı tercih ettiğiniz için teşekkür ederiz!</p>
        <p>Sevgiler,</p>
        <p>DormMate Ekibi</p>
      `;
    sendSmtpEmail.sender = {name: FROM_NAME, email: FROM_EMAIL};
    sendSmtpEmail.to = [{email: userEmail}];

    // E-postayı gönder
    const result = await apiInstance.sendTransacEmail(sendSmtpEmail);
    console.log("Purchase confirmation sent to:", userEmail, result);
  } catch (error) {
    console.error("Error sending purchase email:", error);
  }
},
);

/**
 * Geri bildirim e-postaları gönderir
 */
exports.sendFeedbackEmail = onDocumentCreated({
  document: "user_feedback/{feedbackId}",
  region: "europe-west1",
},
async (event) => {
  const feedbackData = event.data.data();

  if (!feedbackData) {
    console.error("No data associated with the event");
    return;
  }

  const userEmail = feedbackData.userEmail;
  const feedbackText = feedbackData.feedbackText;

  if (!userEmail || !feedbackText) {
    console.error(
        "Missing email or feedback text:",
        event.params.feedbackId,
    );
    return;
  }

  console.log(`Processing feedback from ${userEmail}`);

  try {
    // Brevo API istemcisini yapılandır
    const apiInstance = new SibApiV3Sdk.TransactionalEmailsApi();
    const apiKey = apiInstance.authentications["apiKey"];
    apiKey.apiKey = BREVO_API_KEY;

    // Kullanıcıya teşekkür e-postası gönder
    const sendSmtpEmail = new SibApiV3Sdk.SendSmtpEmail();
    sendSmtpEmail.subject = "DormMate - Geri Bildiriminiz Alındı";
    sendSmtpEmail.htmlContent = `
        <p>Merhaba,</p>
        <p>DormMate uygulaması hakkındaki değerli geri bildiriminiz 
          için teşekkür ederiz!</p>
        <p>Geri bildiriminiz ekibimiz tarafından incelenecektir.</p>
        <p>Sevgiler,</p>
        <p>DormMate Ekibi</p>
      `;
    sendSmtpEmail.sender = {name: FROM_NAME, email: FROM_EMAIL};
    sendSmtpEmail.to = [{email: userEmail}];

    // E-postayı gönder
    const result = await apiInstance.sendTransacEmail(sendSmtpEmail);
    console.log("Feedback confirmation sent to:", userEmail, result);
  } catch (error) {
    console.error("Error sending confirmation:", error);
  }

  try {
    // Brevo API istemcisini yapılandır
    const apiInstance = new SibApiV3Sdk.TransactionalEmailsApi();
    const apiKey = apiInstance.authentications["apiKey"];
    apiKey.apiKey = BREVO_API_KEY;

    // Yöneticiye geri bildirim detayı gönder
    const sendSmtpEmail = new SibApiV3Sdk.SendSmtpEmail();
    sendSmtpEmail.subject = "Yeni Kullanıcı Geri Bildirimi Aldınız!";
    sendSmtpEmail.htmlContent = `
        <p>Merhaba,</p>
        <p>DormMate uygulaması üzerinden yeni bir geri bildirim aldınız:</p>
        <p><strong>E-posta:</strong> ${userEmail}</p>
        <p><strong>Geri Bildirim:</strong></p>
        <pre>${feedbackText}</pre>
        <p>İyi çalışmalar,</p>
        <p>DormMate Sistem</p>
      `;
    sendSmtpEmail.sender = {name: FROM_NAME, email: FROM_EMAIL};
    sendSmtpEmail.to = [{email: "dormatesu@gmail.com"}];

    // E-postayı gönder
    const result = await apiInstance.sendTransacEmail(sendSmtpEmail);
    console.log("Feedback details sent to admin:", result);
  } catch (error) {
    console.error("Error sending admin notification:", error);
  }
},
);

/**
 * Test fonksiyonu - e-posta göndermek için doğrudan HTTP tetikleyici
 */
exports.testSendEmail = onRequest({
  region: "europe-west1",
}, async (request, response) => {
  try {
    // Brevo API istemcisini yapılandır
    const apiInstance = new SibApiV3Sdk.TransactionalEmailsApi();
    const apiKey = apiInstance.authentications["apiKey"];
    apiKey.apiKey = BREVO_API_KEY;

    // Test e-postası gönder
    const sendSmtpEmail = new SibApiV3Sdk.SendSmtpEmail();
    sendSmtpEmail.subject = "DormMate - Mail Testi";
    sendSmtpEmail.htmlContent = 
        "<p>Bu bir test e-postasıdır. Eğer bunu görüyorsanız, " +
        "e-posta gönderimi çalışıyor demektir.</p>";
    sendSmtpEmail.sender = {name: FROM_NAME, email: FROM_EMAIL};
    sendSmtpEmail.to = [{email: "efe.guclu@sabanciuniv.edu"}];

    // E-postayı gönder
    const result = await apiInstance.sendTransacEmail(sendSmtpEmail);

    console.log("Test e-postası gönderim sonucu:", result);
    response.send({
      success: true,
      message: "Test e-postası gönderildi. Lütfen gelen kutunuzu kontrol edin.",
      result: result,
    });
  } catch (error) {
    console.error("Test e-posta gönderimi hatası:", error);
    response.status(500).send({
      success: false,
      error: error.message,
      details: error,
    });
  }
});




