import React from 'react';
import {Card} from "antd";
import {Bar} from '@antv/g2plot';
import shopSalesGet from "../../requests/Dashboard/ShopSales";

class ShopsSales extends React.Component {
    componentDidMount() {
        this.getShopSales();
    }

    getShopSales = async () => {
        let data = await shopSalesGet();
        if (data['data']['success']) {
            this.bar = new Bar('shopsSales', {
                data: data['data']['data'],
                xField: 'value',
                yField: 'shop',
                seriesField: 'shop',
                legend: {
                    position: 'top-left',
                },
            });

            this.bar.render();
        }
    }

    render() {
        return (
            <Card style={{marginTop: '20px'}}>
                <div id="shopsSales"/>
            </Card>);
    }
}

export default ShopsSales;
