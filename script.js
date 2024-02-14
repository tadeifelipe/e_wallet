import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
    stages: [
      { duration: '10s', target: 100 },
      { duration: '10s', target: 200 }, 
      { duration: '10s', target: 300 }, 
      { duration: '10s', target: 400 }, 
      { duration: '10s', target: 500 },
      { duration: '10s', target: 400 },
      { duration: '10s', target: 200 },
      { duration: '10s', target: 100 },
    ]
  };

export default function () {
  const apiUrl = 'http://localhost:4000/api/v1/accounts/deposit';

  const token = 'SFMyNTY.g2gDdAAAAAF3B3VzZXJfaWRhAW4GABFBnKeNAWIAAVGA.VdIwPAvJBTJaOxVHPYdsWdfFIhGwxJT0-hlmll0ySoM';

  const payload = {
    "value": "50.00",
    "type": "bank_deposit"
  };

  const headers = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`,
  };

  let response = http.post(apiUrl, JSON.stringify(payload), { headers: headers });

  if (response.status !== 200) {
    console.error(`Request failed with status ${response.status}: ${response.body}`);
  }

  sleep(1);
}