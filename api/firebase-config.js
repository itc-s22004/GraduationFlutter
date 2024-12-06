// api/firebase-config.js (VercelのAPIルート)
export default function handler(req, res) {
  res.status(200).json({
    apiKey: process.env.API_KEY,
    appId: process.env.APP_ID,
    storageBucket: process.env.STORAGE_BUCKET,
    messagingSenderId: process.env.MESSAGING_SENDER_ID,
    projectId: process.env.PROJECT_ID,
    authDomain: process.env.AUTH_DOMAIN,
    measurementId: process.env.MEASUREMENT_ID,
  });
}
