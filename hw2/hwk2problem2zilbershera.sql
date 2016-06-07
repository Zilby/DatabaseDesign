/* 
a) 3 Databases are created.

b) The names of the databases are ap, ex, and om. 
-ap has tables: general_ledger_accounts, invoice_archive, invoice_line_items, 
invoices, terms, vendor_contacts, and vendors. 
-ex has tables: active_invoices, color_sample, customers, date_sample, 
departments, employees, float_sample, null_sample, paid_invoices, projects, 
and string_sample
-om has tables: customers, items, order_details and orders

c) The script inserts 68 records into the order_details table

d) The primary key for om.customers is customer_id

e)*/

-- 2.f
SELECT * FROM om.orders;

-- 2.g
SELECT title, artist FROM om.items
