<?php

namespace App\Providers;

use App\Repositories\AboutRepository;
use App\Repositories\BannerRepository;
use App\Repositories\BrandRepository;
use App\Repositories\CategoryRepository;
use App\Repositories\ClientRepository;
use App\Repositories\CouponRepository;
use App\Repositories\CurrencyRepository;
use App\Repositories\DiscountRepository;
use App\Repositories\FaqRepository;
use App\Repositories\Interfaces\AboutInterface;
use App\Repositories\Interfaces\BannerInterface;
use App\Repositories\Interfaces\BrandInterface;
use App\Repositories\Interfaces\CategoryInterface;
use App\Repositories\Interfaces\ClientInterface;
use App\Repositories\Interfaces\CouponInterface;
use App\Repositories\Interfaces\CurrencyInterface;
use App\Repositories\Interfaces\DiscountInterface;
use App\Repositories\Interfaces\FaqInterface;
use App\Repositories\Interfaces\LanguageInterface;
use App\Repositories\Interfaces\NotificationInterface;
use App\Repositories\Interfaces\OrderInterface;
use App\Repositories\Interfaces\ProductInterface;
use App\Repositories\Interfaces\ShopInterface;
use App\Repositories\Interfaces\StripeInterface;
use App\Repositories\LanguageRepository;
use App\Repositories\NotificationRepository;
use App\Repositories\OrderRepository;
use App\Repositories\ProductRepository;
use App\Repositories\ShopRepository;
use App\Repositories\StripeRepository;
use Illuminate\Support\ServiceProvider;

class RepositoryProvider extends ServiceProvider
{
    /**
     * Register services.
     *
     * @return void
     */
    public function register()
    {
        $this->app->bind(StripeInterface::class, StripeRepository::class);
        $this->app->bind(DiscountInterface::class, DiscountRepository::class);
        $this->app->bind(AboutInterface::class, AboutRepository::class);
        $this->app->bind(ShopInterface::class, ShopRepository::class);
        $this->app->bind(FaqInterface::class, FaqRepository::class);
        $this->app->bind(OrderInterface::class, OrderRepository::class);
        $this->app->bind(BrandInterface::class, BrandRepository::class);
        $this->app->bind(BannerInterface::class, BannerRepository::class);
        $this->app->bind(CategoryInterface::class, CategoryRepository::class);
        $this->app->bind(ClientInterface::class, ClientRepository::class);
        $this->app->bind(CouponInterface::class, CouponRepository::class);
        $this->app->bind(CurrencyInterface::class, CurrencyRepository::class);
        $this->app->bind(LanguageInterface::class, LanguageRepository::class);
        $this->app->bind(NotificationInterface::class, NotificationRepository::class);
        $this->app->bind(ProductInterface::class, ProductRepository::class);
    }

    /**
     * Bootstrap services.
     *
     * @return void
     */
    public function boot()
    {
        //
    }
}
