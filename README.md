# quantrics.yelp

Yelp Business Locator App for Quantrics

Notes:
- Pull to refresh added to refresh current list
- Review contents seems being cut and shows "..." but it is the actual value retried from the API
eg:
text = "03/01/20- We went out to Taytay today to see my buddies house.  2 years ago it was a work in progress in various stages of construction.  Today it's a...";
text = "My girlfriend and I had a great time with Jay's virtual Valentine's Day magic show. For future reference, whenever Jay is selling a ticket to something, you...";
text = ""
text = "Wow! I am typically skeptical of magic but Jay had me smiling from ear to ear and ultra engaged for a full hour. His show will leave you asking \"how on...";
- List API returns only up to 20 max items as per verification, so some items on the "Default" list of items (No search text / No filter) might not show when search and filter criterias are set. The API will just return the 20 most relevant items.
- For distance, Meter was retrieved and converted to Kilomoters.
- For time, API return string value in this format "HHSS" eg, "2200", "1400". Formatted displayed value.
