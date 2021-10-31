import React from 'react';
import PageLayout from "../layouts/PageLayout";
import {Card, PageHeader} from "antd";
import OrdersType from "./Dashboard/OrdersType";
import ShopsSales from "./Dashboard/ShopsSales";
import Chart3 from "./Dashboard/Chart3";
import Chart4 from "./Dashboard/Chart4";
import Chart5 from "./Dashboard/Chart5";
import clientTotalGet from "../requests/Dashboard/ClientTotal";
import clientActiveGet from "../requests/Dashboard/ClientActive";
import shopTotalGet from "../requests/Dashboard/ShopTotal";
import ordersTotalGet from "../requests/Dashboard/OrdersTotal";
import productsTotalGet from "../requests/Dashboard/ProductsTotal";

class Dashboard extends React.Component {
    state = {
        totalClients: 0,
        activeClients: 0,
        totalShops: 0,
        totalOrders: 0,
        totalProducts: 0
    };

    componentDidMount() {
        this.getClientTotal();
        this.getClientActive();
        this.getShopTotal();
        this.getOrderTotal();
        this.getProductTotal();
    }

    getClientTotal = async () => {
        let data = await clientTotalGet();
        if (data['data']['success']) {
            this.setState({
                totalClients: data['data']['data'],
            });
        }
    }

    getOrderTotal = async () => {
        let data = await ordersTotalGet();
        if (data['data']['success']) {
            this.setState({
                totalOrders: data['data']['data'],
            });
        }
    }

    getProductTotal = async () => {
        let data = await productsTotalGet();
        if (data['data']['success']) {
            this.setState({
                totalProducts: data['data']['data'],
            });
        }
    }

    getShopTotal = async () => {
        let data = await shopTotalGet();
        if (data['data']['success']) {
            this.setState({
                totalShops: data['data']['data'],
            });
        }
    }

    getClientActive = async () => {
        let data = await clientActiveGet();
        if (data['data']['success']) {
            this.setState({
                activeClients: data['data']['data'],
            });
        }
    }

    render() {
        return (
            <PageLayout>
                <PageHeader
                    title="Dashboard"
                >
                    <div className="row">
                        <div className="col-md-12 col-sm-12">
                            <Card>
                                <Card.Grid hoverable={false} style={{width: '20%', textAlign: 'center'}}>
                                    <h6>Total clients</h6>
                                    <h1>{this.state.totalClients}</h1>
                                </Card.Grid>
                                <Card.Grid hoverable={false} style={{width: '20%', textAlign: 'center'}}>
                                    <h6>Active clients</h6>
                                    <h1>{this.state.activeClients}</h1>
                                </Card.Grid>
                                <Card.Grid hoverable={false} style={{width: '20%', textAlign: 'center'}}>
                                    <h6>Total shops</h6>
                                    <h1>{this.state.totalShops}</h1>
                                </Card.Grid>
                                <Card.Grid hoverable={false} style={{width: '20%', textAlign: 'center'}}>
                                    <h6>Total products</h6>
                                    <h1>{this.state.totalProducts}</h1>
                                </Card.Grid>
                                <Card.Grid hoverable={false} style={{width: '20%', textAlign: 'center'}}>
                                    <h6>Total orders
                                    </h6>
                                    <h1>{this.state.totalOrders}</h1>
                                </Card.Grid>
                            </Card>
                        </div>
                        <div className="col-md-8 col-sm-12">
                            <OrdersType/>
                        </div>
                        <div className="col-md-4 col-sm-12">
                            <ShopsSales/>
                        </div>
                        {
                            false && (<>
                                <div className="col-md-4 col-sm-12">
                                    <Chart3/>
                                </div>
                                <div className="col-md-4 col-sm-12">
                                    <Chart4/>
                                </div>
                                <div className="col-md-4 col-sm-12">
                                    <Chart5/>
                                </div>
                            </>)
                        }
                    </div>
                </PageHeader>
            </PageLayout>
        );
    }
}

export default Dashboard;
