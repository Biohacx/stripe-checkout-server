const stripe = require('stripe')('sk_test_51Q8MRqGSjZtAURCZksvd18sFnmQHX7p2PBaLcAYKJBu3FuAIOA5ErqL97laTLYMsm3ACVLGTenjEj71e2iYtrSPg00Jw4nMLqy'); // Je private Stripe key
const express = require('express');
const app = express();
app.use(express.static('public'));
app.use(express.json());

// Root route
app.get('/', (req, res) => {
  res.send('Server is running. To start a session, POST to /create-checkout-session.');
});

// Route voor Stripe Checkout-sessie
app.post('/create-checkout-session', async (req, res) => {
  const session = await stripe.checkout.sessions.create({
    payment_method_types: ['ideal', 'card'],
    line_items: [
      {
        price_data: {
          currency: 'eur',
          product_data: {
            name: 'Plan to Improve Mental Health',
          },
          unit_amount: req.body.price, // Prijs in centen
        },
        quantity: 1,
      },
    ],
    mode: 'payment',
    success_url: 'https://www.biohacx.com/',
    cancel_url: 'https://www.biohacx.com/',
  });

  res.json({ id: session.id });
});

app.listen(3000, () => console.log('Server running on port 3000'));
