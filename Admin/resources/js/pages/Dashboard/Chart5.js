import React from 'react';
import {Card} from "antd";
import { Bar } from '@antv/g2plot';

class Chart5 extends React.Component {
    data = [
        { year: '1951 年', value: 38 },
        { year: '1952 年', value: 52 },
        { year: '1956 年', value: 61 },
        { year: '1957 年', value: 145 },
        { year: '1958 年', value: 48 },
    ];

    componentDidMount() {
        this.bar = new Bar('Chart5', {
            data: this.data,
            xField: 'value',
            yField: 'year',
            seriesField: 'year',
            legend: {
                position: 'top-left',
            },
        });

        this.bar.render();
    }

    render() {
        return (
            <Card style={{marginTop: '20px'}}>
                <div id="Chart5"/>
            </Card>);
    }
}

export default Chart5;
