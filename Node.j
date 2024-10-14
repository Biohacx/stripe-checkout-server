const stripe = require('stripe')('sk_test_51Q8MRqGSjZtAURCZksvd18sFnmQHX7p2PBaLcAYKJBu3FuAIOA5ErqL97laTLYMsm3ACVLGTenjEj71e2iYtrSPg00Jw4nMLqy'); // Vervang dit met je eigen private Stripe key
const express = require('express');
const app = express();
app.use(express.static('public'));
app.use(express.json());

// Root route om te bevestigen dat de server draait
app.get('/', (req, res) => {
  res.send('Server is running. Go to /create-checkout-session to start a session.');
});

// Route om een Stripe Checkout-sessie aan te maken
app.post('/create-checkout-session', async (req, res) => {
  const session = await stripe.checkout.sessions.create({
    payment_method_types: ['ideal', 'card'], // Voeg iDEAL en kaarten toe als betaalmethoden
    line_items: [
      {
        price_data: {
          currency: 'eur',
          product_data: {
            name: 'Plan to Improve Mental Health',
          },
          unit_amount: req.body.price, // De prijs in centen (bijv. 500 = €5)
        },
        quantity: 1,
      },
    ],
    mode: 'payment',
    success_url: 'https://www.biohacx.com/', // Pas dit aan naar jouw succes-URL
    cancel_url: 'https://www.biohacx.com/',  // Pas dit aan naar jouw annulerings-URL
  });

  res.json({ id: session.id });
});

// Zet de server op om te luisteren op poort 3000
app.listen(3000, () => console.log('Server running on port 3000'));
