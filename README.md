# Usage

Set a list of categories and budget amounts per category. Every month, you
start out with that amount. Throughout the month, you can text transactions to
a provided phone number (which Twilio forwards on to this application).

> `$100 groceries`
> `$23 eating out Wendy's`

After every message, it will respond back with the new balance:

> You have $400 remaining in your "groceries" budget. That's $14.29 per day for
> the rest of the month.

> Your "eating out" budget is now $277.00. That's $9.89 per day for the rest of
> the month.

This helps you keep track both of the total amount left and a rough per-day
estimate to ensure you don't the entire budget at the beginning of the month.

