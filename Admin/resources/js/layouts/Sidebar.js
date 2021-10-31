import React, {useState} from 'react';
import {Layout, Menu} from 'antd';
import {
    PieChartOutlined,
    AppstoreAddOutlined,
    ShopOutlined,
    SettingOutlined,
    ShoppingCartOutlined,
    GoldOutlined,
    AppstoreOutlined,
    GlobalOutlined,
    GiftOutlined,
    UsergroupAddOutlined,
    PayCircleOutlined,
    PictureOutlined,
    MobileOutlined,
    NotificationOutlined,
    PercentageOutlined,
    PushpinOutlined
} from '@ant-design/icons';
import {useLocation} from 'react-router-dom'
import {
    Link
} from "react-router-dom";
import {isAllowed} from "../helpers/IsAllowed";

const {Sider} = Layout;
const {SubMenu} = Menu;

const Sidebar = (props) => {
    const [collapsed, setCollapse] = useState(false);
    const location = useLocation();
    const path = location.pathname.split('/');

    return (<Sider theme="light" collapsible collapsed={collapsed} onCollapse={() => {
        setCollapse(!collapsed);
    }}>
        <div className="logo"/>
        <Menu theme="light" defaultSelectedKeys={["/" + path[1]]} defaultOpenKeys={[path[1]]} mode="inline">
            {
                isAllowed("/") && (
                    <Menu.Item key="/" icon={<PieChartOutlined/>}>
                        <Link to="/" className="nav-text">Dashboard</Link>
                    </Menu.Item>
                )
            }
            {
                (isAllowed("/shops") || isAllowed("/shops-categories") || isAllowed("/shops-currencies") || isAllowed("/shops-payments")) && (
                    <SubMenu
                        key={["shops", "shops-categories", "shops-currencies", "shops-payments"].includes(path[1]) ? path[1] : "shops"}
                        icon={<ShopOutlined/>}
                        title="Shops">
                        {
                            isAllowed("/shops") && (
                                <Menu.Item key="/shops"><Link to="/shops" className="nav-text">Shops</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/shops-categories") && (
                                <Menu.Item key="/shops-categories"><Link to="/shops-categories" className="nav-text">Shop
                                    categories</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/shops-currencies") && (
                                <Menu.Item key="/shops-currencies"><Link to="/shops-currencies" className="nav-text">Shop
                                    currencies</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/shops-payments") && (
                                <Menu.Item key="/shops-payments"><Link to="/shops-payments" className="nav-text">Shop
                                    payments</Link></Menu.Item>
                            )
                        }
                    </SubMenu>
                )
            }
            {
                (isAllowed("/brands") || isAllowed("/brands-categories")) && (
                    <SubMenu key={["brands", "brands-categories"].includes(path[1]) ? path[1] : "brands"}
                             icon={<AppstoreAddOutlined/>}
                             title="Brands">
                        {
                            isAllowed("/brands") && (
                                <Menu.Item key="/brands"><Link to="/brands"
                                                               className="nav-text">Brands</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/brands-categories") && (
                                <Menu.Item key="/brands-categories"><Link to="/brands-categories" className="nav-text">Brands
                                    categories</Link></Menu.Item>
                            )
                        }
                    </SubMenu>
                )
            }
            {
                isAllowed("/categories") && (
                    <Menu.Item key="/categories" icon={<AppstoreOutlined/>}>
                        <Link to="/categories" className="nav-text">Product categories</Link>
                    </Menu.Item>
                )
            }
            {
                (isAllowed("/products") || isAllowed("/product-comments")) && (
                    <SubMenu key={["products", "product-comments"].includes(path[1]) ? path[1] : "products"}
                             icon={<GoldOutlined/>}
                             title="Products">
                        {
                            isAllowed("/products") && (
                                <Menu.Item key="/products"><Link to="/products"
                                                                 className="nav-text">Products</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/product-comments") && (
                                <Menu.Item key="/product-comments"><Link to="/product-comments" className="nav-text">Product
                                    comments</Link></Menu.Item>
                            )
                        }
                    </SubMenu>
                )
            }
            {
                isAllowed("/discounts") && (
                    <Menu.Item key="/discounts" icon={<PercentageOutlined/>}>
                        <Link to="/discounts" className="nav-text">Discounts</Link>
                    </Menu.Item>
                )
            }
            {
                (isAllowed("/orders") || isAllowed("/order-statuses") || isAllowed("/order-comments")) && (
                    <SubMenu key={["orders", "order-statuses", "order-comments"].includes(path[1]) ? path[1] : "orders"}
                             icon={<ShoppingCartOutlined/>} title="Orders">
                        {
                            isAllowed("/orders") && (
                                <Menu.Item key="/orders"><Link to="/orders"
                                                               className="nav-text">Orders</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/order-statuses") && (
                                <Menu.Item key="/order-statuses"><Link to="/order-statuses" className="nav-text">Order
                                    statuses</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/order-comments") && (
                                <Menu.Item key="/order-comments"><Link to="/order-comments" className="nav-text">Order
                                    comments</Link></Menu.Item>
                            )
                        }
                    </SubMenu>
                )
            }
            {
                (isAllowed("/payment-methods") || isAllowed("/payment-statuses") || isAllowed("/payments")) && (
                    <SubMenu
                        key={["payment-methods", "payments", "payment-statuses"].includes(path[1]) ? path[1] : "payment-methods"}
                        icon={<PayCircleOutlined/>} title="Payments">
                        {
                            isAllowed("/payment-methods") && (
                                <Menu.Item key="/payment-methods"><Link to="/payment-methods" className="nav-text">Payment
                                    methods</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/payment-statuses") && (
                                <Menu.Item key="/payment-statuses"><Link to="/payment-statuses" className="nav-text">Payment
                                    statuses</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/payments") && (
                                <Menu.Item key="/payments"><Link to="/payments"
                                                                 className="nav-text">Payments</Link></Menu.Item>
                            )
                        }
                    </SubMenu>
                )
            }
            {
                isAllowed("/coupons") && (
                    <Menu.Item key="/coupons" icon={<GiftOutlined/>}>
                        <Link to="/coupons" className="nav-text">Coupons</Link>
                    </Menu.Item>
                )
            }
            {
                isAllowed("/banners") && (
                    <Menu.Item key="/banners" icon={<PictureOutlined/>}>
                        <Link to="/banners" className="nav-text">Banners</Link>
                    </Menu.Item>
                )
            }
            {
                isAllowed("/notifications") && (
                    <Menu.Item key="/notifications" icon={<NotificationOutlined/>}>
                        <Link to="/notifications" className="nav-text">Notifications</Link>
                    </Menu.Item>
                )
            }
            {
                isAllowed("/languages") && (
                    <Menu.Item key="/languages" icon={<GlobalOutlined/>}>
                        <Link to="/languages" className="nav-text">Languages</Link>
                    </Menu.Item>
                )
            }
            {
                (isAllowed("/units") || isAllowed("/time-units") || isAllowed("/currencies")) && (
                    <SubMenu key={["units", "time-units", "currencies"].includes(path[1]) ? path[1] : "units"}
                             icon={<SettingOutlined/>}
                             title="Settings">
                        {
                            isAllowed("/units") && (
                                <Menu.Item key="/units"><Link to="/units" className="nav-text">Units</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/currencies") && (
                                <Menu.Item key="/currencies"><Link to="/currencies"
                                                                   className="nav-text">Currencies</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/time-units") && (
                                <Menu.Item key="/time-units"><Link to="/time-units" className="nav-text">Time
                                    units</Link></Menu.Item>
                            )
                        }
                    </SubMenu>
                )
            }
            {
                (isAllowed("/clients") || isAllowed("/admins") || isAllowed("/roles") || isAllowed("/client-addresses") || isAllowed("/permissions")) && (
                    <SubMenu
                        key={["clients", "admins", "roles", "client-addresses", "permissions"].includes(path[1]) ? path[1] : "admins"}
                        icon={<UsergroupAddOutlined/>} title="Users">
                        {
                            isAllowed("/clients") && (
                                <Menu.Item key="/clients"><Link to="/clients"
                                                                className="nav-text">Clients</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/client-addresses") && (
                                <Menu.Item key="/client-addresses"><Link to="/client-addresses" className="nav-text">Client
                                    addresses</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/admins") && (
                                <Menu.Item key="/admins"><Link to="/admins"
                                                               className="nav-text">Admins</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/roles") && (
                                <Menu.Item key="/roles"><Link to="/roles" className="nav-text">Roles</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/permissions") && (
                                <Menu.Item key="/permissions"><Link to="/permissions"
                                                                    className="nav-text">Permissions</Link></Menu.Item>
                            )
                        }
                    </SubMenu>
                )
            }
            {
                isAllowed("/app-language") && (
                    <SubMenu key={["app-language"].includes(path[1]) ? path[1] : "app-language"}
                             icon={<MobileOutlined/>}
                             title="App settings">
                        <Menu.Item key="/app-language"><Link to="/app-language" className="nav-text">App
                            language</Link></Menu.Item>
                    </SubMenu>
                )
            }
            {
                (isAllowed("/faq") || isAllowed("/about") || isAllowed("/terms") || isAllowed("/privacy")) && (
                    <SubMenu key={["faq", "about", "terms", "privacy"].includes(path[1]) ? path[1] : "faq"}
                             icon={<PushpinOutlined/>}
                             title="Pages settings">
                        {
                            isAllowed("/faq") && (
                                <Menu.Item key="/faq"><Link to="/faq" className="nav-text">FAQ</Link></Menu.Item>
                            )
                        }
                        {
                            isAllowed("/about") && (
                                <Menu.Item key="/about"><Link to="/about" className="nav-text">About</Link></Menu.Item>
                            )
                        }
                        {
                            // <>
                            //     <Menu.Item key="/terms"><Link to="/terms" className="nav-text">Terms of
                            //         condition</Link></Menu.Item>
                            //     <Menu.Item key="/privacy"><Link to="/privacy" className="nav-text">Privacy</Link></Menu.Item>
                            // </>
                        }
                    </SubMenu>
                )
            }
            {
                isAllowed("/medias") && (
                    <Menu.Item key="/medias" icon={<PictureOutlined/>}>
                        <Link to="/medias" className="nav-text">Media</Link>
                    </Menu.Item>
                )
            }
        </Menu>
    </Sider>);
}

export default Sidebar;
