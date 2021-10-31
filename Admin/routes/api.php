<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use \App\Http\Controllers\AuthController;
use \App\Http\Controllers\UploadController;
use \App\Http\Controllers\LanguageController;
use \App\Http\Controllers\ShopsController;
use \App\Http\Controllers\BrandController;
use \App\Http\Controllers\CategoryController;
use \App\Http\Controllers\UnitController;
use \App\Http\Controllers\TimeUnitsController;
use \App\Http\Controllers\ProductController;
use \App\Http\Controllers\ClientController;
use \App\Http\Controllers\AddressController;
use \App\Http\Controllers\AdminController;
use \App\Http\Controllers\RolePermissionController;
use \App\Http\Controllers\PaymentController;
use \App\Http\Controllers\OrderController;
use \App\Http\Controllers\BannerController;
use \App\Http\Controllers\CouponController;
use \App\Http\Controllers\AppSettingsController;
use \App\Http\Controllers\ExtraGroupController;
use \App\Http\Controllers\ExtraController;
use \App\Http\Controllers\Mobile;
use \App\Http\Controllers\ShopCategoriesController;
use \App\Http\Controllers\CurrencyController;
use \App\Http\Controllers\ShopsCurrienciesController;
use \App\Http\Controllers\NotificationsController;
use \App\Http\Controllers\DiscountController;
use \App\Http\Controllers\PaymentsController;
use \App\Http\Controllers\ShopPaymentController;
use \App\Http\Controllers\BrandCategoriesController;
use \App\Http\Controllers\MediaController;
use \App\Http\Controllers\ProductsCharactericsController;
use \App\Http\Controllers\FaqController;
use \App\Http\Controllers\AboutController;
use \App\Http\Controllers\PrivacyController;
use \App\Http\Controllers\TermsController;
use \App\Http\Controllers\AdminNotificationsController;
use \App\Http\Controllers\MessageController;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::group([
    'middleware' => 'api',
    'prefix' => 'auth'
], function ($router) {
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/upload', [UploadController::class, 'upload']);

    //language
    Route::post('/language/save', [LanguageController::class, 'save']);
    Route::post('/language/datatable', [LanguageController::class, 'datatable']);
    Route::post('/language/delete', [LanguageController::class, 'delete']);
    Route::post('/language/get', [LanguageController::class, 'get']);
    Route::post('/language/default', [LanguageController::class, 'makeDefault']);
    Route::post('/language/active', [LanguageController::class, 'active']);

    //shops
    Route::post('/shop/save', [ShopsController::class, 'save']);
    Route::post('/shop/datatable', [ShopsController::class, 'datatable']);
    Route::post('/shop/get', [ShopsController::class, 'get']);
    Route::post('/shop/delete', [ShopsController::class, 'delete']);
    Route::post('/shop/active', [ShopsController::class, 'active']);

    //brands
    Route::post('/brand/save', [BrandController::class, 'save']);
    Route::post('/brand/datatable', [BrandController::class, 'datatable']);
    Route::post('/brand/get', [BrandController::class, 'get']);
    Route::post('/brand/active', [BrandController::class, 'active']);
    Route::post('/brand/delete', [BrandController::class, 'delete']);

    //categories
    Route::post('/category/parent', [CategoryController::class, 'parent']);
    Route::post('/category/save', [CategoryController::class, 'save']);
    Route::post('/category/datatable', [CategoryController::class, 'datatable']);
    Route::post('/category/delete', [CategoryController::class, 'delete']);
    Route::post('/category/get', [CategoryController::class, 'get']);
    Route::post('/category/active', [CategoryController::class, 'active']);

    //units
    Route::post('/unit/get', [UnitController::class, 'get']);
    Route::post('/unit/save', [UnitController::class, 'save']);
    Route::post('/unit/datatable', [UnitController::class, 'datatable']);
    Route::post('/unit/delete', [UnitController::class, 'delete']);
    Route::post('/unit/active', [UnitController::class, 'active']);

    //time units
    Route::post('/time-unit/get', [TimeUnitsController::class, 'get']);
    Route::post('/time-unit/save', [TimeUnitsController::class, 'save']);
    Route::post('/time-unit/datatable', [TimeUnitsController::class, 'datatable']);
    Route::post('/time-unit/delete', [TimeUnitsController::class, 'delete']);
    Route::post('/time-unit/active', [TimeUnitsController::class, 'active']);

    //products
    Route::post('/product/get', [ProductController::class, 'get']);
    Route::post('/product/save', [ProductController::class, 'save']);
    Route::post('/product/active', [ProductController::class, 'active']);
    Route::post('/product/datatable', [ProductController::class, 'datatable']);
    Route::post('/product/delete', [ProductController::class, 'delete']);
    Route::post('/product/comments', [ProductController::class, 'commentsDatatable']);
    Route::post('/product/comments/delete', [ProductController::class, 'commentsDelete']);

    //clients
    Route::post('/client/datatable', [ClientController::class, 'datatable']);
    Route::post('/client/delete', [ClientController::class, 'delete']);
    Route::post('/client/active', [ClientController::class, 'active']);
    Route::post('/client/save', [ClientController::class, 'save']);

    //admin
    Route::post('/admin/datatable', [AdminController::class, 'datatable']);
    Route::post('/admin/delete', [AdminController::class, 'delete']);
    Route::post('/admin/save', [AdminController::class, 'save']);
    Route::post('/admin/get', [AdminController::class, 'get']);
    Route::post('/admin/delivery-boy/active', [AdminController::class, 'deliveryBoyActive']);

    // create manager
    Route::post('/manager/save', [AdminController::class, 'create']);
    Route::post('/manager/activate', [AdminController::class, 'activate']);


    //addresses
    Route::post('/address/datatable', [AddressController::class, 'datatable']);
    Route::post('/address/delete', [AddressController::class, 'delete']);
    Route::post('/address/active', [AddressController::class, 'active']);
    Route::post('/address/save', [AddressController::class, 'save']);

    //roles
    Route::post('/role/active', [RolePermissionController::class, 'roles']);
    Route::post('/role/datatable', [RolePermissionController::class, 'datatable']);

    //permissions
    Route::post('/permission/datatable', [RolePermissionController::class, 'permissionDatatable']);
    Route::post('/permission/save', [RolePermissionController::class, 'save']);
    Route::post('/permission/savepermission', [RolePermissionController::class, 'savepermission']);
    Route::post('/permission/deletepermission', [RolePermissionController::class, 'deletepermission']);
    Route::post('/permission/getpermission', [RolePermissionController::class, 'getpermission']);

    //payments
    Route::post('/payment/method', [PaymentController::class, 'methodDatatable']);
    Route::post('/payment/method/active', [PaymentController::class, 'activeMethod']);
    Route::post('/payment/status', [PaymentController::class, 'statusDatatable']);
    Route::post('/payment/status/active', [PaymentController::class, 'activeStatus']);

    //orders
    Route::post('/order/status', [OrderController::class, 'statusDatatable']);
    Route::post('/order/status/active', [OrderController::class, 'activeStatus']);
    Route::post('/order/save', [OrderController::class, 'save']);
    Route::post('/order/get', [OrderController::class, 'get']);
    Route::post('/order/datatable', [OrderController::class, 'datatable']);
    Route::post('/order/delete', [OrderController::class, 'delete']);
    Route::post('/order/comments', [OrderController::class, 'commentsDatatable']);

    //banners
    Route::post('/banner/save', [BannerController::class, 'save']);
    Route::post('/banner/get', [BannerController::class, 'get']);
    Route::post('/banner/delete', [BannerController::class, 'delete']);
    Route::post('/banner/datatable', [BannerController::class, 'datatable']);

    //coupons
    Route::post('/coupon/save', [CouponController::class, 'save']);
    Route::post('/coupon/datatable', [CouponController::class, 'datatable']);
    Route::post('/coupon/delete', [CouponController::class, 'delete']);
    Route::post('/coupon/get', [CouponController::class, 'get']);

    //app settings
    Route::post('/app-language/datatable', [AppSettingsController::class, 'appLanguageDatatable']);
    Route::post('/app-language/datatableWord', [AppSettingsController::class, 'appLanguageDatatableWord']);
    Route::post('/app-language/save', [AppSettingsController::class, 'save']);

    //extra group
    Route::post('/extra-group/types', [ExtraGroupController::class, 'types']);
    Route::post('/extra-group/save', [ExtraGroupController::class, 'save']);
    Route::post('/extra-group/datatable', [ExtraGroupController::class, 'datatable']);
    Route::post('/extra-group/delete', [ExtraGroupController::class, 'delete']);
    Route::post('/extra-group/get', [ExtraGroupController::class, 'get']);
    Route::post('/extra-group/active', [ExtraGroupController::class, 'active']);

    //extra
    Route::post('/extra/save', [ExtraController::class, 'save']);
    Route::post('/extra/datatable', [ExtraController::class, 'datatable']);
    Route::post('/extra/delete', [ExtraController::class, 'delete']);
    Route::post('/extra/get', [ExtraController::class, 'get']);

    // shop categories
    Route::post('/shop-category/save', [ShopCategoriesController::class, 'save']);
    Route::post('/shop-category/datatable', [ShopCategoriesController::class, 'datatable']);
    Route::post('/shop-category/get', [ShopCategoriesController::class, 'get']);
    Route::post('/shop-category/active', [ShopCategoriesController::class, 'active']);
    Route::post('/shop-category/delete', [ShopCategoriesController::class, 'delete']);

    // currency
    Route::post('/currency/save', [CurrencyController::class, 'save']);
    Route::post('/currency/datatable', [CurrencyController::class, 'datatable']);
    Route::post('/currency/delete', [CurrencyController::class, 'delete']);
    Route::post('/currency/get', [CurrencyController::class, 'get']);
    Route::post('/currency/active', [CurrencyController::class, 'active']);

    // Shops Curriencies
    Route::post('/shops-currency/save', [ShopsCurrienciesController::class, 'save']);
    Route::post('/shops-currency/datatable', [ShopsCurrienciesController::class, 'datatable']);
    Route::post('/shops-currency/delete', [ShopsCurrienciesController::class, 'delete']);
    Route::post('/shops-currency/get', [ShopsCurrienciesController::class, 'get']);
    Route::post('/shops-currency/currency', [ShopsCurrienciesController::class, 'currency']);
    Route::post('/shops-currency/change', [ShopsCurrienciesController::class, 'change']);


    // notifications
    Route::post('/notification/save', [NotificationsController::class, 'save']);
    Route::post('/notification/datatable', [NotificationsController::class, 'datatable']);
    Route::post('/notification/delete', [NotificationsController::class, 'delete']);
    Route::post('/notification/get', [NotificationsController::class, 'get']);
    Route::post('/notification/send', [NotificationsController::class, 'sendNotification']);

    // products characterics
    Route::post('/products-characterics/save', [ProductsCharactericsController::class, 'save']);
    Route::post('/products-characterics/datatable', [ProductsCharactericsController::class, 'datatable']);
    Route::post('/products-characterics/delete', [ProductsCharactericsController::class, 'delete']);
    Route::post('/products-characterics/get', [ProductsCharactericsController::class, 'get']);

    // discount
    Route::post('/discount/save', [DiscountController::class, 'save']);
    Route::post('/discount/datatable', [DiscountController::class, 'datatable']);
    Route::post('/discount/delete', [DiscountController::class, 'delete']);
    Route::post('/discount/get', [DiscountController::class, 'get']);

    // brand categories
    Route::post('/brand-category/save', [BrandCategoriesController::class, 'save']);
    Route::post('/brand-category/datatable', [BrandCategoriesController::class, 'datatable']);
    Route::post('/brand-category/get', [BrandCategoriesController::class, 'get']);
    Route::post('/brand-category/active', [BrandCategoriesController::class, 'active']);
    Route::post('/brand-category/delete', [BrandCategoriesController::class, 'delete']);

    // payments
    Route::post('/payments/save', [PaymentsController::class, 'save']);
    Route::post('/payments/datatable', [PaymentsController::class, 'datatable']);
    Route::post('/payments/delete', [PaymentsController::class, 'delete']);
    Route::post('/payments/get', [PaymentsController::class, 'get']);
    Route::post('/payments/active', [PaymentsController::class, 'active']);

    // shop payment
    Route::post('/shop-payment/save', [ShopPaymentController::class, 'save']);
    Route::post('/shop-payment/datatable', [ShopPaymentController::class, 'datatable']);
    Route::post('/shop-payment/delete', [ShopPaymentController::class, 'delete']);
    Route::post('/shop-payment/get', [ShopPaymentController::class, 'get']);

    // media
    Route::post('/media/media', [MediaController::class, 'media']);
    Route::post('/media/delete', [MediaController::class, 'delete']);
    Route::post('/media/get', [MediaController::class, 'get']);

    //faq
    Route::post('/faq/save', [FaqController::class, 'save']);
    Route::post('/faq/datatable', [FaqController::class, 'datatable']);
    Route::post('/faq/get', [FaqController::class, 'get']);
    Route::post('/faq/delete', [FaqController::class, 'delete']);

    //about
    Route::post('/about/save', [AboutController::class, 'save']);
    Route::post('/about/datatable', [AboutController::class, 'datatable']);
    Route::post('/about/get', [AboutController::class, 'get']);

    //privacy
    Route::post('/privacy/save', [PrivacyController::class, 'save']);
    Route::post('/privacy/datatable', [PrivacyController::class, 'datatable']);
    Route::post('/privacy/get', [PrivacyController::class, 'get']);
    Route::post('/privacy/delete', [PrivacyController::class, 'delete']);

    //terms
    Route::post('/terms/save', [TermsController::class, 'save']);
    Route::post('/terms/datatable', [TermsController::class, 'datatable']);
    Route::post('/terms/get', [TermsController::class, 'get']);
    Route::post('/terms/delete', [TermsController::class, 'delete']);

    // admin notifications
    Route::post('/admin-notifications/datatable', [AdminNotificationsController::class, 'datatable']);
    Route::post('/admin-notifications/get', [AdminNotificationsController::class, 'get']);
    Route::post('/admin-notifications/delete', [AdminNotificationsController::class, 'delete']);

    //dashboard
    Route::post('/dashboard/client/total', [ClientController::class, 'getTotalClientsCount']);
    Route::post('/dashboard/client/active', [OrderController::class, 'getActiveClients']);
    Route::post('/dashboard/shops/total', [ShopsController::class, 'getTotalShopsCount']);
    Route::post('/dashboard/orders/total', [OrderController::class, 'getTotalOrdersCount']);
    Route::post('/dashboard/products/total', [ProductController::class, 'getTotalProductsCount']);
    Route::post('/dashboard/orders/totalByStatus', [OrderController::class, 'getOrdersStaticByStatus']);
    Route::post('/dashboard/orders/totalByShops', [OrderController::class, 'getShopsSalesInfo']);
});

// API's for mobile use
Route::group([
    'middleware' => 'api',
    'prefix' => 'm'
], function ($router) {
    Route::post('/upload', [UploadController::class, 'upload']);
    // clients
    Route::post('/client/signup', [Mobile\ClientController::class, 'signup']);
    Route::post('/client/update', [Mobile\ClientController::class, 'update']);
    Route::post('/client/login', [Mobile\ClientController::class, 'login']);
    Route::post('/client/save-push', [Mobile\ClientController::class, 'savePushToken']);

    // brands
    Route::post('/brand/get', [Mobile\BrandsController::class, 'get']);
    Route::post('/brand/products', [Mobile\BrandsController::class, 'products']);
    Route::post('/brand/categories', [Mobile\BrandsController::class, 'categories']);

    // categories
    Route::post('/category/products', [Mobile\CategoriesController::class, 'products']);
    Route::post('/category/categories', [Mobile\CategoriesController::class, 'categories']);

    // product
    Route::post('/product/product', [Mobile\ProductController::class, 'product']);
    Route::post('/product/products', [Mobile\ProductController::class, 'products']);
    Route::post('/product/selected', [Mobile\ProductController::class, 'selected']);
    Route::post('/product/categories', [Mobile\ProductController::class, 'categories']);
    Route::post('/product/extra', [Mobile\ProductController::class, 'extraData']);
    Route::post('/product/coupon', [Mobile\CouponController::class, 'coupon']);
    Route::post('/product/discount', [Mobile\DiscountController::class, 'discount']);

    // product comments
    Route::post('/product/comments', [Mobile\ProductController::class, 'comments']);

    // order comments
    Route::post('/order/comments', [Mobile\OrderController::class, 'comments']);
    Route::post('/order/save', [Mobile\OrderController::class, 'save']);
    Route::post('/order/history', [Mobile\OrderController::class, 'allOrderByStatus']);
    Route::post('/order/count', [Mobile\OrderController::class, 'getNewOrderCount']);
    Route::post('/order/cancel', [Mobile\OrderController::class, 'orderCancel']);

    // shops curriencies
    Route::post('/currency/currency', [Mobile\CurrencyController::class, 'active']);

    // shops
    Route::post('/shops/timeunits', [Mobile\ShopsController::class, 'timeunits']);
    Route::post('/shops/user', [Mobile\ShopsController::class, 'getShopUser']);
    Route::get('/shops/categories', [Mobile\ShopsController::class, 'categories']);
    Route::post('/shops/shops', [Mobile\ShopsController::class, 'shops']);

    // language
    Route::post('/language/active', [Mobile\LanguageController::class, 'active']);
    Route::post('/language/language', [Mobile\LanguageController::class, 'language']);

    // banner
    Route::post('/banner/banners', [Mobile\BannerController::class, 'banners']);
    Route::post('/banner/products', [Mobile\BannerController::class, 'products']);

    // notifications
    Route::post('/notification/notifications', [Mobile\NotificationsController::class, 'notifications']);

    // faq
    Route::post('/faq/faq', [Mobile\FaqController::class, 'faq']);

    // about
    Route::post('/about/about', [Mobile\AboutController::class, 'about']);

    //chat
    Route::post('/chat/dialog', [MessageController::class, 'dialog']);
    Route::post('/chat/send', [MessageController::class, 'sendMessage']);
});



