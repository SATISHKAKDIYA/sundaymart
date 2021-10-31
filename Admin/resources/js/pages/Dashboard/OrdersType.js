import React from 'react';
import {Card} from "antd";
import {DualAxes} from '@antv/g2plot';
import clientTotalGet from "../../requests/Dashboard/ClientTotal";
import ordersTotalByStatusGet from "../../requests/Dashboard/OrdersTotalByStatus";

class OrdersType extends React.Component {
    componentDidMount() {
        this.getOrdersTotalByStatus();
    }

    getOrdersTotalByStatus = async () => {
        let data = await ordersTotalByStatusGet();
        if (data['data']['success']) {
            this.dualAxes = new DualAxes('ordersType', {
                data: data['data']['data'],
                xField: 'time',
                yField: ['value', 'count'],
                geometryOptions: [
                    {
                        geometry: 'line',
                        seriesField: 'type',
                        lineStyle: {
                            lineWidth: 3,
                            lineDash: [5, 5],
                        },
                        smooth: true,
                    },
                    {
                        geometry: 'line',
                        seriesField: 'name',
                        point: {},
                    },
                ],
            });

            this.dualAxes.render();
        }
    }

    render() {
        return (
            <Card style={{marginTop: '20px'}}>
                <div id="ordersType"/>
            </Card>);
    }
}

export default OrdersType;
