// api/firebase-config.js (VercelのAPIルート)
export default function handler(req, res) {
  // CORSを許可
  res.setHeader('Access-Control-Allow-Origin', '*'); // 必要に応じて許可するドメインに変更
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE'); // 許可するHTTPメソッド
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type'); // 許可するヘッダー

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


