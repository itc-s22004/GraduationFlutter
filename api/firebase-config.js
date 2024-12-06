// api/firebase-config.js (VercelのAPIルート)
export default function handler(req, res) {
  res.status(200).json({
    apiKey: process.env.api_key,
    appId: process.env.app_id,
    storageBucket: process.env.storage_bucket,
    messagingSenderId: process.env.messaging_sender_id,
    projectId: process.env.project_id,
    authDomain: process.env.auth_domain,
    measurementId: process.env.measurement_id,
  });
}

