use mavenfuzzyfactory;

/*-- 1. Viết các truy vấn để cho thấy sự tăng trưởng về mặt số lượng trong website và đưa ra nhận xét

select
	year(website_sessions.created_at) as yr,
    quarter(website_sessions.created_at) as qtr,
    count(distinct website_sessions.website_session_id) as sessions,
    count(distinct orders.order_id) as orders
from website_sessions
	left join orders
		on website_sessions.website_session_id = orders.website_session_id
group by
	year(website_sessions.created_at),
    quarter(website_sessions.created_at)

-- orders tăng trưởng khá mạnh mẽ, sau khoảng 3 năm đã tăng gần 100 lần từ 60 đến 5420 đơn hàng*/


    
/*-- 2. Viết các truy vấn để thể hiện hiện được hiệu quả hoạt động của công ty và đưa ra nhận xét

select
	year(website_sessions.created_at) as yr,
    quarter(website_sessions.created_at) as qtr,
    count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as session_to_order_conv_rate,
    sum(price_usd)/count(distinct orders.order_id) as revenue_per_order,
    sum(price_usd)/count(distinct website_sessions.website_session_id) as revenue_per_session
from website_sessions
	left join orders
		on website_sessions.website_session_id = orders.website_session_id
group by
	year(website_sessions.created_at),
    quarter(website_sessions.created_at)
    
-- ta thấy tỷ lệ chuyển đổi phiên thành đơn đặt hàng, doanh thu trên mỗi dơn đặt hàng và doanh thu trên mỗi phiên đều cho thấy sự tăng trưởng
-- đơn đặt hàng ở câu 1 tăng nên tỷ lệ phiên thành đơn đặt hàng cũng tăng
-- doanh thu trên mỗi dơn đặt hàng tăng cho thấy sự phát triển của hàng bán kèm theo
-- và từ đó thì doanh thu trên mỗi phiên cũng tăng */
    
    
    
/*-- 3. Viết truy vấn để hiển thị sự phát triển của các đối tượng khác nhau và đưa ra nhận xét

select
	year(website_sessions.created_at) as yr,
    quarter(website_sessions.created_at) as qtr,
	count(distinct case when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then orders.order_id else null end) as gsearch_nonbrand_order,
    count(distinct case when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then orders.order_id else null end) as bsearch_nonbrand_order,
	count(distinct case when utm_campaign = 'brand' then orders.order_id else null end) as brand_search_orders,
	count(distinct case when utm_source is null and  http_referer is not null then orders.order_id else null end) as organic_search_orders,
	count(distinct case when utm_source is null and  http_referer is null then orders.order_id else null end) as direct_type_in_orders
from website_sessions
	left join orders
		on website_sessions.website_session_id = orders.website_session_id
group by
	1,2
order by
	1,2
    
-- các đơn đặt hàng theo các tiêu chí đều cho thấy sự tăng trưởng, trong đó mạnh mẽ nhất là gsearch, những tiêu chí còn lại thì ít hơn và khá đồng đều*/
    
    
    
/*-- 4. Viết truy vấn để hiển thị tỷ lệ chuyển đổi phiên thành đơn đặt hàng cho các đối tượng đã viết ở yêu cầu 3 và đưa ra nhận xét

select
	year(website_sessions.created_at) as yr,
    quarter(website_sessions.created_at) as qtr,
	count(distinct case when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then orders.order_id else null end)
		/count(distinct case when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then website_sessions.website_session_id else null end) as gsearch_nonbrand_conv_rt,
    count(distinct case when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then orders.order_id else null end)
		/count(distinct case when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then website_sessions.website_session_id else null end) as bsearch_nonbrand_conv_rt,
	count(distinct case when utm_campaign = 'brand' then orders.order_id else null end) 
		/count(distinct case when utm_campaign = 'brand' then website_sessions.website_session_id else null end) as brand_search_conv_rt,
	count(distinct case when utm_source is null and  http_referer is not null then orders.order_id else null end)
		/count(distinct case when utm_source is null and  http_referer is not null then website_sessions.website_session_id else null end) as organic_search_conv_rt,
	count(distinct case when utm_source is null and  http_referer is null then orders.order_id else null end) 
		/count(distinct case when utm_source is null and  http_referer is null then website_sessions.website_session_id else null end) as direct_type_in_conv_rt
from website_sessions
	left join orders
		on website_sessions.website_session_id = orders.website_session_id
group by
	1,2
order by
	1,2

-- tất cả các tiêu chí đều tăng trưởng tốt và đến thời điểm quý 1 năm 2015 thì đều ở khoảng 8%*/



/*-- 5. Viết truy vấn để thể hiện doanh thu và lợi nhuận theo sản phẩm, tổng doanh thu, tổng lợi nhuận của tất cả các sản phẩm

select
	year(created_at) as yr,
    month(created_at) as mo,
	sum(case when product_id = 1 then price_usd else null end) as mrfuzzy_rev,
    sum(case when product_id = 1 then price_usd - cogs_usd else null end) as mrfuzzy_marg,
    sum(case when product_id = 2 then price_usd else null end) as lovebear_rev,
    sum(case when product_id = 2 then price_usd - cogs_usd else null end) as lovebear_marg,
    sum(case when product_id = 3 then price_usd else null end) as birthdaybear_rev,
    sum(case when product_id = 3 then price_usd - cogs_usd else null end) as birthdaybear_marg,
    sum(case when product_id = 4 then price_usd else null end) as minbear_rev,
    sum(case when product_id = 4 then price_usd - cogs_usd else null end) as minbear_marg,
    sum(price_usd) as total_revenue,
    sum(price_usd - cogs_usd) as total_margin
from order_items
group by
	year(created_at),
    month(created_at)
    
-- tất cả đều tăng trưởng mạnh mẽ, tuy nhiên về các sản phẩm lovebear, birthdaybear, minibear thì không có nhiều dữ liệu để quan sát*/



/*-- 6. Viết truy vấn để tìm hiểu tác động của sản phẩm mới và đưa ra nhận xét

create temporary table product_pageviews
select
	website_session_id,
    website_pageview_id,
    created_at,
	year(created_at) as yr,
    month(created_at) as mo
from website_pageviews
where pageview_url = '/products';
    
create temporary table session_w_next_pageview_id
select 
	product_pageviews.yr,
    product_pageviews.mo,
    product_pageviews.website_session_id,
    min(website_pageviews.website_session_id) as min_next_pageview_id
from product_pageviews
	left join website_pageviews
		on product_pageviews.website_session_id = website_pageviews.website_session_id
        and website_pageviews.website_pageview_id > product_pageviews.website_pageview_id
group by 
	product_pageviews.yr,
    product_pageviews.mo,
    product_pageviews.website_session_id;
    
create temporary table session_w_next_pageview_url    
select 
	session_w_next_pageview_id.yr,
    session_w_next_pageview_id.mo,
	session_w_next_pageview_id.website_session_id,
	website_pageviews.pageview_url as next_pageview_url
from session_w_next_pageview_id
	left join website_pageviews
		on website_pageviews.website_pageview_id = session_w_next_pageview_id.min_next_pageview_id;

select
	yr,
    mo,
    count(distinct session_w_next_pageview_url.website_session_id) as sessions_toproduct_page,
    count(distinct case when session_w_next_pageview_url.next_pageview_url is not null then session_w_next_pageview_url.website_session_id else null end) as click_to_next,
    count(distinct case when session_w_next_pageview_url.next_pageview_url is not null then session_w_next_pageview_url.website_session_id else null end)/count(distinct session_w_next_pageview_url.website_session_id) as clickthrough_rt,
    count(distinct orders.website_session_id) as orders,
    count(distinct orders.website_session_id)/count(distinct session_w_next_pageview_url.website_session_id) as product_to_order_rt
from session_w_next_pageview_url
	left join orders
		on session_w_next_pageview_url.website_session_id = orders.website_session_id
group by yr,mo;

-- Tỷ lệ đang ở trang /products và chuyển qua một trang khác tăng từ 71% - 85%, phần trăm các session đang ở trang /products và chuyển qua trang đặt hàng cũng tăng từ khoảng 8% lên khoảng 14%
-- Với sự tăng trưởng như vậy có thể thấy tác động của sản phẩm mới là khá tốt*/ 



/*-- 7. Viết truy vấn thể hiện mức độ hiệu quả của các cặp sản phẩm được bán kèm và đưa ra nhận xét

create temporary table primary_products
select 
	order_id,
	primary_product_id,
	created_at as ordered_at
from orders
where orders.created_at > '2014-12-05';

select
	primary_products.*,
    order_items.product_id as corss_sell_product_id
from primary_products
	left join order_items
		on order_items.order_id = primary_products.order_id
        and order_items.is_primary_item = 0;

select
	primary_product_id,
    count(distinct order_id) as total_orders,
    count(distinct case when corss_sell_product_id = 1 then order_id else null end) as _xsold_p1,
	count(distinct case when corss_sell_product_id = 2 then order_id else null end) as _xsold_p2,
	count(distinct case when corss_sell_product_id = 3 then order_id else null end) as _xsold_p3,
	count(distinct case when corss_sell_product_id = 4 then order_id else null end) as _xsold_p4,
	count(distinct case when corss_sell_product_id = 1 then order_id else null end)/count(distinct order_id) as p1_xsell_rt,
	count(distinct case when corss_sell_product_id = 2 then order_id else null end)/count(distinct order_id) as p2_xsell_rt,
	count(distinct case when corss_sell_product_id = 3 then order_id else null end)/count(distinct order_id) as p3_xsell_rt,
	count(distinct case when corss_sell_product_id = 4 then order_id else null end)/count(distinct order_id) as p4_xsell_rt
from
(select
	primary_products.*,
    order_items.product_id as corss_sell_product_id
from primary_products
	left join order_items
		on order_items.order_id = primary_products.order_id
        and order_items.is_primary_item = 0
) as primary_w_cross_sell
group by 1;
    
-- sản phẩm 2,3,4 đều được bán kèm với sản phẩm 1 là khá tốt, tốt nhất nhà sản phẩm 4
-- sản phẩm 4 dùng để bán kèm cho các sản phẩm còn lại là tốt nhất, theo sau là sản phẩm 3, sản phẩm 2 vầ sản phẩm 1*/



-- 8. Đưa ra một số nhận xét và các phân tích phía trên (không bắt buộc) và đưa ra nhận xét

-- Có thể thấy công ty đang phát triển khá tốt
-- Các đơn đặt hàng theo tiêu chí gsearch_nonbrand_orders tăng trưởng rất nhanh, ta có thể mở rộng tiêu chí này để tăng thêm đơn hàng
-- Các đơn đặt hàng theo tiêu chí bsearch, brand, organic, direct, tăng trưởng khá đều theo từng quý, có thể thấy đây là các tiêu chí khá tiềm năng trong tương lai, có thể xem xét trong quy mô lâu dài
-- Có thể thêm các sản phẩm bán kèm, có thể sản phẩm này chưa tốt ở thời điểm này nhưng sẽ tốt ở thời điểm khác, hãy tận dụng những sản phẩm mang tính thời vụ đó làm các sản phẩm bán kèm
    