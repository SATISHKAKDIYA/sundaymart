import React from 'react';
import {Breadcrumb, Button, Checkbox, Form, Input, Layout, TimePicker, PageHeader, Select, Spin, Upload} from "antd";
import {Link} from "react-router-dom";
import PageLayout from "../../layouts/PageLayout";
import shopActive from "../../requests/Shops/ShopActive";
import timeUnitSave from "../../requests/TimeUnits/TimeUnitSave";
import timeUnitGet from "../../requests/TimeUnits/TimeUnitGet";
import * as moment from "moment";

const {Option} = Select;
const {Content} = Layout;

class TimeUnitAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            shops: [],
            time_unit: [],
            active: true,
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false
        };

        this.getActiveShops = this.getActiveShops.bind(this);
        this.changeStatus = this.changeStatus.bind(this);
        this.onChangeTimeUnit = this.onChangeTimeUnit.bind(this);

        this.getActiveShops();

        if (this.state.edit)
            this.getInfoById(this.state.id);
    }

    getInfoById = async (id) => {
        let data = await timeUnitGet(id);
        if (data.data.success) {
            let timeUnit = data.data.data;
            let time_units = timeUnit.name.split("-");
            this.setState({
                active: timeUnit.active == 1 ? true : false,
            });

            this.formRef.current.setFieldsValue({
                sort: timeUnit.sort,
                shop: timeUnit.id_shop,
                time_unit: [
                    moment(time_units[0], 'HH:mm:ss'),
                    moment(time_units[1], 'HH:mm:ss'),
                ]
            });
        }
    }

    getActiveShops = async () => {
        let data = await shopActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                shops: data.data.data,
            });

            this.formRef.current.setFieldsValue({
                shop: data.data.data[0].id
            });
        }
    }

    changeStatus = (e) => {
        this.setState({
            active: e.target.checked
        });
    }

    onFinish = async (values) => {
        var time_units = this.state.time_unit[0] + "-" + this.state.time_unit[1];
        let data = await timeUnitSave(time_units, values.shop, values.sort, this.state.active, this.state.id);

        if (data.data.success == 1)
            window.history.back();
    };

    onFinishFailed = (errorInfo) => {
    };

    onChangeTimeUnit(time, timeString) {
        this.setState({
            time_unit: timeString
        })
    }

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/time-units" className="nav-text">Time Units</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Time Unit Edit" : "Time Unit Add"}
                >
                    <Content
                        className="site-layout-background padding-20">
                        {
                            (this.state.shops.length > 0) ? (<Form
                                ref={this.formRef}
                                name="basic"
                                initialValues={{}}
                                layout="vertical"
                                onFinish={this.onFinish}
                                onFinishFailed={this.onFinishFailed}
                            >
                                <div className="row">
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Time unit" name="time_unit"
                                                   rules={[{required: true, message: 'Missing time unit'}]}
                                                   tooltip="Enter time unit">
                                            <TimePicker.RangePicker onChange={this.onChangeTimeUnit}/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Sort" name="sort"
                                                   rules={[{required: true, message: 'Missing time unit sort'}]}
                                                   tooltip="Enter time unit sort">
                                            <Input placeholder="Sort"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Shop" name="shop"
                                                   rules={[{required: true, message: 'Missing shop'}]}
                                                   tooltip="Select shop">
                                            <Select placeholder="Select shop">
                                                {
                                                    this.state.shops.map((item) => {
                                                        return (
                                                            <Option value={item.id} key={item.id}>{item.name}</Option>);
                                                    })
                                                }
                                            </Select>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Status" name="active"
                                                   tooltip="Uncheck if brand is inactive">
                                            <Checkbox checked={this.state.active}
                                                      onChange={this.changeStatus}>{this.state.active ? "Active" : "Inactive"}</Checkbox>
                                        </Form.Item>
                                    </div>
                                </div>
                                <Form.Item>
                                    <Button type="primary" className="btn-success" style={{marginTop: '40px'}}
                                            htmlType="submit">Save</Button>
                                </Form.Item>
                            </Form>) : (
                                <div className="d-flex flex-row justify-content-center" style={{height: '400px'}}>
                                    <Spin style={{marginTop: 'auto', marginBottom: 'auto'}} size="large"/>
                                </div>)
                        }
                    </Content>
                </PageHeader>
            </PageLayout>
        );
    }
}

export default TimeUnitAdd;
