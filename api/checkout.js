const stripe = require('stripe')('sk_test_51Q8MRqGSjZtAURCZksvd18sFnmQHX7p2PBaLcAYKJBu3FuAIOA5ErqL97laTLYMsm3ACVLGTenjEj71e2iYtrSPg00Jw4nMLqy');

export default async function handler(req, res) {
  if (req.method === 'POST') {
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['ideal', 'card'],
      line_items: [
        {
          price_data: {
            currency: 'eur',
            product_data: {
              name: 'Plan to Improve Mental Health',
            },
            unit_amount: req.body.price,
          },
          quantity: 1,
        },
      ],
      mode: 'payment',
      success_url: 'https://www.biohacx.com/',
      cancel_url: 'https://www.biohacx.com/',
    });
    res.status(200).json({ id: session.id });
  } else {
    res.setHeader('Allow', ['POST']);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}
