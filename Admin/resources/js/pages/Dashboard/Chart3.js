import React from 'react';
import {Card} from "antd";
import { Column } from '@antv/g2plot';


class Chart3 extends React.Component {
    data = [
        { type: '1-3秒', value: 0.16 },
        { type: '4-10秒', value: 0.125 },
        { type: '11-30秒', value: 0.24 },
        { type: '31-60秒', value: 0.19 },
        { type: '1-3分', value: 0.22 },
        { type: '3-10分', value: 0.05 },
        { type: '10-30分', value: 0.01 },
        { type: '30+分', value: 0.015 },
    ];

    paletteSemanticRed = '#F4664A';
    brandColor = '#5B8FF9';

    componentDidMount() {
        this.columnPlot = new Column('chart3', {
            data: this.data,
            xField: 'type',
            yField: 'value',
            seriesField: '',
            color: ({ type }) => {
                if (type === '10-30分' || type === '30+分') {
                    return this.paletteSemanticRed;
                }
                return this.brandColor;
            },
            label: {
                content: (originData) => {
                    const val = parseFloat(originData.value);
                    if (val < 0.05) {
                        return (val * 100).toFixed(1) + '%';
                    }
                },
                offset: 10,
            },
            legend: false,
            xAxis: {
                label: {
                    autoHide: true,
                    autoRotate: false,
                },
            },
        });

        this.columnPlot.render();
    }

    render() {
        return (
            <Card style={{marginTop: '20px'}}>
                <div id="chart3"/>
            </Card>);
    }
}

export default Chart3;
